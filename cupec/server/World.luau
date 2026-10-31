--!strict
-- Original CUPEC city. No external art, audio, scripts or paid assets.
local Config=require(game:GetService('ReplicatedStorage').CUPEC.Config)
local World={plots={}}
local navy=Color3.fromRGB(23,34,53)
local rose=Color3.fromRGB(226,140,156)
local cream=Color3.fromRGB(244,235,219)
local gold=Color3.fromRGB(222,181,112)
local teal=Color3.fromRGB(75,145,137)
local gray=Color3.fromRGB(103,115,122)
local function part(parent,name,size,pos,color,material)
	local p=Instance.new('Part')
	p.Name,p.Size,p.Position,p.Color=name,size,pos,color
	p.Anchored=true
	p.Material=material or Enum.Material.SmoothPlastic
	p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth
	p.Parent=parent
	return p
end
local function sign(parent,pos,size,text,bg)
	local board=part(parent,'Sign',size,pos,bg or navy)
	local gui=Instance.new('SurfaceGui')
	gui.Face,gui.PixelsPerStud=Enum.NormalId.Front,25
	gui.Parent=board
	local label=Instance.new('TextLabel')
	label.Size,label.BackgroundTransparency=UDim2.fromScale(1,1),1
	label.Font,label.TextColor3=Enum.Font.GothamBold,cream
	label.TextScaled,label.TextWrapped,label.Text=true,true,text
	label.Parent=gui
	local pad=Instance.new('UIPadding')
	pad.PaddingLeft,pad.PaddingRight=UDim.new(0,8),UDim.new(0,8)
	pad.PaddingTop,pad.PaddingBottom=UDim.new(0,5),UDim.new(0,5)
	pad.Parent=label
	return label
end
local function prompt(parent,action,object,callback)
	local p=Instance.new('ProximityPrompt')
	p.ActionText,p.ObjectText=action,object
	p.HoldDuration,p.MaxActivationDistance,p.RequiresLineOfSight=0.35,12,false
	p.Parent=parent
	p.Triggered:Connect(callback)
	return p
end
local function tree(parent,x,z)
	part(parent,'Trunk',Vector3.new(2,9,2),Vector3.new(x,4.5,z),Color3.fromRGB(112,89,67),Enum.Material.Wood)
	local top=part(parent,'Canopy',Vector3.new(12,13,12),Vector3.new(x,14,z),teal)
	top.Shape=Enum.PartType.Ball
end
local function bench(parent,pos)
	part(parent,'Bench',Vector3.new(9,1,3),pos+Vector3.new(0,2,0),gold,Enum.Material.Wood)
	part(parent,'BenchBack',Vector3.new(9,3,0.6),pos+Vector3.new(0,3.5,1.5),gold,Enum.Material.Wood)
	for _,x in {-3,3} do part(parent,'BenchLeg',Vector3.new(1,2,2),pos+Vector3.new(x,1,0),navy,Enum.Material.Metal) end
end
local function light(parent,pos)
	local pole=part(parent,'Streetlight',Vector3.new(0.7,16,0.7),pos+Vector3.new(0,8,0),navy,Enum.Material.Metal)
	local lamp=part(parent,'Lamp',Vector3.new(4,0.5,3),pos+Vector3.new(0,16,0),cream,Enum.Material.Neon)
	local glow=Instance.new('PointLight');glow.Brightness,glow.Range,glow.Color=0.6,26,cream;glow.Parent=lamp
