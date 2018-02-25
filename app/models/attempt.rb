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

 		def evaluated
 			where(status: 'evaluated')
 		end

 		def sum_of_total_marks
 			sum = 0
 			all.each do |attempt|
 				sum += attempt.total_marks
 			end
 			sum
 		end

 		def sum_of_marks_obtained
  		sum = 0
 			all.each do |attempt|
 				sum += attempt.marks_obtained if attempt.marks_obtained
 			end
			sum
 		end

 		def percentage_for_evaluated
 			percentage = evaluated.sum_of_marks_obtained / evaluated.sum_of_total_marks.to_f * 100
 			percentage.truncate(2)
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
		return unless evaluated?
		answers.map(&:marks).sum
	end

	def marks_percentage
		return unless evaluated?
		percentage = (marks_obtained / total_marks.to_f )* 100
		percentage.truncate(2)
	end

	def end_time
		Time.now + duration.minutes
	end

	def check_if_evaluated
		if answers.empty? || evaluated? || answers.count < questions.count
			return
		elsif unchecked_answers.empty? and may_correct?
			correct!
		end
	end
end