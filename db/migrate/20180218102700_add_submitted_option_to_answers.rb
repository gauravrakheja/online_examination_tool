class AddSubmittedOptionToAnswers < ActiveRecord::Migration[5.1]
  def change
  	add_column :answers, :submitted_option, :integer
  end
end
