#!/usr/bin/env ruby
require 'optparse'
require 'fileutils'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: bootstrap.rb [options]"

  opts.on("-v", "--version [ver]", "Get a set compatible with a version (eg. 2.4)") do |v|
    options[:version] = v
  end

  opts.on("-u", "--upstream [url]", "Fetch packages from a different upstream") do |v|
    options[:upstream] = v
  end

  opts.on("-o", "--only [glob]", "Only bootstrap the packages described by a glob (* and , characters supported)") do |v|
    options[:only] = Regexp.new(Regexp.escape(v).gsub('\*', '.*?').gsub('\,', '|'))
  end
end.parse!

nildev = Gem.win_platform? ? 'NUL' : '/dev/null'

options[:upstream] ||= `git remote get-url origin 2>#{nildev}`.reverse.split('/', 2).dig(1).reverse
options[:upstream] = nil if options[:upstream] == ''
options[:upstream] ||= 'https://github.com/interscript'

repos = {
  'ruby': {repo: "#{options[:upstream]}/interscript-ruby.git"},
  'js': {repo: "#{options[:upstream]}/interscript-js.git"},
  'python': {repo: "#{options[:upstream]}/interscript-python.git"},

  'maps': {repo: "#{options[:upstream]}/maps.git"},

  'api': {repo: "#{options[:upstream]}/interscript-api.git", versioned: false},
  'website': {repo: "#{options[:upstream]}/interscript.org.git", versioned: false},
}

if ENV['GITHUB_ACTIONS']
  repo = ENV['GITHUB_REPOSITORY']
  base_ref = ENV['GITHUB_BASE_REF']
  base_ref = ENV['GITHUB_REF'] if [nil, ''].include? base_ref
  head_ref = ENV['GITHUB_HEAD_REF']
  head_ref = ENV['GITHUB_REF'] if [nil, ''].include? head_ref

  if base_ref =~ %r{^(?:refs/(?:heads|tags)/)?v([0-9]+\.[0-9]+)}
    options[:version] = $1
  end

  head_ref = head_ref.gsub("refs/heads/", "")

  case repo
  when 'interscript/interscript-ruby'
    repos[:ruby][:ref] = head_ref
  when 'interscript/interscript-js'
    repos[:js][:ref] = head_ref
  when 'interscript/interscript-python'
    repos[:python][:ref] = head_ref
  when 'interscript/maps'
    repos[:maps][:ref] = head_ref
  end
end

def inside(dir, &block)
  oldpwd = Dir.pwd
  Dir.chdir dir
  yield
  Dir.chdir oldpwd
end

inside __dir__ do
  repos.each do |name, cfg|
    name = name.to_s
    repo = cfg[:repo]
    branch = options[:version] ? "v#{options[:version]}" : "main"
    branch = "main" if cfg[:versioned] == false
    branch = cfg[:branch] if cfg[:branch]

    next if options[:only] && name !~ options[:only]

    if File.directory? "#{name}/.git"
      # Already set up, let's try to maybe modify it
      inside name do
        `git remote set-url origin #{repo}`
        `git fetch origin`
        `git checkout -B main origin/main`
        `git checkout -B #{branch} origin/#{branch}` if branch != 'main'

        if cfg[:ref]
          `git checkout #{cfg[:ref]}`
        end
      end
    else
      FileUtils.rm_rf(name) rescue nil
      FileUtils.mkdir_p(parent = File.dirname(name))
      inside parent do
        `git clone #{repo} #{File.basename(name)}`
        inside File.basename(name) do
          `git fetch origin`
          `git checkout -B main origin/main`
          `git checkout -B #{branch} origin/#{branch}` if branch != 'main'

          if cfg[:ref]
            `git checkout #{cfg[:ref]}`
          end
        end
      end
    end
  end
end


