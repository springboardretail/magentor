module Magento
  class Connection
    attr_accessor :session, :config, :logger

    def initialize(config = {})
      @logger ||= Logger.new(STDOUT)
      @config = config
      self
    end

    def client
      @client ||= XMLRPC::Client.new_from_hash \
        host: config[:host],
        use_ssl: config[:use_ssl],
        path: config[:path],
        port: config[:port]
    end

    def connect
      session.nil? ? connect! : self
    end

    def call(method = nil, *args)
      cache? ? call_with_caching(method, *args) : call_without_caching(method, *args)
    end

     def multicall(*calls)
       multicall_without_caching(*calls)
     end

    private

    def connect!
      logger.debug "call: login on #{config[:host]}"
      retry_on_connection_error do
        @session = client.call("login", config[:username], config[:api_key])
      end
    end

    def cache?
      !!config[:cache_store]
    end

    def call_without_caching(method = nil, *args)
      logger.debug "call: #{method}, #{args.inspect} on #{config[:host]}"
      connect
      retry_on_connection_error do
        client.call_async("call", session, method, args)
      end
    rescue XMLRPC::FaultException => e
      log_fault_exception(e)
      if e.faultCode == 5 # Session timeout
        connect!
        retry
      end
      raise Magento::ApiError, "#{e.faultCode} -> #{e.faultString} on #{config[:host]}"
    end

    def multicall_without_caching(*calls)
      logger.debug "call: #{method}, #{args.inspect} on #{config[:host]}"
      connect
      retry_on_connection_error do
        ret = client.call_async("multiCall", session, [*calls])
        ret.each { |e| log_fault_exception(e) if e.is_a? Hash && e["isFault"] }
        return ret
      end
    rescue XMLRPC::FaultException => e
      log_fault_exception(e)
      if e.faultCode == 5 # Session timeout
        connect!
        retry
      end
      raise Magento::ApiError, "#{e.faultCode} -> #{e.faultString} on #{config[:host]}"
    end

    def log_fault_exception(e)
      logger.debug "exception: #{e["faultCode"]} -> #{e["faultMessage"]}"
    end

    def call_with_caching(method = nil, *args)
      config[:cache_store].fetch(cache_key(method, *args)) do
        call_without_caching(method, *args)
      end
    end

    def cache_key(method, *args)
      "#{config[:username]}@#{config[:host]}:#{config[:port]}#{config[:path]}/#{method}/#{args.inspect}"
    end

    def retry_on_connection_error
      attempts = 0

      begin
        yield
      rescue StandardError
        attempts += 1

        if attempts < 2
          sleep 5
          retry
        else
          raise
        end
      end
    end
  end
end
