class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :opreq_id
      t.string :optionname
      t.integer :cgoal
      t.integer :hgoal

      t.timestamps
    end
  end
end
