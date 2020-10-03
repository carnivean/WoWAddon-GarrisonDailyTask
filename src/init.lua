--------------------------------------
-- Imports
--------------------------------------
---@class TodoAddon
local TodoAddon = select(2, ...)

---@type string
local addonName = select(1, ...)

---@class Debug
local Debug = TodoAddon.Debug
---@class Settings
local Settings = TodoAddon.Settings
---@class TodoList
local TodoList = TodoAddon.TodoList
---@class InterfaceOptions
local InterfaceOptions = TodoAddon.InterfaceOptions
---@class TodoChecklisterFrame
local TodoChecklisterFrame = TodoAddon.TodoChecklisterFrame
---@class Chat
local Chat = TodoAddon.Chat
---@class MinimapIcon
local MinimapIcon = TodoAddon.MinimapIcon
---@class GarrisonMaster
local GarrisonMaster = TodoAddon.GarrisonMaster

--------------------------------------
-- Init keybindings
--------------------------------------
BINDING_HEADER_TC_HEADER = addonName
BINDING_NAME_TC_TOGGLE_FRAME = "Toggle window"

-- Export the method TodoChecklisterFrame:Toggle to a global function
-- so that it can be called from a keybind
GLOBAL_TodoChecklisterFrameToggle = function()
    TodoChecklisterFrame:Toggle()
end

TodoAddon.flag = false;
TodoAddon.character = "";
--------------------------------------
-- Initialization
--------------------------------------
local main = CreateFrame("Frame", addonName .. "MAINFRAME", UIParent)
TodoAddon.main = main

function TodoAddon:Init(event, name)
    if(event == "TRADE_SKILL_SHOW" or event == "CHAT_MSG_TRADESKILLS") then
        GarrisonMaster:eventManager(event, name);
        return
    end

    if (name ~= addonName) then
        return
    end

    -- Config
    Debug:Init()
    Settings:Init()

    -- Model
    TodoList:Init()

    -- Components
    InterfaceOptions:Init()
    TodoChecklisterFrame:Init()

    -- Modules
    Chat:Init()
    MinimapIcon:Init()
    GarrisonMaster:Init()

    -------------------------------------------
    Chat:Print(TodoList:GetMOTD())
end


main:RegisterEvent("ADDON_LOADED")
main:SetScript("OnEvent", TodoAddon.Init)
main:RegisterEvent("TRADE_SKILL_SHOW");
main:RegisterEvent("CHAT_MSG_TRADESKILLS");