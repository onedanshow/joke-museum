class AddUniqueConstraints < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :handle, unique: true
    
    remove_index :jokes_pages, name: "index_jokes_pages_on_joke_id_and_page_id"
    remove_index :jokes_pages, name: "index_jokes_pages_on_page_id_and_joke_id"

    add_index :jokes_pages, [:joke_id, :page_id], unique: true, name: "index_jokes_pages_on_joke_id_and_page_id_uniq"
    add_index :jokes_pages, [:page_id, :joke_id], unique: true, name: "index_jokes_pages_on_page_id_and_joke_id_uniq"    
  end
end
