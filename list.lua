List = {}

setmetatable(List, {
	__index = table
})

function List:new(l)
	local list = l or {}
	setmetatable(list, {
		__index = List,
		__tostring = List.tostring
	})
	return list
end

function List:partition( op )
	local true_ret = List:new()
	local false_ret = List:new()

	self:__walk(function ( value )
		if op(value) then
			true_ret:insert(value)
		else
			false_ret:insert(value)
		end
	end)

	return true_ret, false_ret
end

function List:filter( op )
	local ret = self:partition(op)
	return ret
end

function List:takeWhile( op )
	local ret = List:new()

	self:__walk(function ( value )

		if op(value) then
			ret:insert(value)
		else
			return true
		end

	end)

	return ret
end

function List:dropWhile( op )
	local ret = List:new()
	local can_drop = true

	self:__walk(function ( value )
		if can_drop and op(value) then
			
		else
			can_drop = false
			ret:insert(value)
		end

	end)
	return ret
end

function List:tostring( ... )
	
	local str = ''
	local tbl = {}

	self:__walk(function ( value )
		table.insert(tbl, tostring(value))
	end)
		
	str = '[' .. table.concat(tbl, ',') .. ']'

	return str
end

function List:find( op )

	local finded, finded_index

	self:__walk(function ( value, index)
		if op(value) then
			finded = value
			finded_index = index
			return true
		end
	end)
	return finded, finded_index
end

function List:__walk( op )
	for index, value in ipairs(self) do
		if op(value, index) then
			return
		end
	end
end

function List:__walk_reverse( op )
	local len = #self
	for index, value in ipairs(self) do
		value = self[len + 1 - index]
		if op(value, index) then
			return
		end
	end
end

function List:map( op )
	local ret = List:new()
	self:__walk(function ( value )
		ret:insert(op(value))
	end)
	return ret
end

function List:flatMap( ... )
	-- body
end

function List:reduceLeft( op , initValue)
	if #self <= 1 then
		return self[1]
	else
		local curValue = initValue
		self:__walk(function ( value, index )
			if index == 1 and (not curValue) then
				curValue = value
			else
				curValue = op(curValue, value)
			end
		end)
		return curValue
	end
end

function List:reduceRight( op, initValue)

	if #self <= 1 then
		return self[1]
	else
		local curValue = initValue
		self:__walk_reverse(function ( value, index )
			if index == 1 and (not initValue) then
				curValue = value
			else
				curValue = op(value, curValue)
			end
		end)
		return curValue
	end

end

function List:range( min, max )
	local l = List:new()
	for i = min, max do
		l:insert(i)
	end
	return l
end

function List:test( ... )
	
	local l = List:new()
	l:insert(1)
	l:insert(2)
	l:insert(3)
	l:insert(4)
	l:insert(5)
	l:insert(6)
	l:insert(1)
	l:insert(2)
	l:insert(3)
	l:insert(4)
	l:insert(5)
	l:insert(6)


	print('l', l)

	print('range 1, 10', List:range(1, 10))

	print('l:find(2)', l:find(function ( value )
		return value-3 == 2
	end))
	print('l:filter', l:filter(function ( value )
		return value % 2 == 0
	end))
	print('l:partition', l:partition(function ( value )
		return value > 3
	end))
	print('l:takeWhile', l:takeWhile(function ( value )
		return value < 3
	end))
	print('l:dropWhile', l:dropWhile(function ( value )
		return value < 3
	end))
	print('sum 1 9', List:range(1, 9):reduceLeft(function ( a, b )
		return a + b
	end))
	print('sub 1 9', List:range(1, 9):reduceRight(function ( a, b )
		return a - b
	end))
	print('sub 1 10', List:range(1, 10):reduceRight(function ( a, b )
		return a - b
	end))

	print('sum 10: 1 9', List:range(1, 9):reduceLeft(function ( a, b )
		return a + b
	end, 10))
	print('sub 10: 1 9', List:range(1, 9):reduceRight(function ( a, b )
		return a - b
	end, 10))

end

function List:reload( ... )
	package.loaded['luaUtils'] = nil
	package.loaded['luaUtils.List'] = nil
	require 'luaUtils'
end
