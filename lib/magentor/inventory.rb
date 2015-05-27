module Magento
  class Inventory < Base
    class << self
      def api_path
        "product_stock"
      end

      def list(*args)
        results = commit("list", *args)
        results.collect do |result|
          new(result)
        end
      end

      # product_stock.update
      # Allows you to update the required product stock data
      #
      # Return: int
      #
      # Arguments:
      #
      # mixed productId - product ID or Sku
      # hash stockItemData - array of attributes values
      def update(*args)
        commit("update", *args)
      end
    end
  end
end
