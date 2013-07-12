class CreateCcourses < ActiveRecord::Migration
  def change
    create_table :ccourses do |t|
      t.integer :corereq_id
      t.string :department
      t.integer :num

      t.timestamps
    end
  end
end
