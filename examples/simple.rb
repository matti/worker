require_relative "../lib/worker"

adder = Worker.new do |a,b|
  a + b
end

multiplier = Worker.new do |a,b|
  a * b
end

puts adder.perform 1, 2
puts multiplier.perform 10, 2
