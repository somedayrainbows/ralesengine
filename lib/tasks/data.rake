require 'csv'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

namespace :data do
  desc "import all csv data"
  task seed: :environment do
    DatabaseCleaner.clean
    
  end
end
