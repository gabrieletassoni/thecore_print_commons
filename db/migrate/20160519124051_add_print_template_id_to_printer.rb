class AddPrintTemplateIdToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_reference :printers, :print_template, index: true, foreign_key: true
  end
end
