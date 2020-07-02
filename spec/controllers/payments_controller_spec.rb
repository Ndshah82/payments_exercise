require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100.0) }
  let(:payment) { Payment.create!(loan: loan, payment_date: Date.today, amount: 50.0) }

  describe '#index' do
    it 'responds with a 200' do
      get :index, params: { loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :index, params: { loan_id: 10_000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#show' do
    it 'responds with a 200' do
      get :show, params: { loan_id: loan.id, id: payment.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { loan_id: 10_000, id: payment.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'if the payment is not found' do
      it 'responds with a 404' do
        get :show, params: { loan_id: loan.id, id: 10_000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    context 'if the payment is valid' do
      it 'responds with a 201' do
        post :create, params: { loan_id: loan.id, payment: { payment_date: Date.today, amount: 50.0 } }
        expect(response).to have_http_status(:created)
      end

      it 'creates the payment' do
        expect do
          post :create, params: { loan_id: loan.id, payment: { payment_date: Date.today, amount: 50.0 } }
        end.to change { Payment.count }.from(0).to(1)
      end
    end

    context 'if the payment is invalid' do
      it 'responds with a 422 for invalid paymen amountt' do
        post :create, params: { loan_id: loan.id, payment: { payment_date: Date.today, amount: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with a 422 for invalid payment date' do
        post :create, params: { loan_id: loan.id, payment: { payment_date: nil, amount: 50.0 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with a 422 for exceeding payment' do
        post :create, params: { loan_id: loan.id, payment: { payment_date: Date.today, amount: 150.0 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end