module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/customer_group
  class CustomerGroup < Base
    class << self
      # customer_group.list
      # Retrieve customer groups
      # 
      # Return: array
      def list
        results = commit("list", nil)
        Array(results).map do |result|
          self.class.new(connection, result)
        end
      end
    end
  end
end
