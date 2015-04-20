# Finable Thrift - Trace Ruby Thread Saftey

## Synopsis
Design decisions behind thread saftey in Trace

```ruby
  def stack
    Thread.current[TRACE_STACK] ||= []
  end
```

## Notes
[Trace](https://github.com/jamescway/finagle/blob/safe/finagle-thrift/src/main/ruby/lib/finagle-thrift/trace.rb) previously implemented an internal global variable "stack".  The assumption was that there would be 1 request per processes.  In a multi-thread ruby environment (i.e. jruby) this variable is now open to race conditions.  In order to fix this issue the stack variable was modified to be thread local.  The benefits are that the variable is local and only the local thread can modify it.  However, if the there is some work which has been delegated to another thread (T2) then that thread will not have access to the global.  One possible approach for delegating work to another thread might be to pass the stack to T2 to allow it to perform work.  This would then only allow T2 to access the thread.  Generally, sharing the stack between threads would be disallowed.  This leaves room for a future PR to add in this sharing functionality.
