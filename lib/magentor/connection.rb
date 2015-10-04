module Magento
  class Connection
    attr_accessor :session, :config, :logger

    def initialize(config = {})
      @logger ||= Logger.new(STDOUT)
      @config = config
      self
    end

    def client
      host, protocol = normalize_host config[:host]
      use_ssl = protocol == 'https'

      @client ||= XMLRPC::Client.new_from_hash \
        host: host,
        use_ssl: use_ssl,
        path: config[:path],
        port: config[:port]
    end

    def connect
      session.nil? ? connect! : self
    end

    def call(method = nil, *args)
      cache? ? call_with_caching(method, *args) : call_without_caching(method, *args)
    end

    private

    def normalize_host(host)
      String(host).gsub(/\/$/, '').split('://').reverse
    end

    def connect!
      logger.debug "call: login"
      retry_on_connection_error do
        @session = client.call("login", config[:username], config[:api_key])
      end
    end

    def cache?
      !!config[:cache_store]
    end

    def call_without_caching(method = nil, *args)
      logger.debug "call: #{method}, #{args.inspect}"
      connect
      retry_on_connection_error do
        client.call_async("call", session, method, args)
      end
    rescue XMLRPC::FaultException => e
      logger.debug "exception: #{e.faultCode} -> #{e.faultString}"
      if e.faultCode == 5 # Session timeout
        connect!
        retry
      end
      raise Magento::ApiError, "#{e.faultCode} -> #{e.faultString}"
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
