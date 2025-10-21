class AddAdminToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :admin, null: false, foreign_key: true
  end
end
