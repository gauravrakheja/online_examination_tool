require 'rails_helper'

describe StudentReportsController, type: :controller do
  describe 'show' do
    let(:student) { create(:student) }

    it 'should find the user' do
      sign_in student
      get :show, params: { user_id: student.id }
      expect(assigns(:student)).to eq(student)
    end
  end
end