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

--------------------------------------
-- BuildingID Translation for current char
--------------------------------------
GarrisonMaster.WolfLimit = 500
GarrisonMaster.secondsBetweenGarrisonBuildingCheck = 3600

GarrisonMaster.buildingID_translated = {
	[24] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Barn"] = 1 end,
	[25] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Barn"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Barn") end,
	[133] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Barn"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Barn") end,
	[29] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Garden"] = 1 end,
	[136] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Garden"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Garden") end,
	[137] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Garden"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Garden") end,
	[34] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Inn"] = 1 end,
	[35] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Inn"] = 2 end,
	[36] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Inn"] = 3 end,
	[61] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Mine"] = 1 end,
	[62] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Mine"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Mine") end,
	[63] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Mine"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Mine") end,
	[76]	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Alchemy"] = 1 end,
	[119] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Alchemy"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Alchemy") end,
	[120] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Alchemy"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Alchemy") end,
	[95] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Insription"] = 1 end,
	[129] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Insription"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Inscription") end,
	[130] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Insription"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Inscription") end,
	[94] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Tailoring"] = 1 end,
	[127] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Tailoring"] = 2 GarrisonMaster:CheckPlotIdForFollower(plotID, "Tailoring") end,
	[128] 	= function(plotID) GarrisonMasterDB[GarrisonMaster.character]["Building_Tailoring"] = 3 GarrisonMaster:CheckPlotIdForFollower(plotID, "Tailoring") end,
}

GarrisonMaster.ENUMPROF = {
	ALCHEMY = 1,
	INSCRIPTION =2,
	TAILORING=3,
	LOGGINGIN=4
}

GarrisonMaster.ENUMBUILDING = {
	MINE = 101,
	GARDEN = 102,
	BARN = 103,
	CACHE = 104,
	WO_BARN = 203,
	WO_INSCRIPTION = 204,
	WO_ALCHEMY = 205,
	WO_TAILORING = 206,
	WO_MINE = 207,
	WO_GARDEN = 208
}

GarrisonMaster.debugMode = false
GarrisonMaster.player = ""
GarrisonMaster.realm = ""
GarrisonMaster.character = ""

function GarrisonMaster:CheckPlotIdForFollower(plotID, name)
	local followerName, level, quality, followerID, garrFollowerID, status, portraitIconID = C_Garrison.GetFollowerInfoForBuilding(plotID)
	if (followerName ~= nil) then 
		GarrisonMaster:debug(name .. " has Follower with name: " .. followerName)
	else
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextFollower(name));
		GarrisonMaster:debug(name .. " is of at least lv 2 and no follower !")
	end
end


function GarrisonMaster:DebugDB()
	GarrisonMaster:debug("Outputting GarrisonMasterDB")
	TableUtils:Output(GarrisonMasterDB)
end

function GarrisonMaster:msgTextFollower(buildingname) 
	return self.character .. ": " .. buildingname .. " building is of at least lv 2 and has no follower!"
end

function GarrisonMaster:msgText(profession, char)
	if (profession == GarrisonMaster.ENUMPROF.ALCHEMY) then
		return char .. ": Craft \124cff1eff00\124Hitem:108996::::::::120:::::\124h[Alchemical Catalyst]\124h\124r"
	end
	if (profession == GarrisonMaster.ENUMPROF.TAILORING) then
		return char .. ". Craft \124cff1eff00\124Hitem:111556::::::::120:::::\124h[Hexweave Cloth]\124h\124r"
	end
	if (profession == GarrisonMaster.ENUMPROF.INSCRIPTION) then
		return char .. ": Craft \124cff1eff00\124Hitem:112377::::::::120:::::\124h[War Paints]\124h\124r"
	end
	if (profession == GarrisonMaster.ENUMBUILDING.MINE) then 
		return char .. ": Mine ore."
	end
	if (profession == GarrisonMaster.ENUMBUILDING.GARDEN) then 
		return char .. ": Herbalism in your garden."
	end
	if (profession == GarrisonMaster.ENUMBUILDING.BARN) then
		return char .. ": Farm  " .. GarrisonMaster.WolfLimit .. 
			" \124cffffffff\124Hitem:119815::::::::120:::::\124h[Caged Mighty Wolf]\124h\124r"
	end
	if (profession == GarrisonMaster.ENUMPROF.LOGGINGIN) then
		return "Loggin in on " .. char
	end
	if (profession == GarrisonMaster.ENUMBUILDING.CACHE) then
		return "Loot Garrison Chache on " .. char
	end
end

