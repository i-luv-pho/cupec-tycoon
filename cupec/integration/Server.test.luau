local ST=game:GetService('StudioTestService')
if ST:GetTestArgs()~='CUPECAcceptance' then return end
local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local gate=Instance.new('RemoteEvent');gate.Name='CUPECTestGate';gate.Parent=RS
local ready,done={},{}
gate.OnServerEvent:Connect(function(p,phase) if phase=='ready' then ready[p]=true elseif phase=='done' then done[p]=true end end)
local function waitFor(fn,label)
 local endAt=os.clock()+60
 repeat if fn() then return end;task.wait(.1) until os.clock()>endAt
 error('Timeout: '..label)
end
local checks=0
local function check(x,label) assert(x,label);checks+=1 end
local ok,result=pcall(function()
 local P=require(game.ServerScriptService.CUPEC.Profiles)
 local E=require(RS.CUPEC.Economy)
 waitFor(function() return #Players:GetPlayers()>=1 end,'first player')
 ST:AddPlayers(1)
 waitFor(function() return #Players:GetPlayers()==2 end,'two players')
 local list=Players:GetPlayers();table.sort(list,function(a,b)return a.Name<b.Name end)
 local a,b=list[1],list[2]
 waitFor(function() return ready[a] and ready[b] and P.data[a] and P.data[b] end,'profiles and clients ready')
 waitFor(function() return a.Character and a.Character:FindFirstChild('HumanoidRootPart') and b.Character and b.Character:FindFirstChild('HumanoidRootPart') end,'characters ready')
 task.wait(.5)
 check(P.data[a]~=P.data[b] and P.data[a].businesses~=P.data[b].businesses,'profile objects are independent')
 check(a.RespawnLocation~=b.RespawnLocation,'different portfolios assigned')
 check((a.Character.HumanoidRootPart.Position-a.RespawnLocation.Position).Magnitude<8,'first player spawns on own plot')
 check((b.Character.HumanoidRootPart.Position-b.RespawnLocation.Position).Magnitude<8,'second player spawns on own plot')
 gate:FireClient(a,'first')
 waitFor(function() return P.data[a].businesses.factory~=nil end,'first remote acquisition')
 check(P.data[b].cash==450 and next(P.data[b].businesses)==nil,'first player cannot change second player economy')
 check(P.data[a].invested==300,'first acquisition charged server price')
 P.data[a].cash=100000;P.data[b].cash=100000
 gate:FireAllClients('complete')
 waitFor(function()return done[a] and done[b] end,'both clients complete portfolio')
 for _,p in list do
  local d=P.data[p]
  check(d.businesses.factory==2 and d.businesses.logistics==2 and d.businesses.exports==2,'full upgrade flow '..p.Name..' '..game:GetService('HttpService'):JSONEncode(d.businesses))
  check(math.abs(E.rate(d,1)-580.75)<.01,'correct portfolio income '..p.Name)
  check(d.invested==19630,'correct total investment '..p.Name)
 end
 local prior=a.Character
 a:LoadCharacterAsync()
 waitFor(function()return a.Character and a.Character~=prior and a.Character:FindFirstChild('HumanoidRootPart')end,'respawn')
 task.wait(.5)
 check((a.Character.HumanoidRootPart.Position-a.RespawnLocation.Position).Magnitude<8,'respawn returns to own portfolio')
 check(P.data[a].businesses.exports==2,'respawn preserves portfolio')
 return {passed=true,checks=checks,players=2}
end)
if not ok then result={passed=false,error=tostring(result),checks=checks} end
print('[CUPEC ACCEPTANCE] '..game:GetService('HttpService'):JSONEncode(result))
ST:EndTest(result)
