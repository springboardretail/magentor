module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/customer_address
  # 100  Invalid address data. Details in error message.
  # 101  Customer not exists.
  # 102  Address not exists.
  # 103  Address not deleted. Details in error message.
  class CustomerAddress < Base
    # customer_address.list
    # Retrieve customer addresses
    # 
    # Return: array
    # 
    # Arguments:
    # 
    # int customerId - Customer Id
    def list(*args)
      results = commit("list", *args)
      Array(results).map do |result|
        self.class.new(connection, result)
      end
    end

    # customer_address.create
    # Create customer address
    # 
    # Return: int
    # 
    # Arguments:
    # 
    # int customerId - customer ID
    # array addressData - adress data (country, zip, city, etc...)
    def create(customer_id, attributes)
      id = commit("create", customer_id, attributes)
      record = self.class.new(connection, attributes)
      record.id = id
      record
    end

    # customer_address.info
    # Retrieve customer address data
    # 
    # Return: array
    # 
    # Arguments:
    # 
    # int addressId - customer address ID
    def info(*args)
      self.class.new(connection, commit("info", *args))
    end

    # customer_address.update
    # Update customer address data
    # 
    # Return: boolean
    # 
    # Arguments:
    # 
    # int addressId - customer address ID
    # array addressData - adress data (country, zip, city, etc...)
    def update(*args)
      commit("update", *args)
    end

    # customer_address.delete
    # Delete customer address
    # 
    # Return: boolean
    # 
    # Arguments:
    # 
    # int addressId - customer address ID
    def delete(*args)
      commit("delete", *args)
    end

    def find_by_id(id)
      info(id)
    end

    def find_by_customer_id(id)
      list(id)
    end
  end
end
