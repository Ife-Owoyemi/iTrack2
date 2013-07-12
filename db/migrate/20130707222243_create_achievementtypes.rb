class CreateAchievementtypes < ActiveRecord::Migration
  def change
    create_table :achievementtypes do |t|
      t.integer :institution_id
      t.string :achievementtype

      t.timestamps
    end
  end
end
