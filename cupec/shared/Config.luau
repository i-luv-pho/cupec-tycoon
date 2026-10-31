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
	Businesses = {
		{ id = "factory", name = "Siam Works", sector = "MANUFACTURING", cost = 300, assets = 800, income = 8,
			story = "Useful machines. Poor operations. Buy the assets, then fix the bottleneck.",
			projects = {
				{ name = "Fix the production line", cost = 180, addIncome = 10, detail = "Remove downtime: +10 cash / sec" },
				{ name = "Install a second line", cost = 650, addIncome = 22, detail = "Expand output: +22 cash / sec" },
			} },
		{ id = "logistics", name = "Relay Logistics", sector = "LOGISTICS", cost = 1600, assets = 2400, income = 25,
			story = "Acquire the depot. Connect your factory to customers with cheaper distribution.",
			projects = {
				{ name = "Optimize delivery routes", cost = 700, addIncome = 30, detail = "Cut empty trips: +30 cash / sec" },
				{ name = "Expand the loading dock", cost = 1800, addIncome = 50, detail = "Serve more customers: +50 cash / sec" },
			} },
		{ id = "exports", name = "Atlas Exports", sector = "GLOBAL SALES", cost = 6000, assets = 7500, income = 90,
			story = "Take useful products to global customers. Build a business beyond the local market.",
			projects = {
				{ name = "Launch a global catalogue", cost = 2400, addIncome = 90, detail = "Reach new buyers: +90 cash / sec" },
				{ name = "Open an overseas hub", cost = 6000, addIncome = 180, detail = "Scale distribution: +180 cash / sec" },
			} },
	},
}
