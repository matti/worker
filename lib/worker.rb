class Worker
  class Ctx
  end

  class Defer
    def initialize(&block)
      @value = Queue.new

      Thread.new do
        @value.push block.call
      end
    end

    def value
      @value.pop
    end
  end

  def initialize(&block)
    @in = Queue.new
    @out = Queue.new
    @block = block
    @ctx = Worker::Ctx.new
    @defers = Queue.new

    run!
  end

  def perform(*args)
    @in.push args

    ret = @out.pop
    if ret.is_a? Exception
      raise ret
    else
      ret
    end
  end

  def perform_async(*args)
    defer = Defer.new do
      ret = perform(*args)
      @defers.pop
      ret
    end
    @defers.push defer
    defer
  end

  def join
    loop do
      break if @defers.size == 0
      sleep 0.1
    end
  end

  def run!
    @thread = Thread.new do
      loop do
        ret = @ctx.instance_exec *@in.pop, &@block
        @out.push ret
      rescue Exception => ex
        @out.push ex
      end
    end
    self
  end

  def stop!
    @thread&.kill
    self
  end
end
