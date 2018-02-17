class Question < ApplicationRecord
	belongs_to :exam
	has_one :answer
	validates :text, presence: true
	validates :marks, presence: true
end