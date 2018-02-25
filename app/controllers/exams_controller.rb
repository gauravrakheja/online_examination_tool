class ExamsController < ApplicationController
	before_action :not_students, except: :index
	before_action :members, only: :index

	def new
		@exam = Exam.new
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
	end

	def edit
		@exam = Exam.find(params[:id])
	end

	def update
		@exam = Exam.find(params[:id])
		if @exam.update(exam_params)
			flash[:notice] = "The exam has been created"
			redirect_to exams_path
		else
			flash[:alert] = @exam.errors.full_messages.to_sentence
			render :edit
		end
	end

	def index
		if can? :manage, Exam
			exams = Exam.all
			@upcoming_exams = Exam.upcoming.sample(3)
		else
			exams = Exam.live.for_student(current_user)
			@upcoming_exams = Exam.upcoming.for_student(current_user).sample(3)
		end
		@q = exams.ransack(params[:q])
		@exams = @q.result
	end

	private

	def not_students
		authorize! :manage, Exam
	end

	def members
		authorize! :read, Exam
	end

	def exam_params
		params.require(:exam).permit(:subject, :title, :start_date, :duration, :course, :semester, questions_attributes: [:text, :marks, :answer_type, :option1, :option2, :option3, :option4, :correct_option, :_destroy, :id])
	end
end