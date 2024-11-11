class CreateProcessTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :process_tasks do |t|
      t.string :marca
      t.string :modelo
      t.string :valor
      t.string :task_url, null: false
      t.integer :task_status
      t.integer :user_id, null: false

      t.bigint :task_id, null: false, index: true
      t.bigint :notification_id, index: true

      t.timestamps
    end
  end
end
