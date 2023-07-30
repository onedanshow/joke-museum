class AddCaseInsensitiveToPages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'
    change_column :pages, :keywords, :citext
    remove_index :pages, name: "index_pages_on_lower_keywords"
  end
end
