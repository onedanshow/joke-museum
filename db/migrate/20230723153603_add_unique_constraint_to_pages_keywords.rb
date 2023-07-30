class AddUniqueConstraintToPagesKeywords < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :keywords, unique: true
  end
end
