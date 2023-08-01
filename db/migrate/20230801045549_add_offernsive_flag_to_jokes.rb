class AddOffernsiveFlagToJokes < ActiveRecord::Migration[7.0]
  def change
    add_column :jokes, :classification, :integer, default: 0
  end
end
