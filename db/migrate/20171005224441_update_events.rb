class UpdateEvents < ActiveRecord::Migration
	def self.up    
		change_column :events, :location, :integer
		Event.update_all(:location => 0)
	end
end