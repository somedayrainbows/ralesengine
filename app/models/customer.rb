class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  has_many :merchants, through: :invoices

  def favorite_merchant
    merchants.select("merchants.*, transactions.count AS succ_transactions")
             .joins(invoices: :transactions)
             .where(transactions: { result: 'success' })
             .group(:id)
             .order("succ_transactions DESC")
             .first
  end
end
