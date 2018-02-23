require 'rails_helper'

describe AttemptsController, type: :controller do
  it { should use_before_action :find_exam }

  let(:teacher) { create(:teacher) }
  let!(:exam) { create(:exam) }

  before do
    sign_in teacher
  end

  describe '#create' do
    let(:attempt) { build(:attempt, exam: exam) }
    let(:student) { create(:student) }
    let!(:question) { create(:subjective_question, exam: exam) }

    it 'should create the attempt' do
      post :create, params: {  exam_id: exam.id, attempt: { user_id: student.id, exam_id: exam.id, questions_attributes: { "0": { answer: { text: "test text" } } } } }
      expect(Attempt.last.answers.first.text).to eq "test text"
      expect(Attempt.last.answers.first.question).to eq question
    end
  end

  describe '#index' do
    let(:attempt) { create(:attempt, exam: exam) }
    let(:attempt1) { create(:attempt, exam: exam) }
    let(:distinct) { create(:distinct, order: [attempt1, attempt2]) }
    let(:q) { double(:q, result: distinct) }

    it 'should give all the attempts for the exam' do
      get :index, params: { exam_id: exam.id }
      expect(assigns(:attempts)).to include(attempt, attempt1)
    end
  end

  describe '#show' do
    let(:attempt) { create(:attempt, exam: exam) }

    it 'should give the attempt' do
      get :show, params: { id: attempt.id, exam_id: exam.id }
      expect(assigns(:attempt)).to eq attempt
    end
  end
end