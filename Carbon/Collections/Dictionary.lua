--[[
	Carbon for Lua
	Dictionary
]]

local Carbon, self = ...
local List = Carbon.Collections.List
local Set = Carbon.Collections.Set

local Dictionary = {}

Dictionary.__object_metatable = {
	__index = Dictionary
}

--[[
	Dictionary Dictionary:New(table data)
		data: The data of the dictionary

	Turns the given object into a Dictionary.
	Allows method-style syntax.
]]
function Dictionary:New(object)
	return setmetatable(object or {}, self.__object_metatable)
end

--[[
	List Dictionary.Keys(table self)
		self: The table to retrieve keys for.

	Returns all the keys in the table.
]]
function Dictionary.Keys(self)
	local keys = List:New({})

	for key in pairs(self) do
		table.insert(keys, key)
	end

	return keys
end

--[[
	List Dictionary.Values(table self)
		self: The table to retrieve values for.

	Returns all the values in the table.
]]
function Dictionary.Values(self)
	local values = List:New({})

	for key, value in pairs(self) do
		table.insert(values, value)
	end

	return values
end

--[[
	Set Dictionary.ToSet(table self, [table out])
		self: The table to convert to a set.
		out: Where to put the resulting set. Defaults to a new set.

	Converts the Dictionary to a Set.
]]
function Dictionary.ToSet(self, out)
	out = out or Set:New({})

	for key, value in pairs(self) do
		out[key] = not not value
	end

	return values
end

--[[
	table Dictionary.ShallowCopy(table self, [table to])
		self: The table to source data from
		to: The table to copy into; an empty table if not given.

	Shallow copies data from one table into another and returns the result.
]]
function Dictionary.ShallowCopy(self, to)
	to = to or Dictionary:New()

	for key, value in pairs(self) do
		to[key] = value
	end

	return to
end

--[[
	table Dictionary.DeepCopy(table self, [table to, table map])
		self: The table to source data from.
		to: The table to copy into; an empty table if not given.
		map: A map projecting original values into copied values. Used internally.

	Performs a self-reference fixing deep copy from one table into another.
	Handles self-references properly.
]]
function Dictionary.DeepCopy(self, to, map)
	to = to or Dictionary:New()
	map = map or {
		[self] = to
	}

	for key, value in pairs(self) do
		if (type(value) == "table") then
			if (not map[value]) then
				map[value] = {}
				Dictionary.DeepCopy(value, map[value], map)
			end

			to[key] = map[value]
		else
			to[key] = value
		end
	end

	return to
end

--[[
	table Dictionary.DeepCopyExceptTypes(table self, table? to, set except, [table map])
		self: The table to source data from.
		to: The table to copy into; an empty table if nil.
		except: A set of type names to ignore.
		map: A map projecting original values into copied values. Used internally.

	Performs a self-reference fixing deep copy from one table into another.
	Handles self-references properly.
]]
function Dictionary.DeepCopyExceptTypes(self, to, except, map)
	to = to or Dictionary:New()
	map = map or {
		[self] = to
	}

	for key, value in pairs(self) do
		if (not except[type(value)]) then
			if (type(value) == "table") then
				if (not map[value]) then
					map[value] = {}
					Dictionary.DeepCopy(value, map[value], except, map)
				end

				to[key] = map[value]
			else
				to[key] = value
			end
		end
	end

	return to
end

--[[
	table Dictionary.ShallowMerge(table self, table to)
		self: The table to source data from.
		to: The table to output into.

	Performs a merge into a table without overwriting existing keys.
]]
function Dictionary.ShallowMerge(self, to)
	for key, value in pairs(self) do
		if (to[key] == nil) then
			to[key] = value
		end
	end

	return to
end

--[[
	table Dictionary.DeepCopyMerge(table self, table to)
		self: The table to source data from.
		to: The table to put data into.

	Performs a merge into the table, performing a deep copy on all table members.
]]
function Dictionary.DeepCopyMerge(self, to)
	for key, value in pairs(self) do
		if (to[key] == nil) then
			if (type(value) == "table") then
				to[key] = Dictionary.DeepCopy(value)
			else
				to[key] = value
			end
		end
	end

	return to
end

Carbon.Metadata:RegisterMethods(Dictionary, self)

return Dictionary