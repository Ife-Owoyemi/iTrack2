class AddAppIdToUsercourses < ActiveRecord::Migration

	def up
		add_column :usercourses, :ap_id, :integer
	end

	def down 
		rmeove_column :usercourses, :ap_id
	end


end
