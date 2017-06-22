# Stage 0
- - - -
- accounts 
	- add (name)
	- get balance (current, on date)
	- fixation balance on a date with avoiding operations before fixation date
	- transfers between accounts (date)
- orders (purchases)
	- add (date, amount, description)
	- edit and delete


# Stage 1
- - - -
- multi currency support for accounts
	- exchanges
- import data from budget app
- support tags (like a "food", "household", "leisure" etc.) for purchases/orders
- telegram bot as interface


# Stage 2
- - - -
- order details
	- entities refbook
		- good 
		- services
- import data
	- from json-file of FNS app export
	- repeated import control (comparing guid or date-amount)

Stage 3
-------
- support participants of deal (supplier/customer, payer/payee) in orders
	- refbook of participants
- support discount info
- debts
	- participants
	- amount
	- interest rate
	- time-limit
	- partially refunds
	- kind:
		- borrowing
		- loaning
		- common bills 
	

Stage 4
-------
- auto payments (full auto and as reminder after payment time)
	- accounting in budget planning (free money)
- planned outlays
- reasons: gift, food, traveling. To see unnecessary outlays. May be it can be solved by tags





Stage None
----------
- export aggregated data to supported external formats (budget) to decrease data size (by combining some data)
- add prices info without adding orders
- auto fill price in order details (based on ordering history for this supplier)
- support hierarchical suppliers networks (to get statistics about favourites)
- alert for extra outlays
- alert for expiration dates
- accounting money saving by discounts 
- barcode scanner support
- order details from check photo
- get info from banks API

