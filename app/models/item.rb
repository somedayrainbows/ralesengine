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
end
