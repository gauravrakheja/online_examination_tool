require 'rails_helper'

describe StudentsController, type: :controller do
  describe 'index' do
    let(:teacher)  { create(:teacher) }
    let(:student)  { create(:student) }
    let(:student1)  { create(:student) }
    let(:q) { double(:q, result: [student1, student]) }
    let(:students) { double(:students, ransack: q) }

    before do
      sign_in teacher
      allow(User).to receive(:students) { students }
    end

    it 'should give all the students' do
      get :index
      expect(response.code).to eq '200'
      expect(assigns(:students)).to include(student, student1)
      expect(assigns(:students)).to_not include(teacher)
      expect(assigns(:q)).to eq(q)
    end
  end
end