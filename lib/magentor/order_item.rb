module Magento
  class OrderItem < Base
    def find_by_order_number_and_id(order_number, id)
      Magento::Order.find_by_increment_id(order_number).order_items.select{ |i| i.id == id }.first
    end

    def find_by_order_id_and_id(order_id, id)
      Magento::Order.find_by_id(order_id).order_items.select{ |i| i.id == id }.first
    end
  end
end
