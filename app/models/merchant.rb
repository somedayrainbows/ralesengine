class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def revenue(hash)
    total = invoices.joins(:invoice_items, :transactions)
                    .where(transactions: { result: 'success' })
                    .where(hash)
                    .sum('quantity * unit_price')
    (total.to_f/100).to_s
  end

  def self.most_items(quantity)
    select("merchants.*, sum(quantity) AS items_sold")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: { result: 'success' })
      .group(:id)
      .order("items_sold DESC")
      .limit(quantity)
  end
end
