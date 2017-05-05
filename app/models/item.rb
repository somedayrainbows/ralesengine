class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def best_day
    day = invoices.select("invoices.*, sum(invoice_items.quantity) AS sell_count")
                  .joins(:transactions, :invoice_items)
                  .where(transactions: {result: 'success'})
                  .group(:id)
                  .order("sell_count DESC, created_at DESC")
                  .first
                  .created_at
    {best_day: day}
  end

  def self.most_items(quantity = 5)
    select("items.*, sum(invoice_items.quantity) AS items_sold")
      .joins(invoice_items: [invoice: :transactions])
      .where(transactions: { result: 'success' })
      .group(:id)
      .order("items_sold DESC")
      .limit(quantity)
  end

  def self.most_revenue(limit = 5)
    select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: 'success'})
      .group(:id)
      .order('revenue DESC')
      .limit(limit)
  end
end
