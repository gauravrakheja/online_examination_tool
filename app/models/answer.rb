class Answer < ApplicationRecord
	belongs_to :question
	belongs_to :attempt
	belongs_to :evaluator, class_name: 'User', foreign_key: 'user_id', optional: true
	has_one :exam, through: :question
	validates :text, presence: true, if: :subjective?
	validates :submitted_option, presence: true, if: :objective?
	after_save :correct_answer, if: :objective?
	after_save :update_attempt

	delegate :objective?, :subjective?, to: :question, allow_nil: true
	delegate :marks, to: :question, prefix: true, allow_nil: true

	class << self
		def checked
			where.not(marks: nil)
		end
	end

	def submitted_answer
		objective? ? submitted_option : text
	end

	def checked?
		marks.present?
	end

	def evaluated_by
		if evaluator && !marks.nil?
			evaluator.name
		elsif !marks.nil?
			"auto"
		end
	end

	private

	def correct_answer
		unless checked?
			if submitted_option == question.correct_option
				mark = question.marks
			else
				mark = 0
			end
			update_attributes!(marks: mark)
		end
	end

	def update_attempt
		attempt.check_if_evaluated
	end
end