--- Used for he Work order messages, save the duration so we can later delete the corresponding msg
function GarrisonMaster:msgTextWithDuration(building, duration)
	duration = duration or 0
	if (building == GarrisonMaster.ENUMBUILDING.WO_GARDEN) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Garden (" .. GarrisonMasterDB[self.character]["WO_Garden"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Garden"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Garden"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Garden (" .. duration .. " hours remaining)."
		end	
	elseif (building == GarrisonMaster.ENUMBUILDING.WO_MINE) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Mine (" .. GarrisonMasterDB[self.character]["WO_Mine"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Mine"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Mine"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Mine (" .. duration .. " hours remaining)."
		end	
	elseif (building == GarrisonMaster.ENUMBUILDING.WO_BARN) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Barn (" .. GarrisonMasterDB[self.character]["WO_Barn"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Barn"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Barn"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Barn (" .. duration .. " hours remaining)."
		end	
	elseif (building == GarrisonMaster.ENUMBUILDING.WO_ALCHEMY) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Alchemy Lab (" .. GarrisonMasterDB[self.character]["WO_Alchemy"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Alchemy"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Alchemy"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Alchemy Lab (" .. duration .. " hours remaining)."
		end	
	elseif (building == GarrisonMaster.ENUMBUILDING.WO_INSCRIPTION) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Scribe's Quarter (" .. GarrisonMasterDB[self.character]["WO_Inscrption"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Inscrption"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Inscrption"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Scribe's Quarter (" .. duration .. " hours remaining)."
		end
	elseif (building == GarrisonMaster.ENUMBUILDING.WO_TAILORING) then
		if (duration < 0) then
			local tmp = GarrisonMaster.character .. ": Restock workorders in Tailoring Emporium (" .. GarrisonMasterDB[self.character]["WO_Tailoring"] .. " hours remaining)."
			GarrisonMasterDB[self.character]["WO_Tailoring"] = -1
			return tmp
		else
			GarrisonMasterDB[self.character]["WO_Tailoring"] = duration
			return GarrisonMaster.character .. ": Restock workorders in Tailoring Emporium (" .. duration .. " hours remaining)."
		end
	end
end

function GarrisonMaster:initDailyTasks() 
	prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	name1 = GetProfessionInfo(prof1);
	name2 = GetProfessionInfo(prof2);

	if (name1 == "Tailoring" or name2 == "Tailoring") then
		GarrisonMasterDB[self.character]["TS_Tailioring"] = 0
	else
		GarrisonMasterDB[self.character]["TS_Tailioring"] = -1
	end
	if (name1 == "Inscription" or name2 == "Inscription") then
		GarrisonMasterDB[self.character]["TS_Inscription"] = 0
	else
		GarrisonMasterDB[self.character]["TS_Inscription"] = -1
	end 
	if (name1 == "Alchemy" or name2 == "Alchemy") then
		GarrisonMasterDB[self.character]["TS_Alchemy"] = 0
	else
		GarrisonMasterDB[self.character]["TS_Alchemy"] = -1
	end 


	if (GarrisonMasterDB[self.character]["Newly"]) then
		GarrisonMasterDB[self.character]["Newly"] = false
		GarrisonMaster:AddDailyTaskPerCharacter(self.character, GarrisonMasterDB[self.character])
	end
end

--- Creates the table for the new character with all the needed fields
function GarrisonMaster:InitNewChar()
	GarrisonMasterDB[self.character] = {}
	GarrisonMasterDB[self.character].Name = "player name"
	GarrisonMasterDB[self.character]["TS_Alchemy"] = -1
	GarrisonMasterDB[self.character]["TS_Inscription"] = -1 
	GarrisonMasterDB[self.character]["TS_Tailioring"] = -1
	GarrisonMasterDB[self.character]["Barn"] = -1
	GarrisonMasterDB[self.character]["Mine"] = -1
	GarrisonMasterDB[self.character]["Garden"] = -1
	GarrisonMasterDB[self.character]["Inn"] = -1
	GarrisonMasterDB[self.character]["Building_Alchemy"] = -1
	GarrisonMasterDB[self.character]["Building_Tailoring"] = -1
	GarrisonMasterDB[self.character]["Building_Insription"] = -1
	GarrisonMasterDB[self.character]["Newly"] = true
	GarrisonMasterDB[self.character]["currentTime"] = 0
	GarrisonMasterDB[self.character]["loggedIn"] = true
	GarrisonMasterDB[self.character]["WolfCount"] = GetItemCount(119815, true, true)
	GarrisonMasterDB[self.character]["lootedCache"] = 0
	GarrisonMasterDB[self.character]["Level"] = UnitLevel("player")
	-- get current ressources
	GarrisonMasterDB[self.character]["Ressources"] = C_CurrencyInfo.GetCurrencyInfo(824)["quantity"]

	GarrisonMasterDB[self.character]["CacheSize"] = (C_QuestLog.IsQuestFlaggedCompleted( 37485 ) and 1000 ) or ((C_QuestLog.IsQuestFlaggedCompleted(38445) or C_QuestLog.IsQuestFlaggedCompleted(37935)) and 750) or ((C_QuestLog.IsQuestFlaggedCompleted(35176) or C_QuestLog.IsQuestFlaggedCompleted(34824)) and 500) or 0; -- Faction quests completed for Garrison Cache?
	
	GarrisonMaster:output("Detected a new character, please open one of your professions, thank you.")
end

function GarrisonMaster:debug(output)
	if (GarrisonMaster.debugMode == false) then
		return
	end
	if (type(output) == "table") then
		TableUtils.Output(output)
		return
	end
	if (output == nil) then
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
	GarrisonMaster:AddCachePerCharacter(key, v)
	if (v["TS_Alchemy"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.ALCHEMY, key));
	end
	if (v["TS_Inscription"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.INSCRIPTION, key));
	end
	if (v["TS_Tailioring"] >= 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.TAILORING, key));
	end
	if (v["Mine"] > 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.MINE, key));
	end
	if (v["Garden"] > 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.GARDEN, key));
	end
	if (v["Barn"] > 0) then
		local count = GarrisonMasterDB[key]["WolfCount"] -- Get current wolf count for this character we are iterating
		if (count < GarrisonMaster.WolfLimit) then
			TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.BARN, key));
		end
	end
	if (v["Building_Tailoring"] > 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.TAILORING, key));
	end
	if (v["Building_Insription"] > 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.INSCRIPTION, key));
	end
	if (v["Building_Alchemy"] > 0) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.ALCHEMY, key));
	end
	if (key ~= self.character) then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.LOGGINGIN, key));
	end
