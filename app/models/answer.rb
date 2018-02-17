class Answer < ApplicationRecord
	belongs_to :question
	has_one :exam, through: :question
	validates :text, presence: true
end