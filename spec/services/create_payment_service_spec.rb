require 'rails_helper'

RSpec.describe CreatePaymentService do
  let(:loan) { Loan.create!(funded_amount: 100.0) }

  describe '#call' do
    context 'if successful' do
      let(:params) do
        {
          loan_id: loan.id,
          amount: 100.0,
          payment_date: Date.today
        }
      end

      it 'is successful' do
        expect(CreatePaymentService.new(params).call.success?).to be true
      end

      it 'creates the payment' do
        expect do
          CreatePaymentService.new(params).call
        end.to change { Payment.count }.from(0).to(1)
      end

      it 'sets the correct payment params' do
        service_response = CreatePaymentService.new(params).call

        expect(service_response.payment.amount).to eq(params[:amount])
        expect(service_response.payment.payment_date).to eq(params[:payment_date])
      end
    end

    context 'if invalid payment' do
      it 'with invalid loan' do
        params = {
          loan_id: nil,
          amount: 100.0,
          payment_date: Date.today
        }

        expect(CreatePaymentService.new(params).call.success?).to be false
      end

      it 'with invalid amount' do
        params = {
          loan_id: loan.id,
          amount: nil,
          payment_date: Date.today
        }

        expect(CreatePaymentService.new(params).call.success?).to be false
      end

      it 'with invalid date' do
        params = {
          loan_id: loan.id,
          amount: 100.0,
          payment_date: nil
        }

        expect(CreatePaymentService.new(params).call.success?).to be false
      end
    end

    context 'if exceeding amount' do
      it 'with invalid date' do
        params = {
          loan_id: loan.id,
          amount: loan.funded_amount + 1,
          payment_date: nil
        }

        expect(CreatePaymentService.new(params).call.success?).to be false
      end
    end
  end
end
