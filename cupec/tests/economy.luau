local E = require('../shared/Economy')
local C = require('../shared/Config')
local count = 0
local function check(value, label) assert(value, label); count += 1 end
local p, other = E.new(), E.new()
check(E.transact(p, 'buy', 'factory'), 'first acquisition affordable')
check(p.cash == 150 and p.businesses.factory == 0, 'deduct exact acquisition cost')
check(not E.transact(p, 'buy', 'factory') and p.cash == 150, 'duplicate purchase rejected')
check(not E.transact(p, 'improve', 'factory') and p.cash == 150, 'insufficient cash never spent')
E.tick(p, 4, 1)
check(p.cash == 182 and p.earned == 32, 'server income exact')
check(E.transact(p, 'improve', 'factory'), 'fund operational improvement')
check(E.rate(p, 1) == 18 and p.cash == 2, 'improvement increases income')
check(other.cash == C.StartCash and next(other.businesses) == nil, 'profiles isolated')
check(not E.transact(other, 'buy', 'exports'), 'progression cannot be skipped')
for _, id in { false, 5, {}, '', 'nonexistent', string.rep('x',100) } do
	check(not E.transact(p, 'buy', id), 'malformed business rejected')
end
local before = p.cash
for _, dt in { -1, math.huge, 0/0, 6, '10' } do E.tick(p, dt, 1) end
check(before == p.cash, 'invalid time rejected')
E.tick(p, 1, 0/0)
check(before == p.cash, 'invalid market rejected')
check(E.restore(p).cash == p.cash, 'save roundtrip')
local saved = E.restore(p)
saved.businesses.factory = 2
check(p.businesses.factory == 1, 'restore deep copies portfolio')
for _, raw in { {}, {version=1,cash=0/0}, {version=999}, {version=1,cash=-1} } do
	check(E.restore(raw) == nil, 'corrupt save rejected')
end
local sim = E.new()
local elapsed, unlocked = 0, {}
while elapsed < 900 do
	for _, d in C.Businesses do
		if sim.businesses[d.id] == nil then
			if E.transact(sim,'buy',d.id) then unlocked[d.id] = elapsed end
		else E.transact(sim,'improve',d.id) end
	end
	E.tick(sim, 1, 1)
	elapsed += 1
end
check(unlocked.factory == 0, 'immediate first acquisition')
check(unlocked.logistics and unlocked.logistics < 180, 'second acquisition within three minutes')
check(unlocked.exports and unlocked.exports < 600, 'third acquisition within ten minutes')
check(math.abs(E.rate(sim,1) - 580.75) < 0.001, 'integrated portfolio synergy')
check(not E.transact(sim,'improve','exports'), 'improvement cap respected')
local cash = sim.cash
check(not E.transact(sim,'grant', 'factory') and sim.cash == cash, 'unrecognized action cannot mint money')
sim.cash, sim.earned = C.MaxCash - 1, C.MaxCash - 1
E.tick(sim,1,1)
check(sim.cash == C.MaxCash and sim.earned == C.MaxCash, 'cash cap enforced')
print('PASS: '..count..' economy assertions; second acquisition at '..unlocked.logistics..'s, exports at '..unlocked.exports..'s')
