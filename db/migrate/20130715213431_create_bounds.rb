class CreateBounds < ActiveRecord::Migration
  def change
    create_table :bounds do |t|
      t.integer :dep_id
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end
