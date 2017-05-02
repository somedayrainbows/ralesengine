require 'csv'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

namespace :data do
  desc "import csv data"
  task import: :environment do
    DatabaseCleaner.clean

    CSV.foreach('./db/data/merchants.csv', headers: true) do |row|
      merchant = Merchant.create(name: row['name'])
      puts "Merchant #{merchant.name} created."
    end

    CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
      invoice = Invoice.create(status: row['status'])
      puts "Invoice #{invoice.id} created."
    end

    CSV.foreach('./db/data/transactions.csv', headers: true) do |row|
      transaction = Transaction
                    .create(credit_card_number: row['credit_card_number'],
                            result: row['result'])
      puts "Transaction #{transaction.id} with cc# "\
           "#{transaction.credit_card_number} created."
    end
  end
end
