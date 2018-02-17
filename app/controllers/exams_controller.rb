class ExamsController < ApplicationController
	def new
		if can? :create, Exam
			@exam = Exam.new
		else
			redirect_to root_path
		end
	end

	def create
		if can? :create, Exam
			@exam = Exam.new(exam_params)
			if @exam.save
				flash[:notice] = "The exam has been created"
			else
				flash[:alert] = @exam.errors.full_messages.to_sentence
				render :new
			end
		end
	end

	private

	def exam_params
		params.require(:exam).permit(:subject, :title, questions_attributes: [:text, :marks, :answer_type, :_destroy, :id])
	end
end