end
local function interior(b,origin,kind,accent)
	local function item(name,size,offset,color,mat) return part(b,name,size,origin+offset,color,mat) end
	if kind=='factory' then
		item('Conveyor',Vector3.new(29,2,7),Vector3.new(0,2,6),navy,Enum.Material.Metal)
		for j=-2,2 do
			item('Roller',Vector3.new(2,0.4,7),Vector3.new(j*5,3.3,6),gray,Enum.Material.Metal)
			item('Product',Vector3.new(3,2,3),Vector3.new(j*5,4.5,6),accent)
		end
		for _,x in {-17,17} do item('Press',Vector3.new(6,10,9),Vector3.new(x,6,8),teal,Enum.Material.Metal) end
		item('Chimney',Vector3.new(4,15,4),Vector3.new(17,25,15),navy,Enum.Material.Metal)
	elseif kind=='depot' then
		for z=1,2 do for x=-2,2 do item('Cargo',Vector3.new(7,5,6),Vector3.new(x*8,3,(z-1)*9+4),if z==1 then accent else teal) end end
		item('DeliveryTruck',Vector3.new(12,7,20),Vector3.new(28,4,24),cream)
		item('TruckCab',Vector3.new(12,6,7),Vector3.new(28,4,11),accent)
		for _,x in {22,34} do for _,z in {14,30} do local tire=item('Wheel',Vector3.new(2,5,5),Vector3.new(x,2.5,z),navy);tire.Shape=Enum.PartType.Cylinder end end
	elseif kind=='cafe' then
		item('CoffeeBar',Vector3.new(32,5,5),Vector3.new(0,3,11),gold,Enum.Material.Wood)
		item('EspressoMachine',Vector3.new(7,4,4),Vector3.new(-8,7,11),gray,Enum.Material.Metal)
		for _,x in {-14,12} do
			item('Table',Vector3.new(8,1,8),Vector3.new(x,3,-4),rose)
			for _,dx in {-5,5} do item('Seat',Vector3.new(3,2,3),Vector3.new(x+dx,1.5,-4),teal) end
		end
	elseif kind=='retail' then
		for _,x in {-15,0,15} do
			item('Shelf',Vector3.new(8,8,2),Vector3.new(x,5,8),gold,Enum.Material.Wood)
			for j=1,3 do item('Stock',Vector3.new(6,1.5,3),Vector3.new(x,j*2.3,6.5),if j%2==0 then rose else teal) end
		end
	elseif kind=='energy' then
		for _,x in {-15,0,15} do
			local panel=item('SolarPanel',Vector3.new(12,0.7,14),Vector3.new(x,9,7),Color3.fromRGB(42,75,130),Enum.Material.Glass)
			panel.Orientation=Vector3.new(-18,0,0)
			item('PanelStand',Vector3.new(2,8,2),Vector3.new(x,4,7),gray,Enum.Material.Metal)
			item('Battery',Vector3.new(6,5,4),Vector3.new(x,3,-5),teal)
		end
	elseif kind=='hotel' then
		item('Reception',Vector3.new(20,4,5),Vector3.new(10,2.5,6),gold,Enum.Material.Wood)
		item('LoungeSofa',Vector3.new(14,3,6),Vector3.new(-13,2,7),rose)
		for i=1,3 do item('UpperFloor',Vector3.new(52,7,32),Vector3.new(0,21+i*7,2),cream);item('WindowBand',Vector3.new(48,3,0.4),Vector3.new(0,21+i*7,-14.2),teal,Enum.Material.Glass) end
	elseif kind=='clinic' then
		for _,x in {-15,0,15} do item('ConsultingDesk',Vector3.new(9,3,6),Vector3.new(x,2,6),cream);item('Monitor',Vector3.new(4,3,0.5),Vector3.new(x,5,6),teal) end
		item('Reception',Vector3.new(24,4,3),Vector3.new(0,2.5,-7),rose)
	else
		for _,x in {-15,0,15} do
			item('Desk',Vector3.new(10,1,7),Vector3.new(x,4,6),gold,Enum.Material.Wood)
			item('DeskBase',Vector3.new(2,4,4),Vector3.new(x,2,6),navy)
			item('Screen',Vector3.new(6,4,0.5),Vector3.new(x,6.5,7),teal,Enum.Material.Neon)
		end
		if kind=='office' then item('OfficeTower',Vector3.new(30,23,18),Vector3.new(0,31,10),accent) end
	end
