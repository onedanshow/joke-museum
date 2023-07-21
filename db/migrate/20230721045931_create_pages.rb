class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :keywords
      t.bigint :shopify_id

      t.timestamps
    end
  end
end
