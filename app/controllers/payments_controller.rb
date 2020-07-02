class PaymentsController < ApplicationController
  def index
    array_success_response(data: loan.payments, serializer: PaymentSerializer)
  end

  def show
    success_response(data: loan.payments.find(params[:id]), serializer: PaymentSerializer)
  end

  def create
    service_response = CreatePaymentService.new(payment_params.merge(loan_id: params[:loan_id])).call
    
    if service_response.success?
      success_response(data: service_response.payment, serializer: PaymentSerializer, status: :created)
    else
      error_response(errors: service_response.errors)
    end
  end

  private

  def loan
    @loan ||= Loan.includes(:payments).find(params[:loan_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_date)
  end
end
