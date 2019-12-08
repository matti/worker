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

  def initialize(opts={}, &block)
    @in = Queue.new
    @out = Queue.new
    @block = block
    @ctx = Worker::Ctx.new
    @defers = Queue.new

    @retries = 0
    @retry = opts.dig(:retry) || 0
    @backoff = opts.dig(:backoff) || 0.1
    @backoff_max = opts.dig(:backoff_max)
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
  rescue Exception => ex
    raise ex if @retries == @retry
    @retries += 1
    sleeping = @retries * @backoff
    sleeping = @backoff_max if @backoff_max && sleeping > @backoff_max

    sleep sleeping
    retry
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
