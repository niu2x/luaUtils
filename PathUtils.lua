PathUtils = {}

function PathUtils:join(...)
	local params = {...}
	if #params <= 1 then
		return params[1]
	elseif #params == 2 then
		local path_1 = params[1]
		local path_2 = params[2]
		if string.endWith(params[1], '/') then
			path_1 = string.sub(params[1], 1, -2)
		end
		if string.startWith(params[2], '/') then
			path_2 = string.sub(params[2], 2, -1)
		end
		return path_1 .. '/' .. path_2
	else
		local two = {table.remove(params), table.remove(params)}
		local ret = self:join(two)
		return self:join(ret, table.unpack(params))
	end
end

function PathUtils:getDirName(pathname)
	return io.pathinfo(pathname).dirname
end

function PathUtils:getFileName(pathname)
	return io.pathinfo(pathname).filename
end

function PathUtils:getBaseName(pathname)
	return io.pathinfo(pathname).basename
end

function PathUtils:getExtName(pathname)
	return io.pathinfo(pathname).extname
end

function PathUtils:split( pathname )
	return self:getDirName(pathname), self:getFileName(pathname)
end

function PathUtils:splitExt( pathname )
	return self:getBaseName(pathname), self:getExtName(pathname)
end