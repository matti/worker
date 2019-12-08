class Worker
  def initialize(&block)
    @in = Queue.new
    @out = Queue.new
    @block = block
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

  def run!
    @thread = Thread.new do
      loop do
        ret = @block.call @in.pop
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
