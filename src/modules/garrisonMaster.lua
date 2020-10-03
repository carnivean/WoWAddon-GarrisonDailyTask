--------------------------------------
-- Imports
--------------------------------------
---@class TodoAddon
local TodoAddon = select(2, ...)

---@class Settings
local Settings = TodoAddon.Settings
---@class TodoList
local TodoList = TodoAddon.TodoList
---@class TableUtils
local TableUtils = TodoAddon.TableUtils
---@class TodoChecklisterFrame
local TodoChecklisterFrame = TodoAddon.TodoChecklisterFrame
---@class Utils
local Utils = TodoAddon.Utils
--------------------------------------
-- Declarations
--------------------------------------
TodoAddon.GarrisonMaster = {}

---@class Chat
local GarrisonMaster = TodoAddon.GarrisonMaster

GarrisonMaster.ENUMPROF = {
	ALCHEMY = 1,
	INSCRIPTION =2,
	TAILORING=3
}

GarrisonMaster.debug = true
GarrisonMaster.player = ""
GarrisonMaster.realm = ""
GarrisonMaster.character = ""

function GarrisonMaster:DebugDB()
	GarrisonMaster:debug("Outputting GarrisonMasterDB")
	TableUtils:Output(GarrisonMasterDB)
end

function GarrisonMaster:msgText(profession)
	if (profession == GarrisonMaster.ENUMPROF.ALCHEMY) then
		return GarrisonMaster.character .. ": Craft Alchemic Catalyst"
	end
	if (profession == GarrisonMaster.ENUMPROF.TAILORING) then
		return GarrisonMaster.character .. ". Craft Hexweave Cloth"
	end
	if (profession == GarrisonMaster.ENUMPROF.INSCRIPTION) then
		return GarrisonMaster.character .. ": Craft Warpaint"
	end
end

function GarrisonMaster:initDailyTasks() 
	prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	name1 = GetProfessionInfo(prof1);
	name2 = GetProfessionInfo(prof2);
	printDBG(name1);
	printDBG(name2);
	if (name1 == "Tailoring" or name2 == "Tailoring") then
		GarrisonMasterDB[self.character]["Tailioring"] = 0
	end
	if (name1 == "Inscription" or name2 == "Inscription") then
		GarrisonMasterDB[self.character]["Inscription"] = 0
	end 
	if (name1 == "Alchemy" or name2 == "Alchemy") then
		GarrisonMasterDB[self.character]["Alchemy"] = 0
	end 

	if (GarrisonMasterDB[self.character]["Newly"]) then
		GarrisonMasterDB[self.character]["Newly"] = false
		GarrisonMaster:AddDailyTaskPerCharacter(self.character, GarrisonMasterDB[self.character])
	end
end

function GarrisonMaster:InitNewChar()
	GarrisonMasterDB[self.character] = {}
	GarrisonMasterDB[self.character].Name = "player name"
	GarrisonMasterDB[self.character]["Alchemy"] = -1
	GarrisonMasterDB[self.character]["Inscription"] = -1 
	GarrisonMasterDB[self.character]["Tailioring"] = -1
	GarrisonMasterDB[self.character]["Newly"] = true
	GarrisonMaster:output("Detected a new character, please open one of your professions, thank you.")
end

function GarrisonMaster:debug(output)
	if (GarrisonMaster.debug == false) then
		return
	end
    local prefix = string.format("|cff%s%s|r", "00CCFF", "Garrison Master: ");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, output));
end

function GarrisonMaster:output(output)
    local prefix = string.format("|cff%s%s|r", "00CCFF", "Garrison Master: ");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, output));
end

function GarrisonMaster:AddDailyTaskPerCharacter(key, v)
	GarrisonMaster:debug("Adding alerts for " .. key)
	if (v["Alchemy"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.ALCHEMY));
	end
	if (v["Inscription"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.INSCRIPTION));
	end
	if (v["Tailioring"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.TAILORING));
	end
end

function GarrisonMaster:AddDailyTasks()
	GarrisonMaster:debug("Adding daily tasks !")
	for k, v in pairs(GarrisonMasterDB) do
		if (k == "lastChecked1") then
			GarrisonMaster:debug("skipping date")
		else
			GarrisonMaster:AddDailyTaskPerCharacter(k, v)
		end
	end
end

function GarrisonMaster:CheckDailyReset()
	currentDate = date("*t")
	--- does the information exist? checke with a number as that cant happen on characters
	if (GarrisonMasterDB["lastChecked1"] == nil) then
		GarrisonMasterDB["lastChecked1"] = currentDate
		return
	end

	-- check whether we have a daily reset
	if (Utils:OldDate(GarrisonMasterDB["lastChecked1"], currentDate)) then
		GarrisonMaster:AddDailyTasks()
		GarrisonMasterDB["lastChecked1"] = currentDate
	end
end

function GarrisonMaster:eventManager(event, name)
	if (name == nil) then
		GarrisonMaster:debug(event)
	else
		GarrisonMaster:debug(event .. " - " .. name)
	end
	
	if(event == "TRADE_SKILL_SHOW") then
        GarrisonMaster:initDailyTasks()
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create Hexweave Cloth.") then
        TodoList:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.TAILORING));
        return
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create War Paints.") then
        TodoList:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.INSCRIPTION));
        return
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create Alchemical Catalyst.") then
        TodoList:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.ALCHEMY));
        return
    end
end

function GarrisonMaster:ResetDB()
	GarrisonMaster:debug("resetting database")
	GarrisonMasterDB = {}
	GarrisonMaster:Init()
end

function GarrisonMaster:Init()
	self.player = UnitName("player")
	self.realm = GetRealmName()
	self.character = self.realm .. "-" .. self.player

	GarrisonMaster:debug("init char" .. self.character)
	print(GarrisonMasterDB[self.character])

	--- Is this a new character?
	if (GarrisonMasterDB[self.character] == nil) then
		GarrisonMaster:InitNewChar()	
	end
	
	GarrisonMaster:CheckDailyReset()
end
