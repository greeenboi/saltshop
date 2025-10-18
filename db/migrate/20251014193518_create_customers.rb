class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.references :user, type: :uuid, index: { unique: true }, null: false, foreign_key: true

      t.timestamps
    end
  end
end
