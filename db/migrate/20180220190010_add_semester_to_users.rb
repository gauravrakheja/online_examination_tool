class AddSemesterToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :semester, :integer
  end
end
