---@diagnostic disable-next-line: undefined-global
local wdir = workingdir
local json = require("json")
local strings = require("strings")

local function scandir(directory)
	local i, t, popen = 0, {}, io.popen

	local pfile = popen('ls -a "' .. directory .. '"')
	if pfile then
		for filename in pfile:lines() do
			i = i + 1
			t[i] = filename
		end
		pfile:close()
	end
	return t
end

local function list_def(name, link)
	if name == "index" then
		name = ".."
	end
	return "- [" .. name .. "](" .. link .. ")\n"
end

function Writer(filedata)
	local source_data = json.decode(filedata)
	local pages_path = "./pages"

	local files = scandir(pages_path)
	local navigation = ""
	for fileIndex = 3, #files do
		if
			not (
				files[fileIndex] == "undone.md"
				or files[fileIndex] == "_head.html"
				or files[fileIndex] == "_tail.html"
			)
		then
			local name = strings.trim(files[fileIndex], ".md")
			local link = name .. ".html"
			if not (name == "index") then
				navigation = navigation .. "\t" .. list_def(name, link)
			end
		end
	end

	navigation = list_def("..", "index.html") .. navigation

	if source_data.name == "index.html" then
		source_data.content = navigation
	else
		source_data.content = source_data.content .. "\n\n---\n\n _backlinks_\n\n"
		source_data.content = source_data.content .. navigation
	end

	return json.encode(source_data)
end
