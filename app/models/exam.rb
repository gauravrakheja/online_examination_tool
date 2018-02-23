class Exam < ApplicationRecord
	has_many :attempts
	has_many :questions
	has_many :answers, through: :questions
	validates :title, :subject, :duration, :start_date, presence: true
	validates :duration, numericality: true

	accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  class << self
    def live
      where("start_date <= ? ", Date.today)
    end
  end

  def live?
    start_date <= Date.today if start_date
  end
end