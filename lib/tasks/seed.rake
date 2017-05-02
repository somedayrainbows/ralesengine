require 'csv'
require 'database_cleaner'


namespace :seed do
  desc "import all csv data"
  task all: :environment do
    DatabaseCleaner.clean_with(:truncation)
    Rake::Task["seed:merchants"].invoke
    Rake::Task["seed:customers"].invoke
    Rake::Task["seed:invoices"].invoke
    Rake::Task["seed:transactions"].invoke
    Rake::Task["seed:items"].invoke
  end

  desc "import merchant csv data"
  task merchants: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["merchants"])
    CSV.foreach('./db/data/merchants.csv', headers: true) do |row|
      merchant = Merchant.create(name: row['name'],
                                 created_at: row['created_at'],
                                 updated_at: row['updated_at'])

      puts "Merchant #{merchant.name} created."
    end
  end

  desc "import customer csv data"
  task customers: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["customers"])
    CSV.foreach('./db/data/customers.csv', headers: true) do |row|
      customer = Customer.create(first_name: row['first_name'],
                                 last_name: row['last_name'],
                                 created_at: row['created_at'],
                                 updated_at: row['updated_at'])

      puts "Customer #{customer.first_name} #{customer.last_name} created."
    end
  end

  desc "import invoice csv data"
  task invoices: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["invoices"])
    CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
      invoice = Invoice.create(status: row['status'],
                               created_at: row['created_at'],
                               updated_at: row['updated_at'])
      puts "Invoice #{invoice.id} created."
    end
  end

  desc "import transaction csv data"
  task transactions: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["transactions"])
    CSV.foreach('./db/data/transactions.csv', headers: true) do |row|
      transaction = Transaction
                    .create(credit_card_number: row['credit_card_number'],
                            result: row['result'],
                            created_at: row['created_at'],
                            updated_at: row['updated_at'])
      puts "Transaction #{transaction.id} with cc# "\
           "#{transaction.credit_card_number} created."
    end
  end

  desc "import item csv data"
  task items: :environment do
    DatabaseCleaner.clean_with(:truncation, only: ["items"])
    CSV.foreach('./db/data/items.csv', headers: true) do |row|
      item = Item.create(name: row['name'],
                         description: row['description'],
                         unit_price: row['unit_price'],
                         created_at: row['created_at'],
                         updated_at: row['updated_at'])
      puts "Item #{item.id}: #{item.name} created."
    end
  end

  desc "import invoice_item csv data"
  task invoice_items: :environment do
    CSV.foreach('./db/data/invoice_items.csv', headers: true) do |row|
      invoice_item = InvoiceItem.create(quantity: row['quantity'],
                                        unit_price: row['unit_price'],
                                        created_at: row['created_at'],
                                        updated_at: row['updated_at'])
      puts "Invoice Item #{invoice_item.id} created."
    end
  end
end
