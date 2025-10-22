# frozen_string_literal: true

class AddLowerIndexesForSearch < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    # Products: index on lower(name) and lower(description)
    add_index :products, "lower(name)", name: "index_products_on_lower_name", algorithm: :concurrently unless index_exists?(:products, name: "index_products_on_lower_name")
    add_index :products, "lower(description)", name: "index_products_on_lower_description", algorithm: :concurrently unless index_exists?(:products, name: "index_products_on_lower_description")

    # Users: index on lower(name) to speed up admin orders search by customer name
    add_index :users, "lower(name)", name: "index_users_on_lower_name", algorithm: :concurrently unless index_exists?(:users, name: "index_users_on_lower_name")
  end

  def down
    remove_index :products, name: "index_products_on_lower_name", algorithm: :concurrently if index_exists?(:products, name: "index_products_on_lower_name")
    remove_index :products, name: "index_products_on_lower_description", algorithm: :concurrently if index_exists?(:products, name: "index_products_on_lower_description")
    remove_index :users, name: "index_users_on_lower_name", algorithm: :concurrently if index_exists?(:users, name: "index_users_on_lower_name")
  end
end
