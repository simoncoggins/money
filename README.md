Money App
---------

Rails application for importing banking information, tagging transactions
and providing graphs to help understand spending.

This application is a work in progress. It is currently a single user app
with no authentication so best run locally.

The data is expected to be imported in a CSV format:

DD/MM/YYYY, "-100.00", "Description"

Released under GPL3+

Features
--------

* Upload transactions from CSV files
* Split, edit or delete transactions
* Create and assign custom tags
* Ability to create patterns and assign tags based on matches
* Graph of account balance over time
* Graphs showing spending by tag over days, weeks or months
* Enable or disable specific tags

Screenshots
-----------

![List of transactions](https://raw.github.com/simoncoggins/money/master/transaction-list.jpg)
![Graph of transactions](https://raw.github.com/simoncoggins/money/master/transaction-graph.jpg)
![Graph of account balance](https://raw.github.com/simoncoggins/money/master/balance-graph.jpg)

