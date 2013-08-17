class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :conferencename
      t.text :tipsforapp
      t.text :contakeaway
      t.datetime  :conbegin
      t.datetime  :conend

      t.timestamps
    end
  end
end
