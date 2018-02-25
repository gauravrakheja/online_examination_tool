require 'rails_helper'

describe ExamsController, type: :controller do
  let(:teacher) { create(:teacher) }
  
  before do
    sign_in teacher
  end

  describe '#create' do
    let(:exam) { build(:exam) }

    it 'should create the exam' do
      expect(exam.persisted?).to eq false
      post :create, params: { exam: exam.attributes }
      expect(Exam.last.subject).to eq exam.subject
      expect(Exam.last.title).to eq exam.title
    end
  end

  describe '#index' do
    let(:exam) { create(:exam) }
    let(:exam1) { create(:exam) }
    let(:exam2) { create(:exam) }
    let(:q) { double(:q, result: [exam, exam1, exam2]) }

    before do
      allow(Exam).to receive(:upcoming).and_return([exam1, exam2])
      allow(Exam).to receive(:ransack).and_return(q)
    end

    it 'should give all the exams' do
      get :index
      expect(assigns(:upcoming_exams)).to include(exam1, exam2)
      expect(assigns(:upcoming_exams)).to_not include exam
      expect(assigns(:exams)).to include(exam, exam1, exam2)
    end
  end
end