-- Quest stage actions
KILL = 0
TALK = 1
GET = 2

-- QUEST MANAGER
QuestManager = {}
QuestManager.__index = QuestManager
	
function QuestManager.new()
	local instance = {}
	instance.quests = {}
	
	setmetatable(instance, QuestManager)

	return instance
end

-- Checks whether the action that was performed updated any quests.
function QuestManager:check(action,target,extraInfo)
	for i=1,#self.quests do
		if(self.quests[i]~= nil) then
		printAPI.print("Checking quest "..i .. "\n")

			for a=1,#self.quests[i].stages do
				thisStage = self.quests[i].stages[a]
				debugLPrint(action .. " " .. target.stringID .. " " .. extraInfo .. "\n")
				
				if(action==thisStage.action and target.stringID == thisStage.targetName and extraInfo == thisStage.extraInfo) then
					if(thisStage.isComplete == false) then
						self.quests[i].stages[a].isComplete = true
						printAPI.print("You completed quest stage: " .. thisStage.name .. "\n")
						
						if(self.quests[i]:isComplete()) then
							printAPI.print("You completed quest: " .. self.quests[i].name .. "\n")
						end
					end
				end
			end
		else
		printAPI.print(i-1 .. " " .. self.quests[i-1].name)
		printAPI.print(" Was last quest. Next, ".. i.. "was Nil quest tried to access\n")
		end
	end
end

-- Expects Quest as param
function QuestManager:addQuest(newQuest)
	self.quests[#self.quests +1] = newQuest
	
	
	
end

-- QUEST
Quest = {}
Quest.__index = Quest

-- Expects table of QuestStage as param
function Quest.new(name,questStages, iEndStage)
	local instance = {}
	instance.name = name -- Name of quest, assume visible to player.
	instance.endStage = iEndStage
	instance.stages = questStages

	setmetatable(instance, Quest)

	return instance
end

function Quest:isComplete()
	for i=1,#self.stages-1 do
		debugLPrint("Checking Quests ... ")

		if(self.stages[i].isComplete == false) then
				debugLPrint("a stage is incomplete\n")
			return false
		end
	end
	return true
end



-- QUEST STAGE
QuestStage = {}
QuestStage.__index = QuestStage
	
function QuestStage.new(name, myAction, myTargetName, myExtraInfo)
	local instance = {}
	instance.name = name -- Name of quest stage, assume visible to player.
	instance.action = myAction
	instance.target = myTarget
	instance.targetName = myTargetName
	instance.extraInfo = myExtraInfo
	instance.isComplete = false

	setmetatable(instance, QuestStage)

	return instance
end

function QuestManagerTest()
	local questStages = {}

	--questStages[1] = new QuestStage(KILL,Enemy01,nil)
	questStages[1] = QuestStage.new(TALK,NPC01,"BobQuest1")
	--questStages[3] = new QuestStage(GET,Item01,nil)

	local quest = Quest:new(questStages,1)

end

