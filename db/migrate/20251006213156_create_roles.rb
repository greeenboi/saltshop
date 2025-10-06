class CreateRoles < ActiveRecord::Migration[8.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :roles, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
