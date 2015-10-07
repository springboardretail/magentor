module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_type
  # 100  Product not exists.
  # 101  Invalid data given. Details in error message.
  # 102  Tier prices not updated. Details in error message.
  class ProductTierPrice < Base
    # catalog_product_attribute_tier_price.info
    # Retrieve product tier prices
    # 
    # Return: array - array of tier prices array(array(’website’ ⇒ ..., ‘customer_group_id’ ⇒ ..., ‘qty’ ⇒ ..., ‘price’ ⇒ ...))
    # 
    # Arguments:
    # 
    # mixed product - product ID or Sku
    def info(*args)
      self.class.new(connection, commit("info", *args))
    end

    # catalog_product_attribute_tier_price.update
    # Update product tier prices
    # 
    # Return: boolean
    # 
    # Arguments:
    # 
    # mixed product - product ID or Sku
    # array tierPrices - array of tier prices 
    #   =>  array(array(’website’ ⇒ ..., ‘customer_group_id’ ⇒ ..., ‘qty’ ⇒ ..., ‘price’ ⇒ ...))
    def update(*args)
      commit("update", *args)
    end

    def find_by_product_id_or_sku(id)
      list(id)
    end
  end
end
