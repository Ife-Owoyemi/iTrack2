class CreateDepnumreqs < ActiveRecord::Migration
  def change
    create_table :depnumreqs do |t|
      t.integer :specialty_id
      t.string :depnumreqname
      t.integer :cgoal
      t.integer :hgoal

      t.timestamps
    end
  end
end
