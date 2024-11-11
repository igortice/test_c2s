class CreateRefreshTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.datetime :expires_at

      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
