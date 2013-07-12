class CreateOcourses < ActiveRecord::Migration
  def change
    create_table :ocourses do |t|
      t.integer :opreq_id
      t.string :department
      t.integer :num

      t.timestamps
    end
  end
end
