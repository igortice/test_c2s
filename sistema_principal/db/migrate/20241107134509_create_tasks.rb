class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.string :url
      t.jsonb :details, default: {} # Campo não obrigatório, sem null: false

      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    # Adicionando índice GIN para o campo JSONB (opcional, para melhorar buscas)
    add_index :tasks, :details, using: :gin
  end
end
