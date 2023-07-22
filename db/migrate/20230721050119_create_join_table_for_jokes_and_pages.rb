class CreateJoinTableForJokesAndPages < ActiveRecord::Migration[7.0]
  def change
    create_join_table :jokes, :pages, id: false do |t|
      t.index [:joke_id, :page_id]
      t.index [:page_id, :joke_id]
    end
  end
end
