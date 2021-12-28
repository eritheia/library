class AddPaidToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :paid, :boolean, default: true
  end
end
