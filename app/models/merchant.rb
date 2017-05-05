class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :customers, through: :invoices


  def revenue(hash = nil)
    total = invoices.joins(:invoice_items, :transactions)
                    .where(transactions: { result: 'success' })
                    .where(hash)
                    .sum('quantity * unit_price')
    (total.to_f / 100).to_s
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

  def self.most_revenue(limit = 5)
    select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: 'success'}).group(:id).order('revenue DESC').limit(limit)
  end

  def favorite_customer
    customers.select("customers.*, transactions.count AS succ_transactions")
             .joins(invoices: :transactions)
             .where(transactions: { result: 'success' })
             .group(:id)
             .order("succ_transactions DESC")
             .first

  def self.revenue(hash = nil)
    total = self.joins(invoices: [:invoice_items, :transactions])
            .where(transactions: {result: 'success'})
            .where(invoices: hash)
            .sum('invoice_items.unit_price * invoice_items.quantity')

    (total.to_f / 100).to_s
  end
end
