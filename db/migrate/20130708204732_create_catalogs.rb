class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.integer :institution_id

      t.timestamps
    end
  end
end
