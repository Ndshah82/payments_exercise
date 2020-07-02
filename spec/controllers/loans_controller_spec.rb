require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    it 'responds with a 201' do
      post :create, params: { loan: { funded_amount: 100.0 } }
      expect(response).to have_http_status(:created)
    end

    it 'creates the loan' do
      expect do
        post :create, params: { loan: { funded_amount: 100.0 } }
      end.to change { Loan.count }.from(0).to(1)
    end

    it 'responds with a 422 for invalid funded amount' do
      post :create, params: { loan: { funded_amount: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'responds with a 422 for negative funded amount' do
      post :create, params: { loan: { funded_amount: -1000 } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
