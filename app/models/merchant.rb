class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :customers, through: :invoices


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

  def customers_with_pending_invoices
    invoices = Invoice.find_by_sql("SELECT invoices.* FROM invoices
                         INNER JOIN customers ON customers.id = invoices.customer_id
                         INNER JOIN transactions ON transactions.invoice_id = invoices.id
                         WHERE invoices.merchant_id = #{self.id} AND transactions.result = 'failed'
                         EXCEPT
                         SELECT invoices.* FROM invoices
                         INNER JOIN customers ON customers.id = invoices.customer_id
                         INNER JOIN transactions ON transactions.invoice_id = invoices.id
                         WHERE invoices.merchant_id = #{self.id} AND transactions.result = 'success';")

    invoices.map { |invoice| Customer.find(invoice.customer_id) }.uniq
  end
end
