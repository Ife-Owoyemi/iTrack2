class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.integer :achievementtype_id
      t.string :college

      t.timestamps
    end
  end
end
