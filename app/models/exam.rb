class Exam < ApplicationRecord
	has_many :attempts
	has_many :questions
	has_many :answers, through: :questions
	validates :title, :subject, :duration, presence: true
	validates :duration, numericality: true

	accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank
end