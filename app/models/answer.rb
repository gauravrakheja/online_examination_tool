class Answer < ApplicationRecord
	belongs_to :question
	belongs_to :attempt
	has_one :exam, through: :question
	validates :text, presence: true, if: :subjective?
	validates :submitted_option, presence: true, if: :objective?

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
end