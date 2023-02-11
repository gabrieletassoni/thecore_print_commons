class AddPrintTemplateIdToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_column :printers, :print_template_id, :bigint, if_not_exists: true
    add_index :printers, :print_template_id, if_not_exists: true
  end
end
