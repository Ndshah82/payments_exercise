class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :payment_date, :amount
end