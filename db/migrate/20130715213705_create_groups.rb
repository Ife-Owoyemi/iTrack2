class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :groupopreq_id
      t.string :groupname
      t.integer :cgoal

      t.timestamps
    end
  end
end
