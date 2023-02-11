class CreatePrinters < ActiveRecord::Migration[7.0]
  def change
    create_table :printers, if_not_exists: true do |t|
      t.string :name
      t.text :description
      t.string :ip
      t.text :template
      t.integer :qty
      t.text :translation

      t.timestamps null: false
    end
    add_index :printers, :name, if_not_exists: true
    add_index :printers, :description, if_not_exists: true
    add_index :printers, :ip, if_not_exists: true
  end
end
