class CreateGroupopreqs < ActiveRecord::Migration
  def change
    create_table :groupopreqs do |t|
      t.integer :specialty_id
      t.string :groupopreqname
      t.integer :ggoal

      t.timestamps
    end
  end
end
