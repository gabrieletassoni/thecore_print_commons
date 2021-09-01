class CreatePrintTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :print_templates do |t|
      t.string :name
      t.text :description
      t.text :template
      t.text :translation_matrix

      t.timestamps null: false
    end
  end
end
