class Attempt < ApplicationRecord
	include AASM

	belongs_to :user
	belongs_to :exam
	has_many :questions, through: :exam
	has_many :answers

	delegate :title, :subject, to: :exam, prefix: true, allow_nil: :true
	delegate :duration, :can_give?, to: :exam, allow_nil: true

	accepts_nested_attributes_for :answers, :questions, allow_destroy: true, reject_if: :all_blank

	alias_attribute :status, :aasm_state

	aasm do
	  state :pending, :initial => true
	  state :evaluated

	  event :correct do
	    transitions :from => :pending, :to => :evaluated
	  end
 	end

 	class << self
 		def without(user)
 			where.not(user: user)
 		end
 	end

	def unchecked_answers
		answers.reject { |answer| answer.marks.present? }
	end

	def evaluated?
		status == "evaluated"
	end

	def total_marks
		questions.map(&:marks).sum
	end

	def marks_obtained
		answers.map(&:marks).sum
	end

	def end_time
		Time.now + duration.minutes
	end

	def check_if_evaluated
		if answers.empty? || evaluated?
			return
		elsif unchecked_answers.empty? and may_correct?
			correct!
		end
	end
end