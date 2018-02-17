class ExamsController < ApplicationController
	def new
		if can? :create, Exam
			@exam = Exam.new
		else
			redirect_to root_path
		end
	end

	def create
		binding.pry
		if can? :create, Exam
			@exam = Exam.new(exam_params)
			if @exam.save

			else

			end
		end
	end

	private

	def exam_params
		params.require(:exam).permit(:subject, :title, questions_attributes: [:text, :marks, :answer_type, :_destroy, :id])
	end
end