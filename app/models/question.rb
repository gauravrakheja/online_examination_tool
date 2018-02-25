class Question < ApplicationRecord
	belongs_to :exam, dependent: :destroy
	has_many :answers
	has_many :attempts, through: :exam
	validates :text, presence: true
	validates :marks, presence: true, numericality: true
	validates :answer_type, presence: true
	validates :correct_option, presence: true, numericality: true, if: :objective?
	validates :option1, :option2, :option3, :option4, presence: true, if: :objective? 

	accepts_nested_attributes_for :answers

	def objective?
		answer_type == OBJECTIVE
	end

	def subjective?
		answer_type == SUBJECTIVE
	end

	def answer_for_attempt(attempt)
		array = answers.reject { |answer| answer.attempt != attempt }
		array.first
	end

end