module Enumerable
  # Each
  def my_each
    unless block_given?
      return to_enum(__method__)
    end
    for item in self
      yield item
    end
  end

  # Each with index
  def my_each_with_index
    i = 0
    unless block_given?
      return to_enum(__method__)
    end
    for item in self
      yield *item, i
      i += 1
    end
  end

  # Select
  def my_select
    unless block_given?
      return to_enum(__method__)
    end
    res = []
    my_each do |v| res.push(v) if yield(v) end
    return res
  end

  # All
  def my_all?(pattern = nil)
    if block_given?
      my_each { |v| return false unless yield(v) }
    elsif pattern != nil
      my_each { |v| return false unless pattern.match(v.to_s) }
    else
      my_each { |v| return false unless v }
    end
    return true
  end

  # Any
  def my_any?(pattern = nil)
    if block_given?
      my_each { |v| return false unless yield(v) }
    elsif pattern != nil
      my_each { |v| return false unless pattern.match(v.to_s) }
    else
      my_each { |v| return true if v }
      return false
    end
    return true
  end

  # None
  def my_none?(pattern = nil)
    if block_given?
      my_each { |v| return false if yield(v) }
    elsif pattern != nil
      my_each { |v| return false if pattern.match(v.to_s) }
    else
      my_each { |v| return false if v }
    end
    return true
  end

  # Count
  def my_count(item = nil)
    res = 0
    if block_given?
      my_each { |v| res += 1 if yield(v) }
    elsif item != nil
      my_each { |v| res += 1 if v == item }
    else
      res = size
    end
    return res
  end

  # Map
  def my_map(proc = nil)
    res = []
    if proc
      my_each { |v| res.push(proc.call(v)) }
    elsif block_given?
      my_each { |v| res.push(yield(v)) }
    else
      return to_enum(__method__)
    end
    return res
  end

  # Inject
  def my_inject(p1 = nil, p2 = nil)
    enum = my_each
    if p1 && !(p1.is_a? Symbol)
      memo = p1
    else
      memo = enum.peek
      enum = enum.drop(1)
    end
    sym = p1 && (p1.is_a? Symbol) ? p1 : (p2 && (p2.is_a? Symbol) ? p2 : nil)
    unless block_given?
      m = method(sym) if sym
      enum.my_each { |v| memo = m.call(memo, v)}
    else
      enum.my_each { |v| memo = yield(memo, v)}
    end
    return memo
  end

  # Multiply array items
  def multiply_els(*args)
    res = 1
    for i in args
      res *= i
    end
    return res
  end
end

# TESTS

# class MyArray < Array
#   include Enumerable
# end

# class MyHash < Hash
#   include Enumerable
# end

# MyArray[1,2,2,3,5,8,9].my_each {|i| puts i}
# MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_each {|k| puts "#{k}"}

# MyArray[1,2,2,3,5,8,9].my_each_with_index {|v, i| puts "#{v} at index #{i}"}
# MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_each_with_index {|k, v, i| puts "#{k}: #{v} at index #{i}"}

# print MyArray[1,2,2,3,5,8,9].my_select { |v| v.odd? }
# print MyHash[ "author", "Fabien", :v, "1.0", :l, "Ruby", :rate, 5].my_select { |k, v| v.is_a? Integer }

# print MyArray[1,2,2,3,5,8,9].my_all? { |v| v % 3 == 0 }
# print MyArray[1,2,2,3,5,8,9].my_all?(/\D/)
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_all? { |k, v| v.is_a? Integer }
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_all?(/\d/)

# print MyArray[nil, false].my_any?
# print MyArray[1,2,nil,3,5,8,9].my_any? { |v| v || v == nil }
# print MyArray[1,2,4,3,5,8,9].my_any?(/\d/)
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_any?
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_any? { |k, v| v.length > 3 }

# print MyArray[nil, false].my_none?
# print MyArray[1,2,nil,3,5,8,9].my_none? { |v| v && v > 10 }
# print MyArray[1,2,4,3,5,8,9].my_none?(/\D/)
# print MyHash[].my_none?
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_none? { |k, v| v.length < 3 }

# print MyArray[1,2,4,3,5,8,9].my_count
# print MyArray[1,2,2,3,5,8,9].my_count(2)
# print MyArray[1,2,3,3,7,8,9].my_count{|v| v < 6}
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_count

# print MyArray[1,2,4,3,5,8,9].my_map.first(5)
# print MyArray[1,2,4,3,5,8,9].my_map { |v| v * 2 }
# print MyArray[1,2,4,3,5,8,9].my_map(Proc.new { |v| v * 3 })
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_map.first(2)
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_map { |k, v| [k.to_s.to_sym, v * 3] }
# print MyHash[ :a, "Fabien", :v, "1.0", :l, "Ruby"].my_map(Proc.new { |k, v| v })

# puts MyArray[2,5,6].my_inject(:multiply_els)
# puts MyArray[2,5,6].my_inject(4, :multiply_els)
# puts MyArray[2,5,6].my_inject { |sum, v| sum * v}
# puts MyArray[2,5,6].my_inject(5) { |sum, v| sum * v}