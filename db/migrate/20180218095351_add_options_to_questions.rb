class AddOptionsToQuestions < ActiveRecord::Migration[5.1]
  def change
  	add_column :questions, :option1, :string
  	add_column :questions, :option2, :string
  	add_column :questions, :option3, :string
  	add_column :questions, :option4, :string
  end
end
