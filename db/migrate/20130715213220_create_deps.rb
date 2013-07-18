class CreateDeps < ActiveRecord::Migration
  def change
    create_table :deps do |t|
      t.integer :depnumreq_id
      t.string :department

      t.timestamps
    end
  end
end
