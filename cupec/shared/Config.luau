--!strict
-- All amounts are fictional game cash. No real securities or paid products.
return {
	StartCash = 450,
	MaxCash = 1e12,
	MarketSeconds = 75,
	Markets = {
		{ name = "STEADY DEMAND", factor = 1 },
		{ name = "EXPORT BOOM", factor = 1.25 },
		{ name = "SLOW QUARTER", factor = 0.8 },
	},
	OperationCooldown = 45,
	OperationSeconds = 20,
	Businesses = {
		{ id = "factory", kind = "depot", name = "Epoch Asia Machinery", sector = "MACHINERY SUPPLY", cost = 300, assets = 800, income = 8,
			story = "A fictional machinery supply operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.",
			projects = {
				{ name = "Improve order handling", cost = 180, addIncome = 10, detail = "Remove downtime: +10 cash / sec" },
				{ name = "Add quality controls", cost = 650, addIncome = 22, detail = "Expand output: +22 cash / sec" },
			} },
		{ id = "logistics", kind = "depot", requires = "factory", name = "Olympia Industrial", sector = "INDUSTRIAL SUPPLY", cost = 1600, assets = 2400, income = 25,
			story = "A fictional industrial supply operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.",
			projects = {
				{ name = "Improve order handling", cost = 700, addIncome = 30, detail = "Cut empty trips: +30 cash / sec" },
				{ name = "Add quality controls", cost = 1800, addIncome = 50, detail = "Serve more customers: +50 cash / sec" },
			} },
		{ id = "exports", kind = "depot", requires = "logistics", name = "Fresh Horizon Trade", sector = "FOOD TRADING", cost = 6000, assets = 7500, income = 90,
			story = "A fictional food trading operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.",
			projects = {
				{ name = "Improve order handling", cost = 2400, addIncome = 90, detail = "Reach new buyers: +90 cash / sec" },
				{ name = "Add quality controls", cost = 6000, addIncome = 180, detail = "Scale distribution: +180 cash / sec" },
			} },
		{ id = "cafe", name = "Dewa Foods", sector = "FOOD INGREDIENTS", cost = 42000, assets = 63000, income = 180, requires = "exports", kind = "retail", story = "A fictional food ingredients operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 16800, addIncome = 108, detail = "Increase productive capacity: +108 cash / sec" },
			{ name = "Add quality controls", cost = 37800, addIncome = 180, detail = "Increase productive capacity: +180 cash / sec" },
			{ name = "Expand productive capacity", cost = 63000, addIncome = 288, detail = "Increase productive capacity: +288 cash / sec" }
		} },
		{ id = "market", name = "Astra Packaging", sector = "PACKAGING", cost = 96000, assets = 144000, income = 340, requires = "cafe", kind = "factory", story = "A fictional packaging operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 38400, addIncome = 204, detail = "Increase productive capacity: +204 cash / sec" },
			{ name = "Add quality controls", cost = 86400, addIncome = 340, detail = "Increase productive capacity: +340 cash / sec" },
			{ name = "Expand productive capacity", cost = 144000, addIncome = 544, detail = "Increase productive capacity: +544 cash / sec" }
		} },
		{ id = "solar", name = "Meridian Green Steel", sector = "STEEL", cost = 210000, assets = 330000, income = 650, requires = "market", kind = "factory", story = "A fictional steel operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 84000, addIncome = 390, detail = "Increase productive capacity: +390 cash / sec" },
			{ name = "Add quality controls", cost = 189000, addIncome = 650, detail = "Increase productive capacity: +650 cash / sec" },
			{ name = "Expand productive capacity", cost = 315000, addIncome = 1040, detail = "Increase productive capacity: +1040 cash / sec" }
		} },
		{ id = "hotel", name = "Connecta Auto", sector = "AUTO COMPONENTS", cost = 450000, assets = 690000, income = 1150, requires = "solar", kind = "factory", story = "A fictional auto components operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 180000, addIncome = 690, detail = "Increase productive capacity: +690 cash / sec" },
			{ name = "Add quality controls", cost = 405000, addIncome = 1150, detail = "Increase productive capacity: +1150 cash / sec" },
			{ name = "Expand productive capacity", cost = 675000, addIncome = 1840, detail = "Increase productive capacity: +1840 cash / sec" }
		} },
		{ id = "foods", name = "Sprout & Bean", sector = "FOOD PRODUCTION", cost = 960000, assets = 1500000, income = 2000, requires = "hotel", kind = "factory", story = "A fictional food production operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 384000, addIncome = 1200, detail = "Increase productive capacity: +1200 cash / sec" },
			{ name = "Add quality controls", cost = 864000, addIncome = 2000, detail = "Increase productive capacity: +2000 cash / sec" },
			{ name = "Expand productive capacity", cost = 1440000, addIncome = 3200, detail = "Increase productive capacity: +3200 cash / sec" }
		} },
		{ id = "data", name = "Luma Electronics", sector = "ELECTRONICS", cost = 1950000, assets = 3000000, income = 3500, requires = "foods", kind = "factory", story = "A fictional electronics operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 780000, addIncome = 2100, detail = "Increase productive capacity: +2100 cash / sec" },
			{ name = "Add quality controls", cost = 1755000, addIncome = 3500, detail = "Increase productive capacity: +3500 cash / sec" },
			{ name = "Expand productive capacity", cost = 2925000, addIncome = 5600, detail = "Increase productive capacity: +5600 cash / sec" }
		} },
		{ id = "clinic", name = "Nara Medical Systems", sector = "MEDICAL EQUIPMENT", cost = 3900000, assets = 6300000, income = 5800, requires = "data", kind = "factory", story = "A fictional medical equipment operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 1560000, addIncome = 3480, detail = "Increase productive capacity: +3480 cash / sec" },
			{ name = "Add quality controls", cost = 3510000, addIncome = 5800, detail = "Increase productive capacity: +5800 cash / sec" },
			{ name = "Expand productive capacity", cost = 5850000, addIncome = 9280, detail = "Increase productive capacity: +9280 cash / sec" }
		} },
		{ id = "port", name = "Kinetic Auto Materials", sector = "AUTO MATERIALS", cost = 7800000, assets = 12600000, income = 9500, requires = "clinic", kind = "factory", story = "A fictional auto materials operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 3120000, addIncome = 5700, detail = "Increase productive capacity: +5700 cash / sec" },
			{ name = "Add quality controls", cost = 7020000, addIncome = 9500, detail = "Increase productive capacity: +9500 cash / sec" },
			{ name = "Expand productive capacity", cost = 11700000, addIncome = 15200, detail = "Increase productive capacity: +15200 cash / sec" }
		} },
		{ id = "hq", name = "Kora Foods", sector = "FOOD PRODUCTION", cost = 15600000, assets = 25500000, income = 16000, requires = "port", kind = "office", story = "A fictional food production operator based on a historical DBD case. Explore the premises, improve operations, and build cash flow.", projects = {
			{ name = "Improve order handling", cost = 6240000, addIncome = 9600, detail = "Increase productive capacity: +9600 cash / sec" },
			{ name = "Add quality controls", cost = 14040000, addIncome = 16000, detail = "Increase productive capacity: +16000 cash / sec" },
			{ name = "Expand productive capacity", cost = 23400000, addIncome = 25600, detail = "Increase productive capacity: +25600 cash / sec" }
		} },
	},
}
