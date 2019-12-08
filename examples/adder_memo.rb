require_relative "../lib/worker"

adder_memo = Worker.new do |a,b|
  @sum ||= 0
  @sum += a + b
end

puts adder_memo.perform 1, 2
# => 3
puts adder_memo.perform 1, 2
# => 6
