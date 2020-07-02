class LoansController < ApplicationController

  def index
    array_success_response(data: Loan.all, serializer: LoanSerializer)
  end

  def show
    success_response(data: Loan.find(params[:id]), serializer: LoanSerializer)
  end

  def create
    loan = Loan.new(loan_params)

    if loan.save
      success_response(data: loan, serializer: LoanSerializer, status: :created)
    else
      error_response(errors: loan.errors.full_messages)
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:funded_amount)
  end
end
