class CreatePrintTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :print_templates, if_not_exists: true do |t|
      t.string :name
      t.text :description
      t.text :template
      t.text :translation_matrix

      t.timestamps null: false
    end
  end
end
