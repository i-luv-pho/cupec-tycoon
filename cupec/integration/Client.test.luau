local ST=game:GetService('StudioTestService')
if ST:GetTestArgs()~='CUPECAcceptance' then return end
local RS=game:GetService('ReplicatedStorage')
local gate=RS:WaitForChild('CUPECTestGate')
local remote=RS:WaitForChild('CUPEC'):WaitForChild('Portfolio')
gate.OnClientEvent:Connect(function(phase)
 if phase=='first' then remote:FireServer('buy','factory')
 elseif phase=='complete' then
  for _,id in {'factory','logistics','exports'} do
   remote:FireServer('buy',id);task.wait(.6)
   remote:FireServer('improve',id);task.wait(.6)
   remote:FireServer('improve',id);task.wait(.6)
  end
  gate:FireServer('done')
 end
end)
local gui=game.Players.LocalPlayer.PlayerGui:WaitForChild('CUPEC')
local action=gui:WaitForChild('DealRoom'):WaitForChild('Action')
while action.Text=='Connecting…' do remote:FireServer('sync');task.wait(.5) end
task.wait(.5)
gate:FireServer('ready')
