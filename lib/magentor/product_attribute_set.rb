module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_attribute_set
  class ProductAttributeSet < Base
    # catalog_product_attribute_set.list
    # Retrieve product attribute sets
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
