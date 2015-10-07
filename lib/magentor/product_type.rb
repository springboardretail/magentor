module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_type
  class ProductType < Base
    # catalog_product_type.list
    # Retrieve product types
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
