class CreateColeges < ActiveRecord::Migration
  def change
    create_table :coleges do |t|
      t.integer :catalog_id
      t.string :colegename

      t.timestamps
    end
  end
end
