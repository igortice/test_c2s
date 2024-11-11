class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :task_status, null: false
      t.json :callback_data, default: {}

      t.bigint :task_id, null: false, index: true
      t.bigint :user_id, null: false, index: true

      t.timestamps
    end
  end
end
