class AddAttemptIdToAnswers < ActiveRecord::Migration[5.1]
  def change
  	add_column :answers, :attempt_id, :integer
  end
end