end
function World.build(onPrompt,onOperation)
	local previous=workspace:FindFirstChild('CUPECDistrict');if previous then previous:Destroy() end
	World.plots={}
	local root=Instance.new('Folder');root.Name,root.Parent='CUPECDistrict',workspace
	part(root,'CityGround',Vector3.new(900,4,800),Vector3.new(0,-2,0),Color3.fromRGB(164,186,164),Enum.Material.Grass)
	part(root,'NorthSouthAvenue',Vector3.new(42,0.3,760),Vector3.new(0,0.2,0),navy,Enum.Material.Asphalt)
	part(root,'EastWestAvenue',Vector3.new(860,0.3,42),Vector3.new(0,0.25,0),navy,Enum.Material.Asphalt)
	for x=-420,420,24 do part(root,'RoadMark',Vector3.new(10,0.1,0.7),Vector3.new(x,0.45,0),gold) end
	for z=-370,370,24 do part(root,'RoadMark',Vector3.new(0.7,0.1,10),Vector3.new(0,0.45,z),gold) end
	local plaza=part(root,'CUPECPlaza',Vector3.new(90,0.6,55),Vector3.new(0,0.4,-52),cream)
	local fountain=part(root,'Fountain',Vector3.new(16,2,16),Vector3.new(0,1.7,-52),teal,Enum.Material.Glass);fountain.Shape=Enum.PartType.Cylinder;fountain.Orientation=Vector3.new(0,0,90)
	sign(root,Vector3.new(0,19,-81),Vector3.new(70,12,2),'CUPEC\nBUSINESS CITY',navy)
	sign(root,Vector3.new(0,10,-81),Vector3.new(70,5,1),'BUY ASSET VALUE. BUILD GLOBAL REACH.',rose)
	for _,x in {-34,34} do bench(root,Vector3.new(x,0,-55)) end
	for x=-400,400,80 do tree(root,x,-385);tree(root,x,385);light(root,Vector3.new(x,0,27));light(root,Vector3.new(x,0,-27)) end
	for z=-320,320,80 do light(root,Vector3.new(27,0,z));light(root,Vector3.new(-27,0,z)) end
	for index,center in {Vector3.new(-225,0,-195),Vector3.new(225,0,-195),Vector3.new(-225,0,195),Vector3.new(225,0,195)} do
		local model=Instance.new('Model');model.Name,model.Parent='Portfolio'..index,root
		part(model,'DistrictPaving',Vector3.new(390,0.5,310),center+Vector3.new(0,0.5,0),Color3.fromRGB(213,211,200),Enum.Material.Concrete)
		local ownerLabel=sign(model,center+Vector3.new(0,8,-148),Vector3.new(94,10,1),'DISTRICT '..index..' · AVAILABLE',navy)
		local spawn=Instance.new('SpawnLocation');spawn.Name,spawn.Size,spawn.Anchored='PortfolioSpawn',Vector3.new(6,1,6),true
		spawn.CFrame=CFrame.lookAt(center+Vector3.new(0,1.1,-130),center+Vector3.new(0,1.1,0));spawn.Transparency,spawn.Neutral,spawn.Duration=1,true,0;spawn.Parent=model
		local plot={model=model,label=ownerLabel,origin=center,spawn=spawn,buildings={},owner=nil};World.plots[index]=plot
		for row=0,2 do
			local z=-98+row*96
			part(model,'LocalStreet',Vector3.new(380,0.25,18),center+Vector3.new(0,0.85,z-29),navy,Enum.Material.Asphalt)
			for x=-170,170,25 do part(model,'StreetMark',Vector3.new(8,0.1,0.4),center+Vector3.new(x,1,z-29),cream) end
		end
		for i,d in Config.Businesses do
			local col=(i-1)%4;local row=math.floor((i-1)/4)
			local origin=center+Vector3.new(-138+col*92,0,-98+row*96)
			local b=Instance.new('Model');b.Name,b.Parent=d.id,model
			local accent=({rose,teal,gold,Color3.fromRGB(121,151,187)})[col+1]
			part(b,'Floor',Vector3.new(58,1,44),origin+Vector3.new(0,1,3),cream,Enum.Material.Concrete)
			local wall=part(b,'BackWall',Vector3.new(56,17,1),origin+Vector3.new(0,9.5,24),cream)
			for _,x in {-28,28} do part(b,'SideWall',Vector3.new(1,17,44),origin+Vector3.new(x,9.5,3),cream) end
			-- Open shopfront and rear canopy keep interiors visible and walkable.
			part(b,'Canopy',Vector3.new(60,1.5,18),origin+Vector3.new(0,19,16),accent)
			part(b,'ShopHeader',Vector3.new(60,3,2),origin+Vector3.new(0,18,-19),accent)
			for _,x in {-27,27} do part(b,'FrontPillar',Vector3.new(2,17,2),origin+Vector3.new(x,9.5,-18),navy) end
			interior(b,origin,d.kind or 'office',accent)
			sign(b,origin+Vector3.new(0,23,-19),Vector3.new(57,6,1),d.name,navy)
			local status=sign(b,origin+Vector3.new(0,4,-21),Vector3.new(40,5,1),'FOR SALE · $'..d.cost,navy)
			status.Parent.Parent.CanCollide=false
			local desk=part(b,'DealDesk',Vector3.new(8,0.5,5),origin+Vector3.new(-20,1.8,-17),accent,Enum.Material.Neon)
			local inspect=prompt(desk,'Inspect business',d.name,function(player) onPrompt(player,index,d.id) end)
			local workstation=part(b,'OperationsTerminal',Vector3.new(6,4,3),origin+Vector3.new(20,3,-7),teal,Enum.Material.Metal)
			sign(b,origin+Vector3.new(20,7,-7),Vector3.new(13,3,0.5),'OPERATIONS',teal)
			prompt(workstation,'Run operation',d.name,function(player) if onOperation then onOperation(player,index,d.id,workstation) end end)
			plot.buildings[d.id]={wall=wall,status=status,accent=accent,prompt=inspect,origin=origin,model=b,workstation=workstation}
		end
	end
	return plaza
