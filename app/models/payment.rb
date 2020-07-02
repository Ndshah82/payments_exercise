class Payment < ActiveRecord::Base
  belongs_to :loan

  validates_presence_of :payment_date, :amount
  validates :amount, numericality: { greater_than: 0 }
end
