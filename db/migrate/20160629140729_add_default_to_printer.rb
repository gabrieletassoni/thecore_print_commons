class AddDefaultToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_column :printers, :default, :boolean, default: false, if_not_exists: true
  end
end
