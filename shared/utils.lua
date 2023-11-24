Core = Core or {}
Core.Utils = {}

function Core.Utils:Print(index, txt)
	if index == 'warn' or index == 'warning' then
		print('^5[Identity Store]^7: ^3WARNING^7 - '..txt)
	elseif index == 'err' or index == 'error' then
		print('^5[Identity Store]^7: ^1ERROR^7 - '..txt)
	elseif index == 'nil-func' then
		print('^5[Identity Store]^7: ^3WARNING^7 - Du mangler at tilføje framework function i funktionen ^1"'..txt..'"^7')
	else
		if not txt then txt = index end
		print('^5[Identity Store]^7: '..txt)
	end
end

--============================
--==    Table Functions     ==
--==        Credit:         ==
--==      ESX Legacy        ==
--============================
Core.Utils.Table = {}

-- nil proof alternative to #table
function Core.Utils.Table:SizeOf(t)
	local count = 0

	for _,_ in pairs(t) do
		count = count + 1
	end

	return count
end

function Core.Utils.Table:Set(t)
	local set = {}
	for k,v in ipairs(t) do set[v] = true end
	return set
end

function Core.Utils.Table:IndexOf(t, value)
	for i=1, #t, 1 do
		if t[i] == value then
			return i
		end
	end

	return -1
end

function Core.Utils.Table:LastIndexOf(t, value)
	for i=#t, 1, -1 do
		if t[i] == value then
			return i
		end
	end

	return -1
end

function Core.Utils.Table:Find(t, cb)
	for i=1, #t, 1 do
		if cb(t[i]) then
			return t[i]
		end
	end

	return nil
end

function Core.Utils.Table:FindIndex(t, cb)
	for i=1, #t, 1 do
		if cb(t[i]) then
			return i
		end
	end

	return -1
end

function Core.Utils.Table:Filter(t, cb)
	local newTable = {}

	for i=1, #t, 1 do
		if cb(t[i]) then
			table.insert(newTable, t[i])
		end
	end

	return newTable
end

function Core.Utils.Table:Map(t, cb)
	local newTable = {}

	for i=1, #t, 1 do
		newTable[i] = cb(t[i], i)
	end

	return newTable
end

function Core.Utils.Table:Reverse(t)
	local newTable = {}

	for i=#t, 1, -1 do
		table.insert(newTable, t[i])
	end

	return newTable
end

function Core.Utils.Table:Clone(t)
	if type(t) ~= 'table' then return t end

	local meta = getmetatable(t)
	local target = {}

	for k,v in pairs(t) do
		if type(v) == 'table' then
			target[k] = Utils.Table.Clone(v)
		else
			target[k] = v
		end
	end

	setmetatable(target, meta)

	return target
end

function Core.Utils.Table:Concat(t1, t2)
	local t3 = Utils.Table.Clone(t1)

	for i=1, #t2, 1 do
		table.insert(t3, t2[i])
	end

	return t3
end

function Core.Utils.Table:Join(t, sep)
	local sep = sep or ','
	local str = ''

	for i=1, #t, 1 do
		if i > 1 then
			str = str .. sep
		end

		str = str .. t[i]
	end

	return str
end

-- Credit: https://stackoverflow.com/a/15706820
-- Description: sort function for pairs
function Core.Utils.Table:Sort(t, order)
	-- collect the keys
	local keys = {}

	for k,_ in pairs(t) do
		keys[#keys + 1] = k
	end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a,b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	-- return the iterator function
	local i = 0

	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

--===========================
--==    Math Functions     ==
--==        Credit:        ==
--==      ESX Legacy       ==
--===========================
Core.Utils.Math = {}

function Core.Utils.Math:Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

-- credit http://richard.warburton.it
function Core.Utils.Math:GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. _U('locale_digit_grouping_symbol')):reverse())..right
end

function Core.Utils.Math:Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end