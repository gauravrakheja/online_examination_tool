class Answer < ApplicationRecord
	belongs_to :question
	belongs_to :attempt
	belongs_to :evaluator, class_name: 'User', foreign_key: 'user_id', optional: true
	has_one :exam, through: :question
	validates :text, presence: true, if: :subjective?
	validates :submitted_option, presence: true, if: :objective?
	after_save :correct_answer, if: :objective?

	delegate :objective?, to: :question
	delegate :subjective?, to: :question

	def submitted_answer
		objective? ? submitted_option : text
	end

	def checked?
		marks.present?
	end

	def self.checked
		where.not(marks: nil)
	end

	def evaluated_by
		if evaluator
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
end