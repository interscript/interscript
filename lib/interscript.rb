# frozen_string_literal: true

require "maps" if RUBY_ENGINE == "opal"
require "interscript/mapping"

# Transliteration
module Interscript

  class InvalidSystemError < StandardError; end
  class ExternalProcessNotRecognizedError < StandardError; end
  class ExternalProcessUnavailableError < StandardError; end

  module Opal
    ALPHA_REGEXP = '\p{L}'

    def mkregexp(regexpstring)
      flags = 'u'
      if regexpstring.include? "(?i)"
        regexpstring = regexpstring.gsub("(?i)", "").gsub("(?-i)", "")
        flags = 'ui'
      end
      Regexp.new("/#{regexpstring}/#{flags}")
    end

    def sub_replace(string, pos, size, repl)
      (pos.positive? ? string[0, pos - 1] : "") + repl + string[pos + size..-1]
    end

    def external_processing(mapping, string)
      string
    end

  end

  module Fs
    ALPHA_REGEXP = '[[:alpha:]]'

    def sub_replace(string, pos, size, repl)
      string[pos..pos + size - 1] = repl
      string
    end

    def root_path
      @root_path ||= Pathname.new(File.dirname(__dir__))
    end

    def transliterate_file(system_code, input_file, output_file, maps={})
      input = File.read(input_file)
      output = transliterate(system_code, input, maps)

      File.open(output_file, 'w') do |f|
        f.puts(output)
      end

      puts "Output written to: #{output_file}"
      output_file
    end

    def import_python_modules
      begin
        pyimport :g2pwrapper
      rescue
        pyimport :sys
        sys.path.append(root_path.to_s + "/lib/")
        pyimport :g2pwrapper
      end
    end

    def external_process(process_name, string)
      import_python_modules

      case process_name
      when 'sequitur.pythainlp_lexicon'
        return g2pwrapper.transliterate('pythainlp_lexicon', string)
      when 'sequitur.wiktionary_phonemic'
        return g2pwrapper.transliterate('wiktionary_phonemic', string)
      else
        raise ExternalProcessNotRecognizedError.new
      end

    rescue
      raise ExternalProcessUnavailableError.new
    end

    def external_processing(mapping, string)
      # Segmentation
      string = external_process(mapping.segmentation, string) if mapping.segmentation

      # Transliteration/Transcription
      string = external_process(mapping.transcription, string) if mapping.transcription

      string
    end

    private

    def mkregexp(regexpstring)
      /#{regexpstring}/u
    end

  end

  if RUBY_ENGINE == 'opal'
    extend Opal
  else
    extend Fs
  end

  class << self

    def transliterate(system_code, string, maps={})
      unless maps.has_key? system_code
        maps[system_code] = Interscript::Mapping.for(system_code)
      end
      # mapping = Interscript::Mapping.for(system_code)
      mapping = maps[system_code]

      # First, apply chained transliteration as specified in the list `chain`
      chain = mapping.chain.dup
      while chain.length > 0
        string = transliterate(chain.shift, string, maps)
      end

      # Then, apply the rest of the map
      separator = mapping.character_separator || ""
      word_separator = mapping.word_separator || ""
      title_case = mapping.title_case
      downcase = mapping.downcase

      # charmap = mapping.characters&.sort_by { |k, _v| k.size }&.reverse&.to_h
      # dictmap = mapping.dictionary&.sort_by { |k, _v| k.size }&.reverse&.to_h
      charmap = mapping.characters_hash
      dictmap = mapping.dictionary_hash
      trie = mapping.dictionary_trie

      string = external_processing(mapping, string)

      pos = 0
      while pos < string.to_s.size
        m = 0
        wordmatch = ""

        # Using Trie, find the longest matching substring
        while (pos + m < string.to_s.size) && (trie.partial_word?string[pos..pos+m])
          wordmatch = string[pos..pos+m] if trie.word?string[pos..pos+m]
          m += 1
        end

        m = wordmatch.length
        if m > 0
          repl = dictmap[string[pos..pos+m-1]]
          string = sub_replace(string, pos, m, repl)
          pos += repl.length
        else
          pos += 1
        end
      end

      output = string.clone
      offsets = Array.new string.to_s.size, 1

      # mapping.rules.each do |r|
      #   string.to_s.scan(/#{r['pattern']}/) do |matches|
      #     match = Regexp.last_match
      #     pos = match.offset(0).first
      #     result = r['result'].clone
      #     matches.each.with_index { |v, i| result.sub!(/\\#{i + 1}/, v) } if matches.is_a? Array
      #     result.upcase! if up_case_around?(string, pos)
      #     output[offsets[0...pos].sum, match[0].size] = result
      #     offsets[pos] += result.size - match[0].size
      #   end
      # end

      mapping.rules.each do |r|
        next unless output
        re = mkregexp(r["pattern"])
        output = output.gsub(re, r["result"])
      end

      charmap.each do |k, v|
        while (match = output&.match(/#{k}/))
          pos = match.offset(0).first
          result = !downcase && up_case_around?(output, pos) ? v.upcase : v

          # if more than one, choose the first one
          result = result[0] if result.is_a?(Array)

          output = sub_replace(
            output,
            pos,
            match[0].size,
            add_separator(separator, pos, result)
          )
        end
      end

      mapping.postrules.each do |r|
        next unless output
        re = mkregexp(r["pattern"])
        output = output.gsub(re, r["result"])
      end

      return unless output

      output = output.sub(/^(.)/, &:upcase) if title_case
      if word_separator != ''
        output = output.gsub(/#{word_separator}#{separator}/u, word_separator)

        if title_case
          output = output.gsub(/#{word_separator}(.)/u, &:upcase)
        end
      end

      output.unicode_normalize
    end

    private

    def add_separator(separator, pos, result)
      pos == 0 ? result : separator + result
    end

    def up_case_around?(string, pos)
      return false if string[pos] == string[pos].downcase

      i = pos - 1
      i -= 1 while i.positive? && string[i] !~ Regexp.new(ALPHA_REGEXP)
      before = i >= 0 && i < pos ? string[i].to_s.strip : ''

      i = pos + 1
      i += 1 while i < string.size - 1 && string[i] !~ Regexp.new(ALPHA_REGEXP)
      after = i > pos ? string[i].to_s.strip : ''

      before_uc = !before.empty? && before == before.upcase
      after_uc = !after.empty? && after == after.upcase
      # before_uc && (after.empty? || after_uc) || after_uc && (before.empty? || before_uc)
      before_uc || after_uc
    end

  end
end
