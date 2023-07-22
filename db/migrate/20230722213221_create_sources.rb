class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.text :url
      t.string :filename

      t.timestamps
    end

    add_column :jokes, :source_id, :bigint
  end
end
