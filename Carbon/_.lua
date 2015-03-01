--[[
	Carbon for Lua
	Core
]]

local libCarbon = (...)
local Configuration = libCarbon.Configuration

local Carbon = {
	Version = {1, 0, 0, ""},

	Config = {
	}
}

Carbon.VersionString = ("%d.%d.%d%s"):format(unpack(Carbon.Version))

Carbon.Async = coroutine.wrap

Carbon.Assert = function(...)
	if (not (...)) then
		error(tostring(select(2, ...)), 2)
	end

	return ...
end

Carbon.Error = function(...)
	error(tostring(...))
end

-- These shims are used for Carbide and its dependencies.
for key, value in pairs(Carbon) do
	libCarbon[key] = value
end

libCarbon:GetGrapheneCore().Config.Loaders[".tlua"] = libCarbon.Carbide.CompileTemplated
libCarbon:GetGrapheneCore().Config.Loaders[".clua"] = libCarbon.Carbide.Compile

return Carbon