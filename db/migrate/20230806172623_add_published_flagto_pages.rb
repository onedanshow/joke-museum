class AddPublishedFlagtoPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :published, :boolean, default: true
  end
end
