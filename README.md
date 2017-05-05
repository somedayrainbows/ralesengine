# README

* In this project, we used Rails and ActiveRecord to build a JSON API which exposes the SalesEngine data schema.
* Rails version 5, PostgreSQL

### Let's go!

Go to your terminal, then:

  * Use `cd` to enter the directory in which you would like to run this project.
  * Type the following to clone the repository to your machine: `git clone https://git@github.com/somedayrainbows/ralesengine.git`
  * Type `cd ralesengine` to open the project.
  * Bundle install the necessary gems by typing `bundle`.
  * Run `rake db:create` to create the database.
  * Then, run, `rake db:migrate` to set up the database according to our schema.
  * Finally, run `rake seed:all` to load the seed data into the database.

### RSpec test suite and Checking Coverage with SimpleCov

Start by running our test suite.

  * Enter `rspec` on the command line to run the test suite.
  * Next, enter `open coverage/index.html` on the command line to see test coverage.

### Running the server locally

  * To start up the server from within the project, run `rails s`.
  * Then, visit your browser and enter any of the endpoints below to
  * In your browser, visit any provided endpoint below to view the response (such as: `http://localhost:3000/api/v1/invoices`)
  * Type `ctrl-c` to stop the server and return to the command line.

### Record Endpoints

There are six tables of data in this project: merchants, customers, items, invoices, invoice_items, and transactions. Each can be accessed from the following index endpoints or individually using the record's unique id.

  * merchants
    `GET /api/v1/merchants/`
    `GET /api/v1/merchants/1`

  * customers
    `GET /api/v1/customers/`
    `GET /api/v1/customers/1`

  * items
    `GET /api/v1/items/`
    `GET /api/v1/items/1`

  * invoices
    `GET /api/v1/invoices/`
    `GET /api/v1/invoices/1`

  * invoice_items
    `GET /api/v1/invoice_items/`
    `GET /api/v1/invoice_items/1`

  * transactions
    `GET /api/v1/transactions/`
    `GET /api/v1/transactions/1`

Additionally, you can use our single and multi-finder methods to return results using any of a model's attributes. You can also use the random finder method to generate a random row from one of the tables.

Examples queries:
`GET /api/v1/merchants/find?name=Schroeder-Jerde`
`GET /api/v1/invoices/find_all?status=shipped`
`GET /api/v1/items/random`

#### Relationship Endpoints

##### Merchants

`GET /api/v1/merchants/:id/items` returns a collection of items associated with that merchant

`GET /api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders

##### Invoices

`GET /api/v1/invoices/:id/transactions` returns a collection of associated transactions

`GET /api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items

`GET /api/v1/invoices/:id/items` returns a collection of associated items

`GET /api/v1/invoices/:id/customer` returns the associated customer

`GET /api/v1/invoices/:id/merchant` returns the associated merchant

##### Invoice Items

`GET /api/v1/invoice_items/:id/invoice` returns the associated invoice

`GET /api/v1/invoice_items/:id/item` returns the associated item

##### Items

`GET /api/v1/items/:id/invoice_items` returns a collection of associated invoice items

`GET /api/v1/items/:id/merchant` returns the associated merchant

##### Transactions

`GET /api/v1/transactions/:id/invoice` returns the associated invoice

##### Customers

`GET /api/v1/customers/:id/invoices` returns a collection of associated invoices

`GET /api/v1/customers/:id/transactions` returns a collection of associated transactions

#### Business Intelligence Endpoints

##### All Merchants

`GET /api/v1/merchants/most_revenue?quantity=x` returns the top x merchants ranked by total revenue

`GET /api/v1/merchants/most_items?quantity=x` returns the top x merchants ranked by total number of items sold

`GET /api/v1/merchants/revenue?date=x` returns the total revenue for date x across all merchants

##### Single Merchant

`GET /api/v1/merchants/:id/revenue` returns the total revenue for that merchant across all transactions

`GET /api/v1/merchants/:id/revenue?date=x` returns the total revenue for that merchant for a specific invoice date x

`GET /api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions

`GET /api/v1/merchants/:id/customers_with_pending_invoices` returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success

##### Items

`GET /api/v1/items/most_revenue?quantity=x` returns the top x items ranked by total revenue generated

`GET /api/v1/items/most_items?quantity=x` returns the top x item instances ranked by total number sold

`GET /api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, returns the most recent day.

##### Customers

`GET /api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions

##### The end!

Thank you for visiting our project.

- Erin & Danny
