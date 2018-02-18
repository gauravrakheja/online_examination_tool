class Attempt < ApplicationRecord
	belongs_to :user
	belongs_to :exam
	has_many :questions, through: :exam
	has_many :answers

	delegate :title, :subject, to: :exam, prefix: true

	accepts_nested_attributes_for :answers, :questions, allow_destroy: true, reject_if: :all_blank


	def status
		if answers.empty?
			return
		end
		unchecked_answers = answers.reject { |answer| answer.marks.present? }
		if unchecked_answers.empty?
			"Evaluated"
		else
			"Pending"
		end
	end

	def evaluated?
		status == "Evaluated"
	end

	def total_marks
		questions.map(&:marks).sum
	end

	def marks_obtained
		answers.map(&:marks).sum
	end
end