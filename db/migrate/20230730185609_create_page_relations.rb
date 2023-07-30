class CreatePageRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :page_relations do |t|
      t.references :page, null: false, foreign_key: true
      t.references :related_page, null: false, foreign_key: { to_table: :pages }

      t.timestamps
    end

    add_index :page_relations, [:page_id, :related_page_id], unique: true
  end
end
