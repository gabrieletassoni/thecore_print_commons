class AddPortToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_column :printers, :port, :integer, default: 9100, if_not_exists: true
  end
end
