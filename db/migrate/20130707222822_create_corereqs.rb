class CreateCorereqs < ActiveRecord::Migration
  def change
    create_table :corereqs do |t|
      t.integer :specialty_id
      t.string :corereqname
      t.integer :cgoal
      t.integer :hgoal

      t.timestamps
    end
  end
end
