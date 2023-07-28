class AddExcludedIdsToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :excluded_joke_ids, :bigint, array: true, default: []
  end
end
