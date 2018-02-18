class AddAttemps < ActiveRecord::Migration[5.1]
  def change
  	create_table :attempts do |t|
    	t.integer :exam_id
    	t.integer :user_id
    end
  end
end
