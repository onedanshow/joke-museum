class CreateJokes < ActiveRecord::Migration[7.0]
  def change
    create_table :jokes do |t|
      t.text :setup
      t.text :punchline
      t.integer :joke_type, default: 0, null: false

      t.timestamps
    end
  end
end
