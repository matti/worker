require_relative "../lib/worker"

raiser = Worker.new do
  raise "always"
end

begin
  raiser.perform
rescue
  puts "did raise"
end

did_retry = 0
begin
  retryer = Worker.new retry: 1 do
    puts "about to raise: #{did_retry}"
    did_retry += 1
    raise "always"
  end
end

begin
  retryer.perform
rescue
end

puts "---"

did_retry = 0
backoff_retryer = Worker.new retry: 8, backoff: 0.1, backoff_max: 0.5 do
  puts "about to raise: #{did_retry}"
  did_retry += 1
  raise "always"
end

begin
  backoff_retryer.perform
rescue
end

puts "ok"
