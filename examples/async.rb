require_relative "../lib/worker"

async_adder = Worker.new do |a,b|
  sleep 0.25
  a+b
end

async_adder_puts = Worker.new do |a,b|
  sleep 0.25
  puts a+b
end

defer = async_adder.perform_async 1, 2
print "result is: "
puts defer.value

puts "random order putsing:"
5.times do |i|
  async_adder_puts.perform_async(i, 1)
end
async_adder_puts.join
