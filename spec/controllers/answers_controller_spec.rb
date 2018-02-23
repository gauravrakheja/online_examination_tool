require 'rails_helper'

describe AnswersController, type: :controller do
  describe '#update' do
    let(:admin) { create(:admin) }
    let(:answer) { create(:subjective_answer) }
    let(:ability) { double(:ability, can?: true) }

    before do
      sign_in admin
    end

    it 'should update the attributes passed' do
      expect(answer.marks).to eq nil
      expect(answer.evaluator).to eq nil
      post :update, params: { id: answer.id, answer: { marks: 10 }, format: :js }
      answer.reload
      expect(answer.evaluator).to eq admin
      expect(answer.marks).to eq 10
    end
	end
end