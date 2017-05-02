require 'csv'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

namespace :data do
  desc "import csv data"
  task import: :environment do
    DatabaseCleaner.clean
    
    CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
      invoice = Invoice.create(status: row['status'])
      puts "Invoice #{invoice.id} created."
    end
  end

end
