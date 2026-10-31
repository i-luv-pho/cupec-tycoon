--!strict
local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local UIS=game:GetService('UserInputService')
local GuiService=game:GetService('GuiService')
local player=Players.LocalPlayer
local modules=RS:WaitForChild('CUPEC')
local Config=require(modules:WaitForChild('Config'))
local Format=require(modules:WaitForChild('Format')) -- retained from the MIT upstream
local remote=modules:WaitForChild('Portfolio')
local navy=Color3.fromRGB(23,34,53)
local panel=Color3.fromRGB(32,45,65)
local cream=Color3.fromRGB(246,238,225)
local muted=Color3.fromRGB(178,190,199)
local rose=Color3.fromRGB(232,154,170)
local gold=Color3.fromRGB(229,190,126)
local teal=Color3.fromRGB(117,210,180)
local state=nil
local selected='factory'
local collapsed=false
local toastUntil=0
local function create(class,parent,props)
	local instance=Instance.new(class)
	for k,v in props do instance[k]=v end
	instance.Parent=parent
	return instance
end
local function corner(p,r) create('UICorner',p,{CornerRadius=UDim.new(0,r or 12)}) end
local function label(p,text,pos,size,fontSize,color)
	return create('TextLabel',p,{Text=text,Position=pos,Size=size,TextSize=fontSize or 15,Font=Enum.Font.GothamMedium,
		TextColor3=color or cream,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,TextWrapped=true})
end
local function button(p,text,pos,size,color)
	local b=create('TextButton',p,{Text=text,Position=pos,Size=size,BackgroundColor3=color or rose,
		TextColor3=navy,Font=Enum.Font.GothamBold,TextSize=14,BorderSizePixel=0,AutoButtonColor=true})
	corner(b,9)
	return b
end
local function money(n) return '$'..Format.number(n or 0) end
local gui=create('ScreenGui',player:WaitForChild('PlayerGui'),{Name='CUPEC',ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=false})
local top=create('Frame',gui,{Name='PortfolioHeader',Size=UDim2.new(1,-24,0,90),Position=UDim2.fromOffset(12,10),BackgroundColor3=navy,BorderSizePixel=0})
corner(top)
label(top,'CUPEC',UDim2.fromOffset(16,8),UDim2.fromOffset(100,28),24,rose).Font=Enum.Font.GothamBlack
local strap=label(top,'ACQUISITION DISTRICT',UDim2.fromOffset(122,12),UDim2.new(1,-280,0,22),12,muted)
local cash=label(top,'Connecting…',UDim2.fromOffset(16,43),UDim2.fromOffset(230,30),25,cream)
local income=label(top,'',UDim2.fromOffset(246,44),UDim2.fromOffset(230,28),17,teal)
local toggle=button(top,'PORTFOLIO',UDim2.new(1,-133,0,16),UDim2.fromOffset(118,44),cream)
local market=label(top,'',UDim2.new(1,-348,0,51),UDim2.fromOffset(330,24),12,gold)
market.TextXAlignment=Enum.TextXAlignment.Right

local drawer=create('ScrollingFrame',gui,{Name='DealRoom',AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,12,1,-12),Size=UDim2.fromOffset(390,474),CanvasSize=UDim2.fromOffset(390,474),ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=4,ScrollBarImageColor3=rose,BackgroundColor3=navy,BorderSizePixel=0})
corner(drawer)
local scale=create('UIScale',drawer,{Scale=1})
label(drawer,'YOUR NEXT MOVE',UDim2.fromOffset(18,12),UDim2.fromOffset(300,22),12,rose)
local tabs={}
for i,d in Config.Businesses do
	local tab=button(drawer,tostring(i)..'  '..({'WORKS','RELAY','ATLAS'})[i],UDim2.fromOffset(18+(i-1)*120,42),UDim2.fromOffset(112,42),panel)
	tab.TextColor3=cream
	tabs[d.id]=tab
	tab.Activated:Connect(function() selected=d.id; if state then state.selected=d.id end end)
end
local sector=label(drawer,'',UDim2.fromOffset(18,99),UDim2.fromOffset(350,18),11,rose)
local name=label(drawer,'Loading your portfolio…',UDim2.fromOffset(18,121),UDim2.fromOffset(350,34),26)
name.Font=Enum.Font.GothamBold
local story=label(drawer,'The server is preparing your district.',UDim2.fromOffset(18,162),UDim2.fromOffset(350,54),14,muted)
local metrics=create('Frame',drawer,{Position=UDim2.fromOffset(18,229),Size=UDim2.fromOffset(354,66),BackgroundColor3=panel,BorderSizePixel=0})
corner(metrics,9)
local metricA=label(metrics,'',UDim2.fromOffset(12,6),UDim2.fromOffset(160,49),14)
local metricB=label(metrics,'',UDim2.fromOffset(178,6),UDim2.fromOffset(164,49),14,teal)
local project=label(drawer,'',UDim2.fromOffset(18,309),UDim2.fromOffset(350,43),16,cream)
local detail=label(drawer,'',UDim2.fromOffset(18,353),UDim2.fromOffset(350,26),13,muted)
local action=button(drawer,'Connecting…',UDim2.fromOffset(18,389),UDim2.fromOffset(354,48),rose)
local footer=label(drawer,'',UDim2.fromOffset(18,441),UDim2.fromOffset(354,20),10,muted)
local toast=create('Frame',gui,{Name='Notice',AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,110),Size=UDim2.new(0.7,0,0,48),BackgroundColor3=navy,BorderSizePixel=0,Visible=false})
corner(toast)
local toastText=label(toast,'',UDim2.fromOffset(12,4),UDim2.new(1,-24,1,-8),14,cream)
toastText.TextXAlignment=Enum.TextXAlignment.Center
local hint=label(gui,'WASD to explore · E at a deal desk · P for portfolio',UDim2.new(1,-490,1,-45),UDim2.fromOffset(470,28),13,cream)
hint.TextXAlignment=Enum.TextXAlignment.Right

