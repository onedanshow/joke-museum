class ChangeKeywordsNullInPages < ActiveRecord::Migration[7.0]
  def change
    change_column_null :pages, :keywords, false
  end
end
