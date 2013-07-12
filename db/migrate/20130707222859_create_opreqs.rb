class CreateOpreqs < ActiveRecord::Migration
  def change
    create_table :opreqs do |t|
      t.integer :specialty_id
      t.string :opreqname

      t.timestamps
    end
  end
end
