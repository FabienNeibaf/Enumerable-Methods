# Patching Enumerable module with custom methods
module Enumerable
  # Each
  def my_each
    return to_enum(__method__) unless block_given?

    for item in self
      yield item
    end
  end

  # Each with index
  def my_each_with_index
    i = 0
    return to_enum(__method__) unless block_given?

    for item in self
      yield(*item, i)
      i += 1
    end
  end

  # Select
  def my_select
    return to_enum(__method__) unless block_given?

    res = []
    my_each { |v| res.push(v) if yield(v) }
    res
  end

  # All
  def my_all?(pattern = nil)
    if block_given?
      my_each { |v| return false unless yield(v) }
    elsif !pattern.nil?
      my_each { |v| return false unless pattern.match(v.to_s) }
    else
      my_each { |v| return false unless v }
    end
    true
  end

  # Any
  def my_any?(pattern = nil)
    if block_given?
      my_each { |v| return true if yield(v) }
    elsif !pattern.nil?
      my_each { |v| return true if pattern.match(v.to_s) }
    else
      my_each { |v| return true if v }
      return false
    end
    false
  end

  # None
  def my_none?(pattern = nil)
    if block_given?
      my_each { |v| return false if yield(v) }
    elsif !pattern.nil?
      my_each { |v| return false if pattern.match(v.to_s) }
    else
      my_each { |v| return false if v }
    end
    true
  end

  # Count
  def my_count(item = nil)
    res = 0
    if block_given?
      my_each { |v| res += 1 if yield(v) }
    elsif !item.nil?
      my_each { |v| res += 1 if v == item }
    else
      res = size
    end
    res
  end

  # Map
  def my_map
    res = []
    return to_enum(__method__) unless block_given?

    my_each { |v| res.push(yield v) }
    res
  end

  # Inject
  def my_inject(*args)
    if block_given?
      memo = args[0] || shift
      my_each { |v| memo = yield(memo, v) }
    else
      sym = args.last
      memo = args[1] ? args[0] : shift
      my_each { |v| memo = method(sym).call(memo, v) } if sym
    end
    memo
  end

  # Multiply array items
  def multiply_els(*args)
    res = 1
    for i in args
      res *= i
    end
    res
  end
end

# TESTS

# [1, 2, 2, 3, 5, 8, 9].my_each { |i| puts i }
# { a: 'Fabien', v: '1.0', l: 'Ruby' }.my_each { |k| puts k.to_s }

# [1, 2, 2, 3, 5, 8, 9].my_each_with_index { |v, i| puts "#{v} at index #{i}" }
# { a: 'Fabien', v: '1.0', l: 'Ruby' }
#   .my_each_with_index { |k, v, i| puts "#{k}: #{v} at index #{i}" }

# print [1, 2, 2, 3, 5, 8, 9].my_select(&:odd?)
# print({ 'author' => 'Fabien', v: '1.0', l: 'Ruby', rate: 5 }
#   .my_select { |_k, v| v.is_a? Integer })

# print([1, 2, 2, 3, 5, 8, 9].my_all? { |v| (v % 3).zero? })
# print [1, 2, 2, 3, 5, 8, 9].my_all?(/\D/)
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_all? { |_k, v| v.is_a? Integer })
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_all?(/\d/))

# print [nil, false].my_any?
# print([1, 2, nil, 3, 5, 8, 9].my_any? { |v| v || v.nil? })
# print [1, 2, 4, 3, 5, 8, 9].my_any?(/\d/)
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_any?)
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_any? { |_k, v| v.length > 3 })

# print [nil, false].my_none?
# print([1, 2, nil, 3, 5, 8, 9].my_none? { |v| v && v > 10 })
# print [1, 2, 4, 3, 5, 8, 9].my_none?(/\D/)
# print [].my_none?
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_none? { |_k, v| v == 'Fabien' })

# print [1, 2, 4, 3, 5, 8, 9].my_count
# print [1, 2, 2, 3, 5, 8, 9].my_count(0)
# print([1, 2, 3, 3, 7, 8, 9].my_count { |v| v < 6 })
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_count)

# print [1, 2, 4, 3, 5, 8, 9].my_map.first(5)
# print([1, 2, 4, 3, 5, 8, 9].my_map { |v| v * 2 })
# print [1, 2, 4, 3, 5, 8, 9].my_map(&proc { |v| v * 3 })
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_map.first(2))
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }
#   .my_map { |k, v| [k.to_s.to_sym, v * 3] })
# print({ a: 'Fabien', v: '1.0', l: 'Ruby' }.my_map(&proc { |_k, v| v }))

# puts [2, 5, 6].my_inject(:multiply_els)
# puts [2, 5, 6].my_inject(4, :multiply_els)
# puts([2, 5, 6].my_inject { |prod, v| prod * v })
# puts([2, 5, 6].my_inject(5) { |prod, v| prod * v })
