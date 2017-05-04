class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  has_many :customers, through: :invoices

  def revenue
    total = invoices.joins(:invoice_items, :transactions)
            .where(transactions: { result: 'success' })
            .sum('quantity * unit_price')
    (total.to_f/100).to_s
  end

  def customers_with_pending_invoices
    invoices = Invoice.find_by_sql("SELECT invoices.* FROM invoices
                         INNER JOIN customers ON customers.id = invoices.customer_id
                         INNER JOIN transactions ON transactions.invoice_id = invoices.id WHERE invoices.merchant_id = 77 AND transactions.result = 'failed'
                         EXCEPT
                         SELECT invoices.* FROM invoices
                         INNER JOIN customers ON customers.id = invoices.customer_id
                         INNER JOIN transactions ON transactions.invoice_id = invoices.id
                         WHERE invoices.merchant_id = 77 AND transactions.result = 'success';")
                      
    invoices.map { |invoice| Customer.find(invoice.customer_id) }.uniq
  end
end