end

function GarrisonMaster:AddCachePerCharacter(key, v)
	if (v["CacheSize"] > 0) then
		local gCache = math.floor((time() - v["lootedCache"]) / 600 ); -- Seconds past since looted divided by 600 seconds (1 GR is created every 10 min)
		local gCacheNotFilled = v["CacheSize"] - gCache;
		local gCacheTimeTillFull = gCacheNotFilled * 600

		if (gCacheTimeTillFull < 60 * 60 * 24) then
			TodoChecklisterFrame:AddItem(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.CACHE, key));
		end 
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
	local mapID = C_Map.GetBestMapForUnit("player"); 
	if(event == "TRADE_SKILL_SHOW") then
        GarrisonMaster:initDailyTasks()
        return
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create Hexweave Cloth.") then
        TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.TAILORING, self.character));
        return
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create War Paints.") then
        TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.INSCRIPTION, self.character));
        return
    end
    if(event == "CHAT_MSG_TRADESKILLS" and name == "You create Alchemical Catalyst.") then
        TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.ALCHEMY, self.character));
        return
    end

    if(event == "CHAT_MSG_LOOT") then
    	local itemString = strsub(string.match(name, "item:[%-?%d:]+"), 0,  12)
    	if itemString == "item:119815" then	
	    	GarrisonMasterDB[self.character]["WolfCount"] = GetItemCount(119815, true, true) -- Get current wolf count

			if (GarrisonMasterDB[self.character]["WolfCount"] >= GarrisonMaster.WolfLimit) then
	        	TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.BARN, self.character));
	        end
	    end
        return
    end
end

function GarrisonMaster:eventManagerSpellCast(event, unitTarget, castGUID, spellID)
	local mapID = C_Map.GetBestMapForUnit("player"); 
	--print(format("You are in %s (%d)", C_Map.GetMapInfo(mapID).name, mapID))
	--- the player must do it himself

	--- TODO: Add Horde mapIDs 	
	if (unitTarget ~= "player" or mapID < 581 or mapID > 582) then
		return
	end
	if (spellID == 170599) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.MINE, self.character));
		return
	end
	if (spellID == 170691) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.GARDEN, self.character));
		return
	end
	if (spellID == 170693 or spellID == 178655) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_GARDEN, -1));
		return
	end
	if (spellID == 178656 or spellID == 170696) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_MINE, -1));
		return
	end
	if (spellID == 172853) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_ALCHEMY, -1));
		return
	end
	if (spellID == 172856) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_INSCRIPTION, -1));
		return
	end
	if (spellID == 172859) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_TAILORING, -1));
		return
	end
	if (spellID == 177831) then
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_BARN, -1));
		return
	end
