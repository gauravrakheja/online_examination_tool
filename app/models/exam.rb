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
    
    def upcoming
      where("start_date >= ? AND start_date <= ?",Date.today, Date.today + 7.days)
    end

    def for_student(student)
      where(course: student.course, semester: student.semester)
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