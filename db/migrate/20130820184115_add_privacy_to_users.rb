class AddPrivacyToUsers < ActiveRecord::Migration
 
	def up
		add_column :users, :hideemail, :boolean
		add_column :users, :hideprofile, :boolean
	end

	def down
		remove_column :users, :hideemail
		remove_column :users, :hideprofile
	end


end