end
function World.assign(index,player)
	local p=World.plots[index];p.owner=player;player.RespawnLocation=p.spawn
	p.label.Text=string.upper(player.DisplayName)..' · DISTRICT '..index
end
function World.refresh(index,profile)
	local p=World.plots[index]
	for _,d in Config.Businesses do
		local b=p.buildings[d.id];local level=profile and profile.businesses[d.id]
		b.wall.Color=if level~=nil then cream else Color3.fromRGB(151,158,158)
		b.status.Text=if level~=nil then 'OWNED · '..level..'/'..#d.projects..' IMPROVEMENTS' else 'FOR SALE · $'..d.cost
		b.prompt.ActionText=if level~=nil then 'Review improvements' else 'Inspect acquisition'
		for j=1,#d.projects do
			local marker=b.model:FindFirstChild('Improvement'..j)
			if level~=nil and level>=j then
				if not marker then part(b.model,'Improvement'..j,Vector3.new(4,2,4),b.origin+Vector3.new(j*7-14,21,15),gold,Enum.Material.Neon) end
			elseif marker then marker:Destroy() end
		end
	end
end
function World.release(index)
	local p=World.plots[index];p.owner=nil;p.label.Text='DISTRICT '..index..' · AVAILABLE';World.refresh(index,nil)
end
function World.teleport(index,character,id)
	local plot=World.plots[index]
	local destination=if id and plot.buildings[id] then plot.buildings[id].origin+Vector3.new(0,5,-35) else plot.origin+Vector3.new(0,5,-130)
	character:PivotTo(CFrame.lookAt(destination,destination+Vector3.new(0,0,20)))
end
return World
