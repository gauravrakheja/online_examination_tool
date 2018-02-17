class Question < ApplicationRecord
	belongs_to :exam
	has_one :answer
	validates :text, presence: true
	validates :marks, presence: true, numericality: true
	validates :answer_type, presence: true

	def objective?
		answer_type == OBJECTIVE
	end

	def subjective?
		answer_type == SUBJECTIVE
	end
end