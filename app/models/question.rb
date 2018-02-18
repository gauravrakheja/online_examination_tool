class Question < ApplicationRecord
	belongs_to :exam
	has_many :answers
	validates :text, presence: true
	validates :marks, presence: true, numericality: true
	validates :answer_type, presence: true
	has_many :attempts, through: :exam

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