Script = {}

function Script.save_config() 
    local serialized = "return { Enabled = {}}"
    love.filesystem.write("config/Script.lua", serialized)
end

function Script.load_config() 
    if love.filesystem.exists("config/Script.lua") then
    local str = ""
    for line in love.filesystem.lines("config/Script.lua") do
        str = str..line
    end
        return loadstring(str)()
    else    
        return {
            only_stack_negatives = true,
            fix_slots = true
        }
    end
end
if not Script.config then Script.config = Script.load_config() end

local lovely = require("lovely")
local nativefs = require("nativefs")

local info = nativefs.getDirectoryItemsInfo(lovely.mod_dir)
for i, v in pairs(info) do
  if v.type == "directory" and nativefs.getInfo(lovely.mod_dir .. "/" .. v.name .. "/script.lua") then Script.path = lovely.mod_dir .. "/" .. v.name end
end

if not nativefs.getInfo(Script.path) then
    error(
        'Could not find proper Script folder.\nPlease make sure that Script is installed correctly and the folders arent nested.')
end


function Script.eval_file(path)
    local text = ""
    for line in nativefs.lines(path) do
        text = text..line.." "
    end
    loadstring(text)()
end

Script.files = {}
local finfo = nativefs.getDirectoryItemsInfo(Script.path.."/scripts")
for i, v in pairs(finfo) do
    if v.type == "file" then
        Script.files[#Script.files+1]=v.name
    end
end
local gsr = Game.start_run
function Game:start_run(args)
	gsr(self, args)
    if not args.savetable then
        for i, v in pairs(Script.files) do
            Script.eval_file(Script.path.."/scripts/"..v)
        end
    end
end