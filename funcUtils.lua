FuncUtils = {}

function FuncUtils:memorize( func )
	local cache = {}
	return function ( ... )
		local params = {...}
		local paramsNum = #params
		if paramsNum <= 0 then
			return func()
		else
			local result = cache
			for index = 1, paramsNum - 1 do
				local param = params[index]
				if result[param] == nil then
					result[param] = {}
				end
				result = result[param]
			end
			local lastParam = params[paramsNum]
			if result[lastParam] == nil then
				result[lastParam] = func(...)
			end
			return result[lastParam] 
		end
	end
end

