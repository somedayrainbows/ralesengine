class Invoice < ApplicationRecord
  belongs_to :merchant
  has_many :transactions
  belongs_to :customer
end
