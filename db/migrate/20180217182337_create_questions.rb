class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
    	t.integer :exam_id
    	t.string :text
    	t.integer :marks
    end
  end
end
