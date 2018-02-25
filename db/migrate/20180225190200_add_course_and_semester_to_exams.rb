class AddCourseAndSemesterToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :course, :string
    add_column :exams, :semester, :integer
  end
end
