class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.bigint :external_auth_id, index: { unique: true }

      t.timestamps
    end
  end
end