end

function GarrisonMaster:ResetDB()
	GarrisonMaster:debug("resetting database")
	GarrisonMasterDB = {}
	GarrisonMaster:Init()
end

function GarrisonMaster:CheckGarrisonBuildings()
	--- only update if the last update is older than an hour
	-- Get CacheSize and calculate time till full

	local currentTime = time()
	if (currentTime - GarrisonMasterDB[self.character]["currentTime"]) > GarrisonMaster.secondsBetweenGarrisonBuildingCheck  then
		GarrisonMasterDB[self.character]["currentTime"] = currentTime

		-- update garrison cache size
		GarrisonMasterDB[self.character]["CacheSize"] = (C_QuestLog.IsQuestFlaggedCompleted(37485) and 1000 ) or ((C_QuestLog.IsQuestFlaggedCompleted(38445) or C_QuestLog.IsQuestFlaggedCompleted(37935)) and 750) or ((C_QuestLog.IsQuestFlaggedCompleted(35176) or C_QuestLog.IsQuestFlaggedCompleted(34824)) and 500) or 0;
		-- Check for cache task
		-- GarrisonMaster:AddCachePerCharacter(self.character, GarrisonMasterDB[self.character])

		GarrisonMaster.debug("Checking Garrison")
		result = C_Garrison.GetBuildings(Enum.GarrisonType.Type_6_0)
		for k, v in pairs(result) do
			GarrisonMaster:SetBuildingByID(v["buildingID"], v["plotID"])
		end
	else
		GarrisonMaster.debug("Skipping Garrison Building Check, as it is still fresh")
	end
	GarrisonMaster:NextBuildingToBuild(self.character)
	TodoChecklisterFrame:MoveToFront(self.character)
end

function GarrisonMaster:CurrencyUpdated(currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource)
	if (quantityGainSource == nil) then
		return
	end
	if (currencyType == 824 and quantityGainSource == 28) then
		GarrisonMasterDB[self.character]["lootedCache"] = time()
		TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMBUILDING.CACHE, self.character));
	end
	if (currencyType == 824) then
		GarrisonMasterDB[self.character]["Ressources"] = quantity
	end
end

function GarrisonMaster:Init()
	self.player = UnitName("player")
	self.realm = GetRealmName()
	self.character = self.realm .. "-" .. self.player

	TodoChecklisterFrame:RemoveItemByText(GarrisonMaster:msgText(GarrisonMaster.ENUMPROF.LOGGINGIN, self.character));

	--- Is this a new character?
	if (GarrisonMasterDB[self.character] == nil) then
		GarrisonMaster:InitNewChar()	
	end

	-- Get CacheSize and calculate time till full
	---GarrisonMasterDB[self.character]["CacheSize"] = (C_QuestLog.IsQuestFlaggedCompleted(37485) and 1000 ) or ((C_QuestLog.IsQuestFlaggedCompleted(38445) or C_QuestLog.IsQuestFlaggedCompleted(37935)) and 750) or ((C_QuestLog.IsQuestFlaggedCompleted(35176) or C_QuestLog.IsQuestFlaggedCompleted(34824)) and 500) or 0;
	GarrisonMasterDB[self.character]["Ressources"] = C_CurrencyInfo.GetCurrencyInfo(824)["quantity"]
	GarrisonMasterDB[self.character]["Level"] = UnitLevel("player")
	GarrisonMasterDB[self.character]["WolfCount"] = GetItemCount(119815, true, true) -- Get current wolf count
	GarrisonMaster.debug("Wolfcount set to " .. GarrisonMasterDB[self.character]["WolfCount"])
	
	-- get all followers and debug output them
	--- Enum.GarrisonFollowerType.FollowerType_6_0
	--- local followers = C_Garrison.GetFollowers(Enum.GarrisonFollowerType.FollowerType_6_0)
	--- print("followers")
	--- TableUtils:Output(followers)
	--- print(followers)

	--- GarrisonMaster:CheckGarrisonBuildings() -- instead based in init.lua on GARRISON_LANDINGPAGE_SHIPMENTS
	GarrisonMaster:CheckDailyReset()

	--- sort the list
	TodoChecklisterFrame:MoveToFront(self.character)
end

--- Taken from CompleteWorkOrders
function GarrisonMaster:StrTimeToSeconds(str)
	if not str then return 0; end
	local t1, i1, t2, i2 = strsplit( " ", str ); -- x day   -   x day x hr   -   x hr y min   -   x hr   -   x min   -   x sec
	local M = function( i )
		if i == "hr" then
			return 3600;
		elseif i == "min" then
			return 60;
		elseif i == "sec" then
			return 1;
		else
			return 86400; -- day
		end
	end
	return t1 * M( i1 ) + ( t2 and t2 * M( i2 ) or 0 );
