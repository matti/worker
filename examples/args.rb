require_relative "../lib/worker"

binary = Worker.new do |a,b|
  raise "binary: a not integer" unless a.is_a? Integer
  raise "binary: b not integer" unless b.is_a? Integer
end

unary = Worker.new do |a|
  raise "unary: a not integer" unless a.is_a? Integer
end

unary_array = Worker.new do |a|
  raise "unary_array: a not array" unless a.is_a? Array
end

binary.perform 1, 2
unary.perform 1
unary_array.perform [1]

puts "ok"
