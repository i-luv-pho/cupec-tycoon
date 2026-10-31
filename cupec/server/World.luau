--!strict
local Config = require(game:GetService('ReplicatedStorage').CUPEC.Config)
local World = { plots = {} }
local navy = Color3.fromRGB(23, 34, 53)
local rose = Color3.fromRGB(226, 140, 156)
local cream = Color3.fromRGB(244, 235, 219)
local gold = Color3.fromRGB(222, 181, 112)
local teal = Color3.fromRGB(75, 145, 137)

local function part(parent, name, size, pos, color, material)
	local p = Instance.new('Part')
	p.Name, p.Size, p.Position, p.Color = name, size, pos, color
	p.Anchored = true
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function sign(parent, pos, size, text, bg)
	local board = part(parent, 'Sign', size, pos, bg or navy)
	local gui = Instance.new('SurfaceGui')
	gui.Face, gui.PixelsPerStud = Enum.NormalId.Front, 35
	gui.Parent = board
	local label = Instance.new('TextLabel')
	label.Size, label.BackgroundTransparency = UDim2.fromScale(1,1), 1
	label.Font, label.TextColor3 = Enum.Font.GothamBold, cream
	label.TextScaled, label.TextWrapped, label.Text = true, true, text
	label.Parent = gui
	local pad = Instance.new('UIPadding')
	pad.PaddingLeft, pad.PaddingRight = UDim.new(0,12), UDim.new(0,12)
	pad.PaddingTop, pad.PaddingBottom = UDim.new(0,6), UDim.new(0,6)
	pad.Parent = label
	return label
end

local function tree(parent, x, z)
	part(parent, 'Trunk', Vector3.new(1.5,7,1.5), Vector3.new(x,4,z), Color3.fromRGB(112,89,67), Enum.Material.Wood)
	local canopy = part(parent, 'Canopy', Vector3.new(8,9,8), Vector3.new(x,11,z), teal)
	canopy.Shape = Enum.PartType.Ball
end

