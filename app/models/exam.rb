# == Schema Information
#
# Table name: exams
#
#  id         :integer          not null, primary key
#  title      :string
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  duration   :integer
#  start_date :date
#  course     :string
#  semester   :integer
#

class Exam < ApplicationRecord
	has_many :attempts
	has_many :questions
	has_many :answers, through: :questions
	validates :title, :subject, :duration, :course, :semester, :start_date, presence: true
	validates :duration, :semester, numericality: true

	accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  class << self
    def live
      where("start_date <= ? ", Date.today)
    end

    def between(start_date, end_date)
      where("start_date >= ? AND start_date <= ?", start_date, end_date)
    end
    
    def upcoming
      where("start_date >= ? AND start_date <= ?",Date.today, Date.today + 7.days)
    end

    def for_student(student)
      where(course: student.course, semester: student.semester)
    end

    def calender_json
      all.map do |exam|
        { title: exam.subject, start: exam.start_date.strftime("%Y-%m-%d"), course: exam.course, semester: exam.semester }
      end.to_json
    end
  end

  def can_give?(student)
    student.course == course and student.semester == semester and attempts_dont_contain(student)
  end

  def attempts_dont_contain(student)
    attempts.without(student).length <= 0
  end

  def live?
    start_date <= Date.today if start_date
  end

end
