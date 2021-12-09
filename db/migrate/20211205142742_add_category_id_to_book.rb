class AddCategoryIdToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :category_id, :integer, foreign_key: true
  end
end
