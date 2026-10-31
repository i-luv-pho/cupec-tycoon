--!strict
-- Pure UpdateAsync transforms. An expired lease may be acquired on load;
-- a save must still own its exact token and cannot steal another lease.
local E = if script then require(script.Parent.Economy) else require('./Economy')
local Policy = {}
function Policy.acquire(old, token, now)
	local p=if old==nil then E.new() else E.restore(old)
	if not p then return nil end
	if old and old._lease then
		local lease=old._lease
		if type(lease)~='table' or type(lease.token)~='string' or type(lease.at)~='number' or lease.at~=lease.at then return nil end
		if lease.token~=token and now-lease.at<180 then return nil end
	end
	p._lease={token=token,at=now}
	return p
end
function Policy.commit(old, snapshot, token, now, release)
	if type(old)~='table' or type(old._lease)~='table' or old._lease.token~=token then return nil end
	local p=E.restore(snapshot)
	if not p then return nil end
	p._lease=if release then nil else {token=token,at=now}
	return p
end
return Policy
