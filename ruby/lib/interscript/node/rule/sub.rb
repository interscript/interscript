class Interscript::Node::Rule::Sub < Interscript::Node::Rule
  attr_accessor :from, :to
  attr_accessor :before, :not_before, :after, :not_after
  attr_accessor :priority

  def initialize from, to, before: nil, not_before: nil, after: nil, not_after: nil, priority: nil
    self.from = Interscript::Node::Item.try_convert from
    if to == :upcase
      self.to = :upcase
    else
      self.to = Interscript::Node::Item.try_convert to
    end

    self.priority = priority

    #raise TypeError, "Can't supply both before and not_before" if before && not_before
    #raise TypeError, "Can't supply both after and not_after" if after && not_after

    self.before = Interscript::Node::Item.try_convert(before) if before
    self.after = Interscript::Node::Item.try_convert(after) if after
    self.not_before = Interscript::Node::Item.try_convert(not_before) if not_before
    self.not_after = Interscript::Node::Item.try_convert(not_after) if not_after
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
    }

    hash[:before] = self.before&.to_hash if self.before
    hash[:not_before] = self.not_before&.to_hash if self.not_before
    hash[:after] = self.after&.to_hash if self.after
    hash[:not_after] = self.not_after&.to_hash if self.not_after
    hash[:priority] = self.priority if self.priority

    hash
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
    params << "before: #{@before.inspect}" if @before
    params << "after: #{@after.inspect}" if @after
    params << "not_before: #{@not_before.inspect}" if @not_before
    params << "not_after: #{@not_after.inspect}" if @not_after
    params << "priority: #{@priority.inspect}" if @priority
    out << params.join(", ")
  end
end
