-- "extension.lua"
-- VLC Extension basic structure (template): ----------------

local API_KEY = "546fab4a9d1c1e351c671612a4a74c59"
-- local API_SERVER = "0.0.0.0:3000"
local API_SERVER = "www.showito.com"

function descriptor()
   return {
      title = "Scrobble current episode",
      version = "1.0",
      author = "tost",
      url = 'http://www.showito.com',
      shortdesc = "short description",
      description = "full description",
      capabilities = {"menu", "input-listener", "meta-listener"}
   }
end

function activate()
  local filename = get_current_filename()
  if filename ~= nil then
    scrobble(filename)
  end

  deactivate()
end

function deactivate()
  vlc.deactivate()
end

--
-- Get the current playing item
--
function get_current_filename()
  vlc.msg.warn("Getting Current Filename...")
  local item               = vlc.input.item()

  if item == nil then return nil end

  local item_name_or_title = item:name()

  --
  -- Name is nil...
  --
  if item_name_or_title == nil then
    vlc.msg.warn("item.name() name was nil, checking metas...")
    --
    -- Try asking for the meta data
    --
    local item_metas = item:metas()
    --
    -- We'll take the title, if it exists
    --
    if item_metas then
      vlc.msg.warn("present.. using that")
      item_name_or_title = item_metas
    end  
  end
  --
  -- Either the name or title..
  --
  vlc.msg.warn("Current item name is: " .. item_name_or_title)
  return item_name_or_title
end

function scrobble(filename)
  local resp = post("http://" .. API_SERVER .. "/api/scrobbles/fix/new?access_token=" .. API_KEY .. "&filename=" .. filename)
  vlc.msg.warn(resp)
end

function post(url)
  local s = vlc.stream(url)
  s:readline()

  return ""
end
