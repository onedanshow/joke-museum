class AddHandleToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :handle, :string
  end
end
