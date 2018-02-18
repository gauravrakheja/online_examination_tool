class AddTimestampsModels < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :answers, null: true 
  	add_timestamps :questions, null: true 
  	add_timestamps :exams, null: true 

  	# backfill existing record with created_at and updated_at
  	# values making clear that the records are faked
  	long_ago = DateTime.new(2000, 1, 1)
  	Answer.update_all(created_at: long_ago, updated_at: long_ago)
  	Question.update_all(created_at: long_ago, updated_at: long_ago)
  	Exam.update_all(created_at: long_ago, updated_at: long_ago)

  	# change not null constraints
  	change_column_null :answers, :created_at, false
  	change_column_null :questions, :created_at, false
  	change_column_null :exams, :created_at, false
  	change_column_null :answers, :updated_at, false
  	change_column_null :questions, :updated_at, false
  	change_column_null :exams, :updated_at, false
  end
end
