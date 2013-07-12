class CreateAchievementnames < ActiveRecord::Migration
  def change
    create_table :achievementnames do |t|
      t.integer :college_id
      t.string :achievementname
      t.integer :hourreq

      t.timestamps
    end
  end
end
