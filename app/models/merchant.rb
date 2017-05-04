class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def revenue
    total = invoices.joins(:invoice_items, :transactions)
            .where(transactions: { result: 'success' })
            .sum('quantity * unit_price')
    (total.to_f/100).to_s
  end
end
