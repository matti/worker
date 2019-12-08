# Worker

Thread safe inter-process synchronous workers using Ruby Queue

    adder = Worker.new do |a,b|
      a + b
    end

    multiplier = Worker.new do |a,b|
      a * b
    end

    puts adder.perform 1, 2
    # => 3
    puts multiplier.perform 10, 2
    # => 20

Scoped instance variables:

    adder_memo = Worker.new do |a,b|
      @sum ||= 0
      @sum += a + b
    end

    puts adder_memo.perform 1, 2
    # => 3
    puts adder_memo.perform 1, 2
    # => 6
