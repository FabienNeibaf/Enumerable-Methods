require './main.rb'

RSpec.describe Enumerable do
  it 'loops through elements of an enumerable object' do
    res = []
    [1, 2, 3, 4].my_each { |v| res.push(v * 2) }
    expect(res).to eql([2, 4, 6, 8])
  end

  it 'returns an array of elements fulfilling the condition in a block' do
    res = [1, 2, 3, 4].my_select { |v| v.odd? }
    expect(res).to eql([1, 3])
  end

  it 'returns an array of returned elements from a block' do
    res = [1, 2, 3, 4].my_map { |v| v.odd? }
    expect(res).to eql([true, false, true, false])
  end

  # my_all?
  it 'checks if all elements in array satisify the condition' do
    res = [1, 2, 3, 4, 5].my_all? { |x| x > 0 }
    expect(res).to eql(true)
  end

  it 'checks if all elements in array satisify the condition' do
    res = [10, 20, -30, 40, 50].my_all? { |x| x > 0 }
    expect(res).to eql(false)
  end

  # my_any?
  it 'checks if any elements in array satisify the condition' do
    res = [10, 20, -130, 40, 50].my_any? { |x| x < 0 }
    expect(res).to eql(true)
  end

  it 'checks if any elements in array satisify the condition' do
    res = [10, 20, 130, 40, 50].my_any? { |x| x < 0 }
    expect(res).to eql(false)
  end

  # my_count
  it 'returns the number of elements in the array that satisfy the condition' do
    res = [10, 20, 30, 130, 40, 50].my_count { |x| x > 100 }
    expect(res).to eql(1)
  end

  it 'returns the number of elements in the array that satisfy the condition' do
    res = [10, 20, 30, 130, 40, 50].my_count { |x| x < 100 }
    expect(res).to eql(5)
  end
end
