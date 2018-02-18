class AddTimestampToAttempts < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :attempts, null: true 

  	# backfill existing record with created_at and updated_at
  	# values making clear that the records are faked
  	long_ago = DateTime.new(2000, 1, 1)
  	Attempt.update_all(created_at: long_ago, updated_at: long_ago)

  	# change not null constraints
  	change_column_null :attempts, :created_at, false
  	change_column_null :attempts, :updated_at, false
  end
end
