class AddTemperatureToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_column :printers, :temperature, :integer, if_not_exists: true
  end
end
