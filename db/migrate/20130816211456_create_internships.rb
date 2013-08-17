class CreateInternships < ActiveRecord::Migration
  def change
    create_table :internships do |t|
      t.string :providername
      t.string :stutitle
      t.text :source
      t.text :internprereqs
      t.text :tipsforapp
      t.datetime  :internbegin
      t.datetime  :internend

      t.timestamps
    end
  end
end
