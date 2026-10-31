--!strict
local Players = game:GetService('Players')
local RS = game:GetService('ReplicatedStorage')
local Config = require(RS.CUPEC.Config)
local Economy = require(RS.CUPEC.Economy)
local Profiles = require(script.Parent.Profiles)
local World = require(script.Parent.World)

local remote = Instance.new('RemoteEvent')
remote.Name, remote.Parent = 'Portfolio', RS.CUPEC
local slots, lastAction, saveMode = {}, {}, {}
local marketIndex, nextMarket = 1, os.clock()+Config.MarketSeconds
local shuttingDown=false

local function send(player, message, selected)
	local p=Profiles.data[player]
	if not p or not slots[player] or not player.Parent then return end
	remote:FireClient(player, {
		cash=p.cash, earned=p.earned, invested=p.invested, businesses=table.clone(p.businesses),
		rate=Economy.rate(p,Config.Markets[marketIndex].factor), assets=Economy.assets(p),
		market=Config.Markets[marketIndex].name, factor=Config.Markets[marketIndex].factor,
		nextMarket=math.max(0,math.ceil(nextMarket-os.clock())), slot=slots[player],
		message=message, selected=selected, saveMode=saveMode[player],
	})
end

World.build(function(player,index,id)
	if slots[player]~=index then send(player,'This is another player’s portfolio. Your deals are on your own plot.'); return end
	send(player,nil,id)
end)

local function join(player)
	local free=nil
	for i,plot in World.plots do if not plot.owner then free=i; break end end
	if not free then player:Kick('This district has four portfolios. Please join another server.'); return end
	slots[player]=free
	World.assign(free,player) -- reserve before the save load yields
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild('HumanoidRootPart',10)
		if slots[player] and character.Parent then World.teleport(free,character) end
	end)
	local p,mode=Profiles.load(player)
	if not p then
		if World.plots[free].owner==player then World.release(free) end
		slots[player]=nil
		player:Kick(mode)
		return
	end
	if not player.Parent or shuttingDown then
		Profiles.release(player)
		if World.plots[free].owner==player then World.release(free) end
		slots[player]=nil; return
	end
	saveMode[player]=mode
	World.refresh(free,p)
	if player.Character and player.Character:FindFirstChild('HumanoidRootPart') then World.teleport(free,player.Character) end
	local stats=Instance.new('Folder')
	stats.Name,stats.Parent='leaderstats',player
	local net=Instance.new('IntValue')
	net.Name,net.Parent='Portfolio value',stats
	net.Value=math.floor(p.cash+Economy.assets(p))
	send(player,'Welcome. Acquire Siam Works to put your first business to work.','factory')
end

remote.OnServerEvent:Connect(function(player,action,id)
	if shuttingDown or Profiles.closing[player] or not Profiles.data[player] then return end
	local now=os.clock()
	if now-(lastAction[player] or -1)<0.15 then return end
	lastAction[player]=now
	if action=='sync' then send(player); return end
	if type(action)~='string' or (action~='buy' and action~='improve') then return end
	if type(id)~='string' or #id>32 then return end
	local ok,message=Economy.transact(Profiles.data[player],action,id)
	if ok then World.refresh(slots[player],Profiles.data[player]) end
	send(player,message,id)
end)

Players.PlayerAdded:Connect(function(player) task.spawn(join,player) end)
for _,player in Players:GetPlayers() do task.spawn(join,player) end
Players.PlayerRemoving:Connect(function(player)
	local index=slots[player]
	slots[player],lastAction[player],saveMode[player]=nil,nil,nil
	if index then World.release(index) end
	Profiles.release(player)
end)

task.spawn(function()
	local previous=os.clock()
	while not shuttingDown do
		task.wait(1)
		local now=os.clock()
		local delta=math.min(now-previous,5)
		previous=now
		if now>=nextMarket then
			marketIndex=marketIndex%#Config.Markets+1
			nextMarket=now+Config.MarketSeconds
		end
		for player,p in Profiles.data do
			if not Profiles.closing[player] and slots[player] then
				Economy.tick(p,delta,Config.Markets[marketIndex].factor)
				local stats=player:FindFirstChild('leaderstats')
				if stats then stats['Portfolio value'].Value=math.floor(p.cash+Economy.assets(p)) end
				send(player)
			end
		end
	end
end)

task.spawn(function()
	while not shuttingDown do
		task.wait(45)
		for player in Profiles.data do
			if not Profiles.closing[player] then
				if not Profiles.save(player,false) then
					Profiles.release(player)
					player:Kick('Saving was interrupted. Please rejoin so we can protect your progress.')
				end
			end
		end
	end
end)

game:BindToClose(function()
	shuttingDown=true
	local pending=0
	for player in Profiles.data do
		pending+=1
		task.spawn(function() Profiles.release(player); pending-=1 end)
	end
	local deadline=os.clock()+25
	while pending>0 and os.clock()<deadline do task.wait(0.1) end
end)
print('[CUPEC] Acquisition District ready. Four portfolios; server-authoritative economy.')
