class AddPortToPrinter < ActiveRecord::Migration[4.2]
  def change
    add_column :printers, :port, :integer, default: 9100
  end
end
