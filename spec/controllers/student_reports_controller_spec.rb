require 'rails_helper'

describe StudentReportsController, type: :controller do
  describe 'show' do
    let(:student) { create(:student) }

    it 'should find the user' do
      get :show, user_id: student.id
      expect(assigns(:student)).to eq(student)
    end
  end
end