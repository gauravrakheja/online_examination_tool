class ExamsController < ApplicationController
	def new
		if can? :create, Exam
			@exam = Exam.new
		end
	end

	def create
		if can? :create, Exam
			@exam = Exam.new(exam_params)
			if @exam.save

			else

			end
		end
	end

	private

	def exam_params
		params.require(:exam).permit(:subject, :title, questions_attributes: [:text, :marks])
	end
end