# Worker

Thread safe inter-process workers using Ruby Queue

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
