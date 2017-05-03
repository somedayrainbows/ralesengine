class Invoice < ApplicationRecord
  belongs_to :merchant
  has_many :transactions
end
