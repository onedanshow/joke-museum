class AddDuplicateOfToPageJokes < ActiveRecord::Migration[7.0]
  def change
    add_reference :page_jokes, :duplicate_of, type: :bigint, foreign_key: { to_table: :jokes }
  end
end
