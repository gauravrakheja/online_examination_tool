class AddCorrectOptionToQuestions < ActiveRecord::Migration[5.1]
  def change
  	add_column :questions, :correct_option, :integer 
  end
end
