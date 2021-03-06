# Base Magento model handles basic crud operations and stores connection to magento instance.
# It has the following class attributes:
#
# * <tt>connection</tt>: the Magento::Connection to use
#
# And the following instance attributes:
# * <tt>attributes</tt>: the attributes of the magento object
#
module Magento
  class Base
    attr_accessor :attributes
    attr_reader :connection

    def initialize(connection, attributes = {})
      @connection = connection
      @attributes = attributes.dup
    end

    # Uses the classes name and method to make an rpc call through connection
    def commit(method, *args)
      # TODO: need to catch errors sent back from magento and bubble them up appropriately
      method = "#{api_path}.#{method}"
      connection.call(method, *args)
    end

    def multi_commit(method, args)
      method = "#{api_path}.#{method}"
      calls = Array(args).map {|arg| [method, arg]}
      connection.multicall(calls)
    end

    def api_path
      self.class.to_s.split('::').last.underscore.downcase
    end

    # TODO: find out if the id naming is consistent
    def id
      @attributes["#{self.class.to_s.split('::').last.underscore.downcase}_id"]
    end

    def id=(_id)
      @attributes["#{self.class.to_s.split('::').last.underscore.downcase}_id"] = _id
    end

    def object_attributes=(new_attributes)
      return if new_attributes.nil?
      attributes = new_attributes.dup
      attributes.stringify_keys!
      attributes.each do |k, v|
        send(k + "=", v)
      end
    end

    def method_missing(method_symbol, *arguments)
      method_name = method_symbol.to_s

      if method_name =~ /(=|\?)$/
        case $1
        when "="
          @attributes[$`] = arguments.first
        when "?"
          @attributes[$`]
        end
      else
        return @attributes[method_name] if @attributes.include?(method_name)
        super
      end
    end
  end

  class ApiError < StandardError; end
end
