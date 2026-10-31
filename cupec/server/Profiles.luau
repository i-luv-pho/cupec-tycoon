--!strict
-- Adapted from the upstream DataManager's session-lock / UpdateAsync pattern.
-- Studio previews use memory only. Live servers refuse unavailable/corrupt saves.
local DSS = game:GetService('DataStoreService')
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local E = require(game:GetService('ReplicatedStorage').CUPEC.Economy)
local Policy = require(game:GetService('ReplicatedStorage').CUPEC.SavePolicy)
local Profiles = { data = {}, closing = {}, busy = {} }
local preview = RunService:IsStudio()
local token = HttpService:GenerateGUID(false)
local store = nil
if not preview then
	local ok, result = pcall(function() return DSS:GetDataStore('CUPEC_Acquisitions_v1') end)
	if ok then store = result else warn('[CUPEC] Save store unavailable:', result) end
end

function Profiles.load(player)
	if preview then
		Profiles.data[player] = E.new()
		return Profiles.data[player], 'LOCAL PREVIEW · saves are off'
	end
	if not store then return nil, 'Saving is unavailable. Please try again later.' end
	local ok, raw = pcall(function()
		return store:UpdateAsync('player_' .. player.UserId, function(old)
			return Policy.acquire(old,token,os.time())
		end)
	end)
	if not ok or not raw then return nil, 'Your save is unavailable or active on another server. Please rejoin in a few minutes.' end
	local data = E.restore(raw)
	if not data then return nil, 'Your save could not be read safely.' end
	Profiles.data[player] = data
	return data, 'ONLINE · autosave enabled'
end

function Profiles.save(player, release)
	local deadline = os.clock() + 20
	while Profiles.busy[player] and os.clock() < deadline do task.wait(0.1) end
	if Profiles.busy[player] then return false end
	local data = Profiles.data[player]
	if not data then return true end
	if preview then return true end
	Profiles.busy[player] = true
	local snapshot = E.restore(data)
	local success = false
	for attempt = 1, 3 do
		local ok, result = pcall(function()
			return store:UpdateAsync('player_' .. player.UserId, function(old)
				return Policy.commit(old,snapshot,token,os.time(),release)
			end)
		end)
		if ok and result then success = true; break end
		task.wait(attempt)
	end
	Profiles.busy[player] = nil
	if not success then warn('[CUPEC] Save failed for player', player.UserId) end
	return success
end

function Profiles.release(player)
	if Profiles.closing[player] then return end
	Profiles.closing[player] = true
	Profiles.save(player, true)
	Profiles.data[player] = nil
	Profiles.closing[player] = nil
end

return Profiles
