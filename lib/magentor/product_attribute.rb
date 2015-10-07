module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_attribute
  # 100  Requested store view not found.
  # 101  Requested attribute not found.
  class ProductAttribute < Base
    # catalog_product_attribute.list
    # Retrieve attribute list
    #
    # Return: array
    #
    # Arguments:
    #
    # int setId - attribute set ID
    def list(*args)
      results = commit("list", *args)
      Array(results).map do |result|
        self.class.new(connection, result)
      end
    end

    # catalog_product_attribute.info
    # Retrieve attribute information
    #
    # Return: array
    #
    # Arguments:
    #
    # string attribute - Attribute code or ID
    def info(*args)
      self.class.new(connection, commit("info", *args))
    end

    # catalog_product_attribute.currentStore
    # Set/Get current store view
    #
    # Return: int
    #
    # Arguments:
    #
    # mixed storeView - store view id or code (optional)
    def current_store(*args)
      commit("currentStore", *args)
    end

    # catalog_product_attribute.options
    # Retrieve attribute options
    #
    # Return: array
    #
    # Arguments:
    #
    # mixed attributeId - attribute ID or code
    # mixed storeView - store view ID or code (optional)
    def options(*args)
      commit("options", *args)
    end

    def remove_option(*args)
      commit("removeOption", *args)
    end

    def add_option(*args)
      commit("addOption", *args)
    end

    def remove(*args)
      commit("remove", *args)
    end

    def types(*args)
      commit("types", *args)
    end
  end
end
