class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.integer :price
      t.string :title
      t.integer :isbn
      t.string :auther

      t.timestamps
    end
  end
end
