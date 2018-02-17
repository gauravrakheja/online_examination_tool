class Exam < ApplicationRecord
	has_many :questions
	has_many :answers, through: :questions
	validates :title, presence: true
	validates :subject, presence: true

	accepts_nested_attributes_for :questions, allow_destroy: true
end