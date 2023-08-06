class RenameJokesPagesToPageJokes < ActiveRecord::Migration[7.0]
  def change
    rename_table :jokes_pages, :page_jokes
  end
end
