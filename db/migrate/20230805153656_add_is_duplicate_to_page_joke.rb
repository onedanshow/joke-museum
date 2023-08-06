class AddIsDuplicateToPageJoke < ActiveRecord::Migration[7.0]
  def change
    add_column :page_jokes, :duplicate, :boolean, default: false
  end
end
