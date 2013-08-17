class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :awardtitle
      t.integer :year
      t.string :providername
      t.text :tipsforapp
      t.text :awardperks
      t.text :awardprereqs

      t.timestamps
    end
  end
end
