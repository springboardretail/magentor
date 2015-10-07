module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/customer
  # 100  Invalid customer data. Details in error message.
  # 101  Invalid filters specified. Details in error message.
  # 102  Customer does not exist.
  # 103  Customer not deleted. Details in error message.
  class Customer < Base
      # customer.list
      # Retrieve customers
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # array filters - filters by customer attributes (optional)
      # filter list - “updated_at”, “website_id”, “increment_id”, “lastname”, “group_id”, 
      #   “firstname”, “created_in”, “customer_id”, “password_hash”, “store_id”, “email”, “created_at”
      # 
      # Note: password_hash will only match exactly with the same MD5 and salt as was used when 
      # Magento stored the value. If you try to match with an unsalted MD5 hash, or any salt other 
      # than what Magento used, it will not match. This is just a straight string comparison.
      def list(*args)
        results = commit("list", *args)
        Array(results).map do |result|
          self.class.new(connection, result)
        end
      end

      # customer.create
      # Create customer
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # array customerData - cutomer data (email, firstname, lastname, etc...)
      def create(attributes)
        id = commit("create", attributes)
        record = self.class.new(connection, attributes)
        record.id = id
        record
      end


      # customer.info
      # Retrieve customer data
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int customerId - Customer ID.
      # array attributes | string attribute (optional depending on version) - 
      #   return only these attributes. Possible attributes are updated_at, increment_id, 
      #   customer_id, created_at. The value, customer_id, is always returned.
      def info(*args)
        self.class.new(connection, commit("info", *args))
      end

      # customer.update
      # Update customer data
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int customerId - customer ID
      # array customerData - customer data (email, firstname, etc...)
      def update(*args)
        commit("update", *args)
      end


      # customer.delete
      # Delete customer
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int customerId - customer ID.
      def delete(*args)
        commit("delete", *args)
      end

      def find_by_id(id)
        info(id)
      end

      def find(find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(filters)
        if find_type == :first
          results.first
        else
          results
        end
      end

      def all
        list
      end

      def upsert(attributes = {})
        clean_attributes = {}
        # change all keys to symbols
        attributes.each { |key, value| clean_attributes[key.to_sym] = value }

        customer = list(:email => clean_attributes[:email]).first

        if customer
          # update if there are attributes other than an email address
          update(customer.id, clean_attributes) if clean_attributes.size > 1
          info(customer.id)
        else
          create(clean_attributes)
        end
      end
  end
end
