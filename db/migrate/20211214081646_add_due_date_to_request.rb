class AddDueDateToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :due_date, :date
  end
end
