--!strict
-- Pure domain logic; shared by the authoritative server and CLI tests.
local Config = if script then require(script.Parent.Config) else require('./Config')
local Economy = {}

function Economy.new()
	return { cash = Config.StartCash, earned = 0, invested = 0, businesses = {}, operations = 0, version = 1 }
end

local function finite(n)
	return type(n) == 'number' and n == n and math.abs(n) < math.huge
end

function Economy.definition(id)
	if type(id) ~= 'string' or #id > 32 then return nil end
	for _, def in Config.Businesses do if def.id == id then return def end end
	return nil
end

function Economy.restore(raw)
	if type(raw) ~= 'table' or raw.version ~= 1 then return nil end
	if not finite(raw.cash) or raw.cash < 0 or raw.cash > Config.MaxCash then return nil end
	if not finite(raw.earned) or raw.earned < 0 or raw.earned > Config.MaxCash then return nil end
	if not finite(raw.invested) or raw.invested < 0 or raw.invested > Config.MaxCash then return nil end
	if type(raw.businesses) ~= 'table' then return nil end
	local p = Economy.new()
	p.cash, p.earned, p.invested = raw.cash, raw.earned, raw.invested
	if raw.operations ~= nil then
		if not finite(raw.operations) or raw.operations < 0 or raw.operations % 1 ~= 0 or raw.operations > 1e9 then return nil end
		p.operations = raw.operations
	end
	for id, level in raw.businesses do
		local d = Economy.definition(id)
		if not d or not finite(level) or level % 1 ~= 0 or level < 0 or level > #d.projects then return nil end
		p.businesses[id] = level
	end
	return p
end

function Economy.rate(p, factor)
	local rate = 0
	for _, d in Config.Businesses do
		local level = p.businesses[d.id]
		if level ~= nil then
			rate += d.income
			for i = 1, level do rate += d.projects[i].addIncome end
		end
	end
	-- An integrated factory/depot creates a small operating synergy.
	if p.businesses.factory ~= nil and p.businesses.logistics ~= nil then rate *= 1.15 end
	return rate * factor
end

function Economy.assets(p)
	local assets = 0
	for _, d in Config.Businesses do
		local level = p.businesses[d.id]
		if level ~= nil then
			assets += d.assets
			for i = 1, level do assets += d.projects[i].cost end
		end
	end
	return assets
end

function Economy.transact(p, action, id)
	local d = Economy.definition(id)
	if not d then return false, 'Unknown business.' end
	local level = p.businesses[id]
	if action == 'buy' then
		if level ~= nil then return false, 'You already own this business.' end
		if d.requires and p.businesses[d.requires] == nil then return false, 'Acquire ' .. Economy.definition(d.requires).name .. ' first.' end
		if p.cash < d.cost then return false, 'Earn more cash before acquiring this business.' end
		p.cash -= d.cost
		p.invested += d.cost
		p.businesses[id] = 0
		return true, 'Acquired ' .. d.name .. '!'
	elseif action == 'improve' then
		if level == nil then return false, 'Acquire this business first.' end
		local project = d.projects[level + 1]
		if not project then return false, 'All improvements are complete.' end
		if p.cash < project.cost then return false, 'Earn more cash before funding this improvement.' end
		p.cash -= project.cost
		p.invested += project.cost
		p.businesses[id] = level + 1
		return true, project.name .. ' complete!'
	end
	return false, 'Unknown action.'
end

function Economy.operate(p, id)
	local d = Economy.definition(id)
	if not d or p.businesses[id] == nil then return false, 'Acquire this business before running operations.' end
	local rate = d.income
	for i=1,p.businesses[id] do rate += d.projects[i].addIncome end
	local reward = math.min(rate * Config.OperationSeconds, Config.MaxCash-p.cash, Config.MaxCash-p.earned)
	p.cash += reward
	p.earned += reward
	p.operations = math.min((p.operations or 0)+1,1e9)
	return true, 'Operation completed at '..d.name..'! +$'..math.floor(reward)
end

function Economy.tick(p, seconds, factor)
	if not finite(seconds) or seconds < 0 or seconds > 5 then return 0 end
	if not finite(factor) or factor < 0.5 or factor > 2 then return 0 end
	local earned = math.min(Economy.rate(p, factor) * seconds, Config.MaxCash - p.cash, Config.MaxCash - p.earned)
	p.cash += earned
	p.earned += earned
	return earned
end

return Economy
