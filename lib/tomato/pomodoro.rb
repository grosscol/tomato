module Tomato

  class Pomodoro
    attr_reader :subject, :rest_time, :work_time

    def initialize(subject, work_time, rest_time)
      @subject = subject
      @work_time = work_time
      @rest_time = rest_time
    end

    def add_before_start(&block)
      before_start_hooks << block
      self
    end

    def add_after_work(&block)
      after_work_hooks << block
      self
    end

    def add_after_rest(&block)
      after_rest_hooks << block
      self
    end

    def start
      run_hooks(before_start_hooks)
      sleep(work_time * 60)
      run_hooks(after_work_hooks)
      sleep(rest_time * 60)
      run_hooks(after_rest_hooks)
    end

    private

    def run_hooks(hooks)
      hooks.each {|block| block.call }
    end

    def before_start_hooks
      @before_start_hooks ||= []
    end

    def after_work_hooks
      @after_work_hooks ||= []
    end

    def after_rest_hooks
      @after_rest_hooks ||= []
    end

  end

end
