class Add < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :return_date, :date
  end
end