function World.build(onPrompt)
	local root = Instance.new('Folder')
	root.Name, root.Parent = 'CUPECDistrict', workspace
	part(root, 'Island', Vector3.new(260,4,240), Vector3.new(0,-2,0), Color3.fromRGB(189,204,188), Enum.Material.Grass)
	part(root, 'Boulevard', Vector3.new(244,0.3,26), Vector3.new(0,0.2,0), navy)
	part(root, 'Crosswalk', Vector3.new(20,0.35,222), Vector3.new(0,0.25,0), cream)
	for x = -110,110,20 do part(root, 'RoadMark', Vector3.new(8,0.1,0.4), Vector3.new(x,0.42,0), gold) end
	for _, z in {-16,16} do part(root,'Kerb',Vector3.new(244,0.8,2),Vector3.new(0,0.4,z),cream) end
	local plaza = part(root, 'CUPEC Plaza', Vector3.new(38,1,35), Vector3.new(0,0.5,-37), cream)
	local spawn = Instance.new('SpawnLocation')
	spawn.Size, spawn.Position, spawn.Anchored = Vector3.new(8,1,8), Vector3.new(0,1.3,-27), true
	spawn.Transparency, spawn.Neutral, spawn.Duration = 1, true, 0
	spawn.Parent = root
	sign(root,Vector3.new(0,14,-50),Vector3.new(34,9,2),'CUPEC\nACQUISITION DISTRICT',navy)
	sign(root,Vector3.new(0,6,-49),Vector3.new(34,4,1),'BUY ASSET VALUE. BUILD GLOBAL REACH.',rose)
	for _, x in {-118,-12,12,118} do for _, z in {-103,-20,22,105} do tree(root,x,z) end end
	for index, center in {Vector3.new(-67,0,-63), Vector3.new(67,0,-63), Vector3.new(-67,0,64), Vector3.new(67,0,64)} do
		local model = Instance.new('Model')
		model.Name, model.Parent = 'Portfolio'..index, root
		part(model,'Courtyard',Vector3.new(96,0.5,76),center+Vector3.new(0,0.5,0),Color3.fromRGB(224,220,209))
		local ownerLabel = sign(model,center+Vector3.new(0,6,-36),Vector3.new(48,6,1),'PORTFOLIO '..index..' · AVAILABLE',navy)
		local plot = { model = model, label = ownerLabel, origin = center, buildings = {}, owner = nil }
		World.plots[index] = plot
		for i,d in Config.Businesses do
			local origin = center + Vector3.new((i-2)*30,0,0)
			local b = Instance.new('Model')
			b.Name, b.Parent = d.id, model
			local accent = ({rose,teal,gold})[i]
			part(b,'Foundation',Vector3.new(26,1,27),origin+Vector3.new(0,1,0),navy)
			local wall = part(b,'Building',Vector3.new(24,12,22),origin+Vector3.new(0,7,0),cream)
			part(b,'Roof',Vector3.new(26,1.5,24),origin+Vector3.new(0,13.5,0),accent)
			for _, x in {-8,8} do
				local glass=part(b,'Window',Vector3.new(4,5,0.3),origin+Vector3.new(x,8,-11.2),Color3.fromRGB(80,130,150),Enum.Material.Glass)
				glass.Transparency=0.2
			end
			part(b,'Door',Vector3.new(4,7,0.4),origin+Vector3.new(0,4.5,-11.3),navy)
			local title = sign(b,origin+Vector3.new(0,17,0),Vector3.new(26,4,1),d.name,navy)
			local status = sign(b,origin+Vector3.new(0,3,-17),Vector3.new(25,4,1),'FOR SALE · $'..d.cost,navy)
			local pad=part(b,'DealDesk',Vector3.new(6,0.4,5),origin+Vector3.new(0,0.9,-24),accent,Enum.Material.Neon)
			local prompt=Instance.new('ProximityPrompt')
			prompt.ActionText, prompt.ObjectText = 'Inspect business', d.name
			prompt.HoldDuration, prompt.MaxActivationDistance, prompt.RequiresLineOfSight = 0, 12, false
			prompt.Parent=pad
			prompt.Triggered:Connect(function(player) onPrompt(player,index,d.id) end)
			local machines={}
			if i==1 then
				for j=1,2 do
					local stack=part(b,'Chimney',Vector3.new(3,10,3),origin+Vector3.new(j*7-10,19,6),navy,Enum.Material.Metal)
					table.insert(machines,stack)
				end
			elseif i==2 then
				for j=1,3 do table.insert(machines,part(b,'Cargo',Vector3.new(6,3,4),origin+Vector3.new(j*7-14,3,17),accent)) end
			else
				part(b,'Tower',Vector3.new(12,9,12),origin+Vector3.new(0,18,3),accent)
				local globe=part(b,'Globe',Vector3.new(7,7,7),origin+Vector3.new(0,26,3),teal,Enum.Material.Glass)
				globe.Shape=Enum.PartType.Ball
			end
			plot.buildings[d.id]={wall=wall, status=status, accent=accent, prompt=prompt, origin=origin, model=b}
		end
	end
	return plaza
end

function World.assign(index, player)
	local p=World.plots[index]
	p.owner=player
	p.label.Text=string.upper(player.DisplayName)..' · PORTFOLIO '..index
end

function World.refresh(index, profile)
	local p=World.plots[index]
	for _,d in Config.Businesses do
		local b=p.buildings[d.id]
		local level=profile and profile.businesses[d.id]
		b.wall.Color=if level~=nil then cream else Color3.fromRGB(155,160,160)
		b.status.Text=if level~=nil then 'OWNED · '..level..'/2 IMPROVEMENTS' else 'FOR SALE · $'..d.cost
		b.prompt.ActionText=if level~=nil then 'Review improvements' else 'Inspect acquisition'
		for j=1,2 do
			local marker=b.model:FindFirstChild('Improvement'..j)
			if level~=nil and level>=j then
				if not marker then part(b.model,'Improvement'..j,Vector3.new(3,1,3),b.origin+Vector3.new(j*5-7,15,0),gold,Enum.Material.Neon) end
			elseif marker then marker:Destroy() end
		end
	end
end

function World.release(index)
	local p=World.plots[index]
	p.owner=nil
	p.label.Text='PORTFOLIO '..index..' · AVAILABLE'
	World.refresh(index,nil)
end

function World.teleport(index, character)
	local center=World.plots[index].origin
	character:PivotTo(CFrame.lookAt(center+Vector3.new(0,5,-29),center+Vector3.new(0,5,0)))
end

return World
