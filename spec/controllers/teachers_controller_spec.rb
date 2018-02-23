require 'rails_helper'

describe TeachersController, type: :controller do
  describe '#index' do
    let(:admin) { create(:admin) }
    let(:teacher) { create(:teacher) }
    let(:teacher1) { create(:teacher) }

    before do
      sign_in admin
      allow(User).to receive(:unconfirmed_teachers) { [teacher] }
    end

    it 'should give all the unconfirmed teachers' do
      get :index
      expect(response.code).to eq "200"
      expect(assigns(:teachers)).to include teacher
      expect(assigns(:teachers)).to_not include teacher1
    end
  end

  describe '#update' do
    context 
    let(:admin) { create(:admin) }
    let(:teacher) { create(:teacher, confirmed: false) }

    before do
      sign_in admin
    end

    it 'should confirm the user' do
      expect(teacher.confirmed).to eq false
      post :update, params: { user_id: teacher.id }
      teacher.reload
      expect(teacher.confirmed).to eq true
    end
  end
end