end

--- The table only has the buildings we are interested in
function GarrisonMaster:SetBuildingByID(id, plotID)
	landingPage = {C_Garrison.GetLandingPageShipmentInfo(id)}
	-- TableUtils:Output(landingPage)
	
	local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemIcon, itemQuality, itemID  = C_Garrison.GetLandingPageShipmentInfo(id)
	if (duration == nil and name ~= nil) then
		GarrisonMaster:AddUpdateByBuildingName(name, 0);
	elseif (duration ~= nil) then
		local secondsTillFull = GarrisonMaster:StrTimeToSeconds(timeleftString) + (shipmentsTotal - shipmentsReady - 1) * duration;
		local hoursTillFull = secondsTillFull / (60 * 60);
		if (hoursTillFull < 24) then
			GarrisonMaster:AddUpdateByBuildingName(name, hoursTillFull);
		end
	end

	
	if (GarrisonMaster.buildingID_translated[id] ~= nil) then
		GarrisonMaster.buildingID_translated[id](plotID)
	end
end	

--- Function to add the different Tasks for the buildings
function GarrisonMaster:AddUpdateByBuildingName(name, hoursTillFull)
	if (name == "Herb Garden") then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_GARDEN, hoursTillFull));
	elseif (name == "Lunarfall Excavation") then --- TODO: Add Horde name
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_MINE, hoursTillFull));
	elseif (name == "Tailoring Emporium") then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_TAILORING, hoursTillFull));
	elseif (name == "Scribe's Quarters") then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_INSCRIPTION, hoursTillFull));
	elseif (name == "Alchemy Lab") then
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_ALCHEMY, hoursTillFull));
	elseif (name == "Barn") then 
		TodoChecklisterFrame:AddItem(GarrisonMaster:msgTextWithDuration(GarrisonMaster.ENUMBUILDING.WO_BARN, hoursTillFull));
	end
end

function GarrisonMaster:NextBuildingToBuild(charToCheck)
	local result = C_Garrison.GetGarrisonInfo(Enum.GarrisonType.Type_6_0)
	-- TableUtils:Output(result)
	local status = GarrisonMasterDB[charToCheck]
	-- TableUtils:Output(status)
	--- first build garrison lv 2

	-- calculate probably ressources including cache
	local ressourcesAvailable = status["Ressources"] + min((time() - status["lootedCache"]) / 600, status["CacheSize"])
	GarrisonMaster:debug("Calculated avaiable ressources: " .. ressourcesAvailable)

	if (result < 2) then
		if (ressourcesAvailable > 200) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Garrison Level 2.")
		end
	elseif (status["Mine"] < 1) then
		if (ressourcesAvailable > 0) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Mine Level 1.")
		end
	elseif (status["Garden"] < 1) then
		if (ressourcesAvailable > 100) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Garden Level 1.")
		end
	elseif (status["Building_Alchemy"] < 1) then
		if (ressourcesAvailable > 50) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Alchemy Lab Level 1.")
		end
	elseif (status["Building_Insription"] < 1) then
		if (ressourcesAvailable > 50) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Scribe's Quarter Level 1.")
		end
	elseif (status["Building_Alchemy"] < 2) then
		if (ressourcesAvailable > 150) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Alchemy Lab Level 2.")
		end
	elseif (status["Building_Insription"] < 2) then
		if (ressourcesAvailable > 150) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Scribe's Quarter Level 2.")
		end
	elseif (status["Mine"] < 2) then
		if (ressourcesAvailable > 150) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Mine Level 2.")
		end
	elseif (status["Garden"] < 2) then
		if (ressourcesAvailable > 150) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Garden Level 2.")
		end
	elseif (result < 3) then
		if (ressourcesAvailable > 2000) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Garrison Level 3.")
		end
	elseif (status["Mine"] < 3) then
		if (ressourcesAvailable > 100) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Mine Level 3.")
		end
	elseif (status["Barn"] < 1) then
		if (ressourcesAvailable > 100) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Barn Level 1.")
		end
	elseif (status["Barn"] < 2) then
		if (ressourcesAvailable > 300) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Barn Level 2.")
		end
	elseif (status["Barn"] < 3) then
		if (ressourcesAvailable > 600) then
			TodoChecklisterFrame:AddItem(self.character .. ": Build Barn Level 3.")
		end
	end
	GarrisonMaster:debug("Nothing new to build.")
end