class CreateUsercourses < ActiveRecord::Migration
  def change
    create_table :usercourses do |t|
      t.string :department
      t.integer :semester_id
      t.string :num
      t.integer :credits
      t.string :status
      t.string :institution

      t.timestamps
    end
  end
end
