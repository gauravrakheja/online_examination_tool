class AddStartDateToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :start_date, :date
  end
end
