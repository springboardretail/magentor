# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "magentor"
  s.version = "0.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Preston Stuteville"]
  s.date = "2012-06-15"
  s.email = "preston.stuteville@gmail.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "TODOS",
    "VERSION",
    "init.rb",
    "lib/magentor.rb",
    "lib/magentor/base.rb",
    "lib/magentor/cart.rb",
    "lib/magentor/cart_coupon.rb",
    "lib/magentor/cart_customer.rb",
    "lib/magentor/cart_payment.rb",
    "lib/magentor/cart_product.rb",
    "lib/magentor/cart_shipping.rb",
    "lib/magentor/category.rb",
    "lib/magentor/category_attribute.rb",
    "lib/magentor/connection.rb",
    "lib/magentor/country.rb",
    "lib/magentor/customer.rb",
    "lib/magentor/customer_address.rb",
    "lib/magentor/customer_group.rb",
    "lib/magentor/inventory.rb",
    "lib/magentor/sales_order_invoice.rb",
    "lib/magentor/order.rb",
    "lib/magentor/order_item.rb",
    "lib/magentor/product.rb",
    "lib/magentor/product_attribute.rb",
    "lib/magentor/product_attribute_set.rb",
    "lib/magentor/product_link.rb",
    "lib/magentor/product_media.rb",
    "lib/magentor/product_stock.rb",
    "lib/magentor/product_tier_price.rb",
    "lib/magentor/product_type.rb",
    "lib/magentor/region.rb",
    "lib/magentor/shipment.rb",
    "magentor.gemspec"
  ]
  s.homepage = "http://github.com/pstuteville/magentor"
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby wrapper for the Magento xmlrpc api"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

