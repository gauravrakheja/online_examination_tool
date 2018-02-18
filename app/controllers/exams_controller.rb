class ExamsController < ApplicationController
	def new
		@exam = Exam.new
		authorize! :create, Exam
	end

	def create
		@exam = Exam.new(exam_params)
		if @exam.save
			flash[:notice] = "The exam has been created"
			redirect_to exams_path
		else
			flash[:alert] = @exam.errors.full_messages.to_sentence
			render :new
		end
		authorize! :create, Exam
	end

	def index
		@q = Exam.ransack(params[:q])
		@exams = @q.result
		authorize! :read, Exam
	end

	private

	def exam_params
		params.require(:exam).permit(:subject, :title, questions_attributes: [:text, :marks, :answer_type, :option1, :option2, :option3, :option4, :_destroy, :id])
	end
end