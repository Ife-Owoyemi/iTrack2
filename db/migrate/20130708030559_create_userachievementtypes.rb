class CreateUserachievementtypes < ActiveRecord::Migration
  def change
    create_table :userachievementtypes do |t|
      t.integer :user_id
      t.string :achievementtype
      t.string :college
      t.string :achievementname
      t.string :specialty

      t.timestamps
    end
  end
end
