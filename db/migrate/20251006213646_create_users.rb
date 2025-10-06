class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.text :username, null: false
      t.text :password_digest, null: false
      t.uuid :role_id, index: true
      t.timestamptz :date_created
      t.text :name
      t.text :email
      t.text :bio
      t.text :photo_url

      t.timestamps
    end
    add_foreign_key :users, :roles, column: :role_id, primary_key: :id
    add_index :users, :username, unique: true
  end
end