local function currentDef()
	for _,d in Config.Businesses do if d.id==selected then return d end end
	return Config.Businesses[1]
end
local function refresh()
	if not state then return end
	local d=currentDef()
	local level=state.businesses[d.id]
	cash.Text=money(state.cash)
	income.Text='+'..money(state.rate)..' / sec'
	market.Text=state.market..' · '..state.nextMarket..'s'
	sector.Text=d.sector
	name.Text=d.name
	story.Text=d.story
	metricA.Text=if level==nil then 'ASKING PRICE\n'..money(d.cost) else 'ASSET VALUE\n'..money(d.assets)
	metricB.Text=if level==nil then ('PRICE / BOOK\n%.2fx'):format(d.cost/d.assets) else 'IMPROVEMENTS\n'..level..' / '..#d.projects
	local nextProject=level~=nil and d.projects[level+1] or nil
	local cost=d.cost
	local available=true
	if level==nil then
		project.Text='Acquire the business'
		detail.Text='Base cash flow: +'..money(d.income)..' / sec'
		if d.id=='logistics' and state.businesses.factory==nil then available=false end
		if d.id=='exports' and state.businesses.logistics==nil then available=false end
		action.Text=if available then 'ACQUIRE · '..money(d.cost) else 'ACQUIRE THE PREVIOUS BUSINESS FIRST'
	elseif nextProject then
		cost=nextProject.cost
		project.Text=nextProject.name
		detail.Text=nextProject.detail
		action.Text='FUND IMPROVEMENT · '..money(cost)
	else
		available=false
		project.Text='Business fully improved'
		detail.Text=if d.id=='exports' then 'You built a global portfolio. Keep growing cash flow.' else 'Use its cash flow to fund the next acquisition.'
		action.Text='OPERATING AT FULL POTENTIAL'
	end
	local affordable=available and state.cash>=cost
	action.BackgroundColor3=if affordable then rose else panel
	action.TextColor3=if affordable then navy else muted
	footer.Text=state.saveMode..' · Portfolio '..state.slot
	for id,tab in tabs do
		tab.BackgroundColor3=if id==selected then cream else panel
		tab.TextColor3=if id==selected then navy else muted
	end
end

action.Activated:Connect(function()
	if state then remote:FireServer(if state.businesses[selected]==nil then 'buy' else 'improve',selected) end
end)
toggle.Activated:Connect(function() collapsed=not collapsed; drawer.Visible=not collapsed end)
UIS.InputBegan:Connect(function(input,processed)
	if not processed and input.KeyCode==Enum.KeyCode.P then collapsed=not collapsed; drawer.Visible=not collapsed end
end)
remote.OnClientEvent:Connect(function(snapshot)
	state=snapshot
	if snapshot.selected then selected=snapshot.selected; collapsed=false; drawer.Visible=true end
	if snapshot.message then
		toastText.Text=snapshot.message
		toast.Visible=true
		toastUntil=os.clock()+5
	end
	refresh()
end)
local function resize()
	local camera=workspace.CurrentCamera
	if not camera then return end
	local size=camera.ViewportSize
	local inset=GuiService:GetGuiInset()
	scale.Scale=math.min(1,(size.X-24)/390)
	local small=size.X<700
	local headerHeight=if small then 118 else 90
	top.Size=UDim2.new(1,-24,0,headerHeight)
	cash.Position=UDim2.fromOffset(16,if small then 53 else 43)
	drawer.Size=UDim2.fromOffset(390,math.min(474,math.max(100,(size.Y-inset.Y-headerHeight-45)/scale.Scale)))
	toast.Position=UDim2.new(0.5,0,0,headerHeight+20)
	strap.Visible=not small
	income.Position=if small then UDim2.fromOffset(16,83) else UDim2.fromOffset(246,44)
	income.TextSize=if small then 14 else 17
	market.Visible=not small
	hint.Visible=not UIS.TouchEnabled and size.X>900
end
task.spawn(function()
	while gui.Parent do
		refresh(); resize()
		if toast.Visible and os.clock()>toastUntil then toast.Visible=false end
		if not state then remote:FireServer('sync') end
		task.wait(0.3)
	end
end)
