class AddUniquenessConstraintToPages < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, "lower(keywords)", unique: true
  end
end
