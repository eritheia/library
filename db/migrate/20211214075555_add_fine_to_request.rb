class AddFineToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :fine, :integer, default: 0
  end
end
