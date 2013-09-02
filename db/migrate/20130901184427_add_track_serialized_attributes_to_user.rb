class AddTrackSerializedAttributesToUser < ActiveRecord::Migration

	def up
		add_column :users, :coursearray, :text
		add_column :users, :usercoursesHash, :text
		add_column :users, :takenHash, :text
		add_column :users, :takingHash, :text
		add_column :users, :wtakeHash, :text
	end

	def down 
		remove_column :users, :coursearray
		remove_column :users, :usercoursesHash
		remove_column :users, :takenHash
		remove_column :users, :takingHash
		remove_column :users, :wtakeHash
	end

end
