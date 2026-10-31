local E=require('../shared/Economy')
local C=require('../shared/Config')
local count=0
local function check(value,label) assert(value,label);count+=1 end
check(#C.Businesses==12,'twelve acquisitions')
local p=E.new()
for i=2,#C.Businesses do
	local snapshot=p.cash
	check(not E.transact(p,'buy',C.Businesses[i].id) and p.cash==snapshot,'locked acquisitions cannot skip progression')
end
local before=p.cash
check(not E.operate(p,'factory') and p.cash==before,'unowned operation cannot grant cash')
E.transact(p,'buy','factory')
local other=E.new()
check(E.operate(p,'factory'),'owned operation pays')
check(p.cash==310 and p.operations==1 and other.cash==C.StartCash,'operation reward and economy isolation')
local restored=E.restore(p)
check(restored.operations==1,'operations persist')
local legacy={version=1,cash=450,earned=0,invested=0,businesses={}}
check(E.restore(legacy).operations==0,'old saves migrate without loss')
legacy.operations=0/0
check(E.restore(legacy)==nil,'corrupt operation count rejected')
local sim=E.new()
local acquired={}
local finishedAt=nil
for t=0,7200 do
	for _,d in C.Businesses do
		if sim.businesses[d.id]==nil then
			if E.transact(sim,'buy',d.id) then acquired[d.id]=t end
		else E.transact(sim,'improve',d.id) end
	end
	local done=true
	for _,d in C.Businesses do if sim.businesses[d.id]~=#d.projects then done=false;break end end
	if done then finishedAt=t;break end
	E.tick(sim,1,1)
end
check(finishedAt~=nil,'full city progression achievable')
check(acquired.hq>600,'city has meaningful progression beyond ten minutes')
for _,d in C.Businesses do check(sim.businesses[d.id]==#d.projects,'all improvements reachable') end
local saved=E.restore(sim)
check(saved and E.rate(saved,1)==E.rate(sim,1),'complete city save roundtrip')
check(not E.operate(sim,{}),'malformed operation rejected')
sim.cash,sim.earned=C.MaxCash-1,C.MaxCash-1
E.operate(sim,'hq')
check(sim.cash==C.MaxCash and sim.earned==C.MaxCash,'operation respects cash caps')
print('PASS: '..count..' city assertions; HQ acquired at '..acquired.hq..'s, all improvements at '..finishedAt..'s')
