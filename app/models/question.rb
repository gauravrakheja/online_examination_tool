# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  exam_id        :integer
#  text           :string
#  marks          :integer
#  answer_type    :string
#  option1        :string
#  option2        :string
#  option3        :string
#  option4        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  correct_option :integer
#

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
