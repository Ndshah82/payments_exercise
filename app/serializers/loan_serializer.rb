class LoanSerializer < ActiveModel::Serializer
  attributes :id, :funded_amount, :outstanding_balance
end