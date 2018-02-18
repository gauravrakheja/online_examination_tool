class ExamsController < ApplicationController
	def new
		@exam = Exam.new
		authorize! :create, Exam
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

	def index
		if can? :read, Exam
			@exams = Exam.all
		end
	end

	private

	def exam_params
		params.require(:exam).permit(:subject, :title, questions_attributes: [:text, :marks, :answer_type, :option1, :option2, :option3, :option4, :_destroy, :id])
	end
end