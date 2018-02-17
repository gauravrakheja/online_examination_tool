class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
    	t.integer :question_id
    	t.string :text
    	t.integer :marks
    end
  end
end
