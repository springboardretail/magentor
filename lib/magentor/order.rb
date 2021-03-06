module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/sales_order
  # 100  Requested order not exists.
  # 101  Invalid filters given. Details in error message.
  # 102  Invalid data given. Details in error message.
  # 103  Order status not changed. Details in error message.
  # sales_order.list
  class Order < Base
    # Retrieve list of orders by filters
    #
    # Return: array
    #
    # Arguments:
    #
    # array filters - filters for order list (optional)
    def list(*args)
      results = commit("list", *args)
      Array(results).map do |result|
        self.class.new(connection, result)
      end
    end

    # sales_order.info
    # Retrieve order information
    #
    # Return: array
    #
    # Arguments:
    #
    # string orderIncrementId - order increment id
    def info(*args)
      self.class.new(connection, commit("info", *args))
    end

    # sales_order.addComment
    # Add comment to order
    #
    # Return: boolean
    #
    # Arguments:
    #
    # string orderIncrementId - order increment id
    # string status - order status
    # string comment - order comment (optional)
    # boolean notify - notification flag (optional)
    def add_comment(*args)
      commit('addComment', *args)
    end

    # sales_order.hold
    # Hold order
    #
    # Return: boolean
    #
    # Arguments:
    #
    # string orderIncrementId - order increment id
    def hold(*args)
      commit('hold', *args)
    end

    # sales_order.unhold
    # Unhold order
    #
    # Return: boolean
    #
    # Arguments:
    #
    # mixed orderIncrementId - order increment id
    def unhold(*args)
      commit('unhold', *args)
    end

    # sales_order.cancel
    # Cancel order
    #
    # Return: boolean
    #
    # Arguments:
    #
    # mixed orderIncrementId - order increment id
    def cancel(*args)
      commit('cancel', *args)
    end

    def find_by_id(id)
      find(:first, {:order_id => id})
    end

    def find_by_increment_id(id)
      info(id)
    end

    def find(find_type, options = {})
      filters = {}
      options.each_pair { |k, v| filters[k] = {:eq => v} }
      results = list(filters)

      raise Magento::ApiError, "100 -> Requested order not exists." if results.blank?

      if find_type == :first
        info(results.first.increment_id)
      else
        Array(results).map do |o|
          info(o.increment_id)
        end
      end
    end
  end
end
