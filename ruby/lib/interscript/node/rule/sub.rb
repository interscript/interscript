class Interscript::Node::Rule::Sub < Interscript::Node::Rule
  attr_accessor :from, :to
  attr_accessor :before, :not_before, :after, :not_after
  attr_accessor :reverse_before, :reverse_not_before, :reverse_after, :reverse_not_after
  attr_accessor :reverse_run
  attr_accessor :priority

  def initialize (from, to,
                  before: nil, not_before: nil,
                  after: nil, not_after: nil,
                  reverse_before: nil, reverse_not_before: nil,
                  reverse_after: nil, reverse_not_after: nil,
                  priority: nil, reverse_run: nil)
    self.from = Interscript::Node::Item.try_convert from
    if to == :upcase
      self.to = :upcase
    else
      self.to = Interscript::Node::Item.try_convert to
    end

    self.priority = priority

    #raise TypeError, "Can't supply both before and not_before" if before && not_before
    #raise TypeError, "Can't supply both after and not_after" if after && not_after

    self.reverse_run = reverse_run

    self.before = Interscript::Node::Item.try_convert(before) if before
    self.after = Interscript::Node::Item.try_convert(after) if after
    self.not_before = Interscript::Node::Item.try_convert(not_before) if not_before
    self.not_after = Interscript::Node::Item.try_convert(not_after) if not_after

    self.reverse_before = Interscript::Node::Item.try_convert(reverse_before) if reverse_before
    self.reverse_after = Interscript::Node::Item.try_convert(reverse_after) if reverse_after
    self.reverse_not_before = Interscript::Node::Item.try_convert(reverse_not_before) if reverse_not_before
    self.reverse_not_after = Interscript::Node::Item.try_convert(reverse_not_after) if reverse_not_after
  end

  def max_length
    len = self.from.max_length
    len += self.before.max_length if self.before
    len += self.after.max_length if self.after
    len += self.not_before.max_length if self.not_before
    len += self.not_after.max_length if self.not_after
    len += self.priority if self.priority
    len
  end

  def to_hash
    puts self.from.inspect if $DEBUG
    puts params.inspect if $DEBUG
    hash = { :class => self.class.to_s,
      :from => self.from.to_hash,
      :to => Symbol === self.to ? self.to : self.to.to_hash
      :reverse_run => self.reverse_run,
      :before => self.before&.to_hash,
      :not_before => self.not_before&.to_hash,
      :after => self.after&.to_hash,
      :not_after => self.not_after&.to_hash,
      :reverse_before => self.reverse_before&.to_hash,
      :reverse_not_before => self.reverse_not_before&.to_hash,
      :reverse_after => self.reverse_after&.to_hash,
      :reverse_not_after => self.reverse_not_after&.to_hash,
      :priority => self.priority
    }

    hash[:before] = self.before&.to_hash if self.before
    hash[:not_before] = self.not_before&.to_hash if self.not_before
    hash[:after] = self.after&.to_hash if self.after
    hash[:not_after] = self.not_after&.to_hash if self.not_after
    hash[:priority] = self.priority if self.priority

    hash
  end

  def reverse
    if to == :upcase
      xfrom = :upcase
      xto = from.downcase
    else
      xfrom, xto = from, to
    end
    Interscript::Node::Rule::Sub.new(xto, xfrom,
      before: reverse_before, after: reverse_after,
      not_before: reverse_not_before, not_after: reverse_not_after,

      reverse_before: before, reverse_after: after,
      reverse_not_before: not_before, reverse_not_after: not_after,

      reverse_run: reverse_run.nil? ? nil : !reverse_run,

      priority: priority
    )
  end

  def inspect
    out = "sub "
    params = []
    params << @from.inspect
    if @to == :upcase
      params << "upcase"
    else
      params << @to.inspect
    end
    params << "reverse_run: #{@reverse_run.inspect}" unless @reverse_run.nil?

    params << "before: #{@before.inspect}" if @before
    params << "after: #{@after.inspect}" if @after
    params << "not_before: #{@not_before.inspect}" if @not_before
    params << "not_after: #{@not_after.inspect}" if @not_after

    params << "reverse_before: #{@reverse_before.inspect}" if @reverse_before
    params << "reverse_after: #{@reverse_after.inspect}" if @reverse_after
    params << "reverse_not_before: #{@reverse_not_before.inspect}" if @reverse_not_before
    params << "reverse_not_after: #{@reverse_not_after.inspect}" if @reverse_not_after

    params << "priority: #{@priority.inspect}" if @priority
    out << params.join(", ")
  end
end
