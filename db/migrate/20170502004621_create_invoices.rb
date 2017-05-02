class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end
