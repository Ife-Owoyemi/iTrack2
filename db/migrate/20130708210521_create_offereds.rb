class CreateOffereds < ActiveRecord::Migration
  def change
    create_table :offereds do |t|
      t.integer :num_id
      t.string :professor
      t.string :semester
      t.integer :year

      t.timestamps
    end
  end
end
