class AddPrimaryKeyToPageJokes < ActiveRecord::Migration[7.0]
  def up
    # Add a new primary key column
    add_column :page_jokes, :id, :primary_key, first: true
  end

  def down
    remove_column :page_jokes, :id
  end
end
