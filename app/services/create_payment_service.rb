class CreatePaymentService
  def initialize(params)
    @payment = Payment.new(params)
  end

  def call
    unless payment.valid?
      return OpenStruct.new(success?: false, errors: payment.errors.full_messages)
    end
    
    if exceeding_payment?
      return OpenStruct.new(success?: false, errors: ['Payment cannot exceed oustanding loan amount'])
    end

    payment.save!

    OpenStruct.new(success?: true, payment: payment)
  end

  private

  attr_reader :payment

  def exceeding_payment?
    payment.loan.outstanding_balance < payment.amount
  end
end