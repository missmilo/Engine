local Vector3 = require 'LuaScripts/Vector3'
local gameObject = require 'LuaScripts/gameObject'
local AABoundingBox = require 'LuaScripts/AABoundingBox'
local npc = require 'LuaScripts/npc'
require 'LuaScripts/FileIO'

gameObjects = {}

--SDL ScanCode list: https://wiki.libsdl.org/SDLScancodeLookup

SDL_SCANCODE_W = 26
SDL_SCANCODE_A = 4
SDL_SCANCODE_P = 19
SDL_SCANCODE_S = 22
SDL_SCANCODE_D = 7
SDL_SCANCODE_ESCAPE = 41
SDL_SCANCODE_Q = 20
SDL_SCANCODE_Z = 29

debug = true

function Run()
	Initialize()
	GameLoop()
	Finalize()
end

function LoadAPIs()
	GetAPI(context.handle, 'printAPI', 'printAPI')
	GetAPI(context.handle, 'objectInstanceAPI', 'objectInstanceAPI')
	GetAPI(context.handle, 'luaObjInstManager', 'luaObjectInstanceManager')
	GetAPI(context.handle, 'printAPI', 'printAPI')
	GetAPI(context.handle, 'modelLibraryAPI', 'modelLibraryAPI')
	GetAPI(context.handle, 'renderManagerAPI', 'renderManagerAPI')
	GetAPI(context.handle, 'inputManagerAPI', 'inputManagerAPI')
    GetAPI(context.handle, 'luaVectorUtility', 'luaVectorUtility')
    GetAPI(context.handle, 'engineAPI', 'engineAPI')
    GetAPI(context.handle, 'cameraAPI', 'cameraAPI')
    GetAPI(context.handle, 'timeAPI', 'timeAPI')
    GetAPI(context.handle, 'terrainAPI', 'terrainAPI')
    GetAPI(context.handle, 'AABBAPI', 'AABBAPI')
    GetAPI(context.handle, 'islandCollisionAPI', 'islandCollisionAPI')
end

--[[
-- World --
World = 
{
	player = {},
	scenes = {},
	sceneCount = 0
}

	function World:new(o)-- return 'createdWorld'
		o = o or {}  
	    setmetatable(o,World) 
	    return o
	end
	
	
	
	function World:enterScene(sceneToEnter)
	end

	
	function World:loadNewSceneFromFile(sceneFile) return 'sceneIndex'
		--newScene.id = sceneCount
		--sceneCount = sceneCount+1
	end

		
-- Bodies --

RigidBody =
{
id
}

function RigidBody:new(o)-- return 'createdWorld'
		o = o or {}  
	    setmetatable(o,RigidBody) 
	    return o
	end
	
InteractableBody = RigidBody:New()
NPCBody = InteractableBody:New()
PickUpBody = InteractableBody:New()
	
	]]
-- Scene --
Scene =
{	
    id,
	instances = {},
	instCount = 0
}
	
	function Scene:new(o)
		o = o or {}
		local self = setmetatable({}, Scene)
		self.__index = self
		return self
	end

	function Scene.addRigidBody(instHandle)
		--instances[instCount] = instHandle
		--instCount = instCount + 1
	end
	
function LoadInstances(filePath, fileType)
	local fileData= read(filePath, ',')
	local numRows = 0

	for k,v in next, fileData do 
		numRows = numRows + 1
	end
	for i = 1, numRows do
		instanceID = luaObjInstManager.addNewInstance(fileData[i][2])

		bb = AABoundingBox.new(fileData[i][9],fileData[i][10],fileData[i][11],fileData[i][12],fileData[i][13],fileData[i][14])
		objpos = Vector3.new(fileData[i][3], fileData[i][4], fileData[i][5])
		dir = Vector3.new(fileData[i][6], fileData[i][7], fileData[i][8])
		sca = Vector3.new(fileData[i][15], fileData[i][16], fileData[i][17])
		if(fileData[i][18] == 1) then
			anim = true
		else
			anim = false
		end

		if(fileType == "gameObject") then
			n = gameObject.new(fileData[i][1], fileData[i][2], objpos, dir, bb, sca, anim, instanceID)
		else
			if(fileType == "npc") then
				n = npc.new(fileData[i][1], fileData[i][2], pos, dir, bb, sca, anim, instanceID, fileData[i][19], fileData[i][20], fileData[i][21])
			end
		end
		
		table.insert(gameObjects, n)
		objectInstanceAPI.setTranslation(instanceID,objpos.X,objpos.Y,objpos.Z)
		objectInstanceAPI.setOrientation(instanceID,dir.X,dir.Y,dir.Z)
		objectInstanceAPI.setScale(instanceID,sca.X,sca.Y,sca.Z)
		objectInstanceAPI.setAnimation(instanceID,anim)
		renderManagerAPI.addObject(instanceID)
	end
	
	if(fileType == "gameObject") then
		printAPI.print(numRows .. ' game objects loaded.\n')
	else
		if(fileType == "npc") then
			printAPI.print(numRows .. ' NPCs loaded.\n')
		end
	end	
	
end
--[[
function MoveAABB(aabb,inittpos,finalpos)
{
	vec3 diff = (newposvec - oldposvec);
	vec3 newMin = bboxmin + diff;
	vec3 newMax = bboxmax + diff;


	LuaRef newAABB = luabridge::newTable(LuaManager::GetInstance().GetContext(cHandle)->GetLuaState());

	newAABB["min"] = newMin;
	newAABB["max"] = newMax;
 
}
]]

function SaveInstances(filePath, data, fileType)
	local numRows = 0
	local total = 0
	
	for k,v in next, data do 
		numRows = numRows + 1
	end

	clearFile(filePath)

	for i = 1, numRows do
   
		if(fileType == "gameObject") then
			if gameObjects[i]["currentHealth"] == nil then
				total = total + 1
				write(filePath, gameObjects[i]["name"])
				write(filePath, ",")
				
				write(filePath, gameObjects[i]["model"])
				write(filePath, ",")
				
				write(filePath, gameObjects[i]["position"]["X"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["position"]["Y"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["position"]["Z"])
				write(filePath, ",")
				
				write(filePath, gameObjects[i]["direction"]["X"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["direction"]["Y"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["direction"]["Z"])
				write(filePath, ",")
				
				write(filePath, gameObjects[i]["boundingBox"]["minX"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["boundingBox"]["maxX"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["boundingBox"]["minY"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["boundingBox"]["maxY"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["boundingBox"]["minZ"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["boundingBox"]["maxZ"])
				write(filePath, ",")
				
				write(filePath, gameObjects[i]["scale"]["X"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["scale"]["Y"])
				write(filePath, ",")
				write(filePath, gameObjects[i]["scale"]["Z"])
				write(filePath, ",")
				
				if(gameObjects[i]["animation"] == true) then
					ani = 1
				else
					ani = 0
				end
				write(filePath, ani)
				write(filePath, "\n")
			end
		else
			if(fileType == "npc") then
				if gameObjects[i]["currentHealth"] ~= nil then
					total = total + 1
					write(filePath, gameObjects[i]["name"])
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["model"])
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["position"]["X"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["position"]["Y"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["position"]["Z"])
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["direction"]["X"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["direction"]["Y"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["direction"]["Z"])
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["boundingBox"]["minX"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["boundingBox"]["maxX"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["boundingBox"]["minY"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["boundingBox"]["maxY"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["boundingBox"]["minZ"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["boundingBox"]["maxZ"])
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["scale"]["X"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["scale"]["Y"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["scale"]["Z"])
					write(filePath, ",")
					
					if(gameObjects[i]["animation"] == true) then
						ani = 1
					else
						ani = 0
					end
					write(filePath, ani)
					write(filePath, ",")
					
					write(filePath, gameObjects[i]["currentHealth"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["maxHealth"])
					write(filePath, ",")
					write(filePath, gameObjects[i]["characterName"])
					write(filePath, "\n")
				end
			end
		end
	end
	
	if(fileType == "gameObject") then
		printAPI.print(total .. ' game objects saved.\n')
	else
		if(fileType == "npc") then
			printAPI.print(total .. ' NPCs saved.\n')
		end
	end	
end

function PrintVec3(veca)
    printAPI.print(veca.x .. "," .. veca.y .. "," .. veca.z .. "\n")
end

function PrintVec3s(vecc,vecb)
    printAPI.print(vecc.x .. "," .. vecc.y .. "," .. vecc.z .. " // " .. vecb.x .. "," .. vecb.y .. "," .. vecb.z .. " ")
end
	
-- Player --
	Player = 
	{
        instanceid =0,
        bbox = { min = {x=0,y=0,z=0}, max = {x=0,y=0,z=0} },
        pos = {x=0,y=0,z=0},
        lastpos = {x=0,y=0,z=0}
	}

	Player.__index = Player
	
	function Player:new(o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
		return o
	end

    function Player:setAABB(minx,maxx,miny,maxy,minz,maxz)
        printAPI.print("Setting player AABB...\n");

        
        self.bbox.min = {x=self.pos.x+minx,y=self.pos.y+miny,z=self.pos.z+minz}
        self.bbox.max = {x=self.pos.x+maxx,y=self.pos.y+maxy,z=self.pos.z+maxz}

        --[[
        {
        min = {pos.x+minx, pos.y+miny, pos.z+minz}, 
        max = {pos.x+maxx, pos.y+maxy, pos.z+maxz}
        }
        ]]
        printAPI.print("Player AABB set.\n");

    end

	function Player:update()
        
        -- Start movement update

        --printAPI.print("Updating player.\n")

	    -- written by liz translated from maddys c++ code
	    turnSpeed = 0.3
	    moveSpeed = 0.3
	      
        --rotation
	    origYaw = cameraAPI.getYaw(camera0,context.handle)
	    origPitch = cameraAPI.getPitch(camera0,context.handle)
        
	    deltaYaw =  - inputManagerAPI.mouseDeltaX() * turnSpeed
        --PrintVec3(deltaYaw)

	    deltaPitch = -inputManagerAPI.mouseDeltaY() * turnSpeed
        --printAPI.print(deltaYaw .. "," .. deltaPitch .. "\n")

	    cameraAPI.setYaw(camera0,origYaw + deltaYaw)
	    cameraAPI.setPitch(camera0,origPitch+deltaPitch)
   
		--translation   
	
   
        oldPos = cameraAPI.getPosition(camera0,context.handle);
	    forward = cameraAPI.forward(camera0,context.handle);
	    right = cameraAPI.right(camera0,context.handle);
        up = cameraAPI.up(camera0,context.handle);

  	    translation = luaVectorUtility.vec3_CreateEmpty(context.handle)

        --printAPI.print(translation[1] .. translation[2] .. translation[3] .. "\n")

	    if inputManagerAPI.isKeyDown(SDL_SCANCODE_W) then
        	translation = luaVectorUtility.vec3_Sum(translation,forward,context.handle)
            --printAPI.print(translation[1] .. translation[2] .. translation[3] .. "\n")
        end

        if inputManagerAPI.isKeyDown(SDL_SCANCODE_A) then
        	translation = luaVectorUtility.vec3_Subtract(translation,right,context.handle)
        end

	    if inputManagerAPI.isKeyDown(SDL_SCANCODE_S) then
        	translation = luaVectorUtility.vec3_Subtract(translation,forward,context.handle)
        end
	    if inputManagerAPI.isKeyDown(SDL_SCANCODE_D) then
        	translation = luaVectorUtility.vec3_Sum(translation,right,context.handle)
        end
        if debug then

            if inputManagerAPI.isKeyDown(SDL_SCANCODE_Q) then
        	    translation = luaVectorUtility.vec3_Sum(translation,up,context.handle)
            end

	        if inputManagerAPI.isKeyDown(SDL_SCANCODE_Z) then
        	    translation = luaVectorUtility.vec3_Subtract(translation,up,context.handle)
            end
        end
        
        emptyvec = luaVectorUtility.vec3_CreateEmpty(context.handle)

        --printAPI.print("Updating player location...\n")
        
        
        newPos = self.pos
        
        --printAPI.print("Updating player location...\n")

        if not luaVectorUtility.vec3_Equals(translation,emptyvec) then
       
            translation = luaVectorUtility.vec3_Normalize(translation,context.handle)
            translation = luaVectorUtility.vec3_ScalarMultiply(translation,moveSpeed,context.handle)

            newPos = luaVectorUtility.vec3_Sum(oldPos,translation, context.handle)

			newPos.y = GetHeightAtPoint(newPos.x, newPos.z) + 5
            cameraAPI.setPosition(camera0,newPos.x,newPos.y,newPos.z);  
        else
            --printAPI.print("Player has not moved.\n")

        end 
        -- Movement update finished

      -- printAPI.print("Moving player bounding box...\n")

        self.pos = cameraAPI.getPosition(camera0,context.handle)
        

        --PrintVec3s(self.bbox.min, self.bbox.max)


        --value = AABBBAPI.move(emptyv,emptyb,emptyc,context.handle)

        self.bbox = AABBAPI.move(self.bbox,self.lastpos,self.pos,context.handle)
        


        self.lastpos = self.pos
             
        --printAPI.print("Completed player update.\n")



        manyList = {}
        manyList[1] = plantBBox
        manyList[2] = plantBBox
        count = 2

        --[[
        errorBBox = {min = self.bbox.min, max = self.bbox.max}
        errorBBox.min.x =  errorBBox.min.x * 0.9
        errorBBox.min.y =  errorBBox.min.y * 0.9
        errorBBox.min.z =  errorBBox.min.z * 0.9
        errorBBox.max.x =  errorBBox.max.x * 0.9
        errorBBox.max.y =  errorBBox.max.y * 0.9
        errorBBox.max.z =  errorBBox.max.z * 0.9

        PrintVec3s(errorBBox.min,self.bbox.min)
        printAPI.print("+")
        PrintVec3s(errorBBox.max,self.bbox.max)
        printAPI.print("\n")
        ]]
        --PrintVec3s(self.bbox.min,self.bbox.max)
        --printAPI.print("\n")
        collides = islandCollisionAPI.checkAnyCollision(self.bbox,manyList,count)


        

        if collides then
           --printAPI.print("Collision! Resolved to: ")
           self.pos = islandCollisionAPI.resolve(self.pos,self.bbox,manyList,count,2,context.handle)
           cameraAPI.setPosition(camera0,self.pos.x,self.pos.y,self.pos.z)

           --PrintVec3(self.pos)


        end






        
	end
	
terrainSizeX = 1000
terrainSizeY = 1000
heightMapSize = 256
function LoadAssets()
	--modelLibraryAPI.AddModel("ground","Assets/Models/Ground/Ground.obj",false)
	--modelLibraryAPI.AddModel("tree","tree.obj", false)
	modelLibraryAPI.addModel("Plant","Assets/Models/SmallPlant/SmallPlant.obj",false)
	modelLibraryAPI.addModel("Bob","Assets/Models/Bob/bob.md5mesh",false)
	terrainHeightData = terrainAPI.generateTerrain(terrainSizeX, terrainSizeY, heightMapSize, 50, "Assets/HeightMaps/perlin_noise.png", "Assets/Models/Terrain/Terrain.obj", context.handle)
	modelLibraryAPI.addModel("Terrain","Assets/Models/Terrain/Terrain.obj",false)
	
	printAPI.print('Assets loaded\n')
end

function GetHeightAtPoint(x, y)
	if(x < 0) then
		x = 0
	end
	if(x > terrainSizeX) then
		x = terrainSizeX - 1
	end
	if(y < 0) then
		y = 0
	end
	if(y > terrainSizeY) then
		y = terrainSizeY - 1
	end
	xScale = terrainSizeX / heightMapSize
	yScale = terrainSizeY / heightMapSize

	xPixel = (x / terrainSizeX) * heightMapSize
	yPixel = (y / terrainSizeY) * heightMapSize
	BottomLeft = terrainHeightData[math.floor(xPixel) + 1][math.floor(yPixel) + 1]
	BottomRight = terrainHeightData[math.floor(xPixel) + 2][math.floor(yPixel) + 1]
	TopLeft = terrainHeightData[math.floor(xPixel) + 1][math.floor(yPixel) + 2]
	TopRight = terrainHeightData[math.floor(xPixel) + 2][math.floor(yPixel) + 2]
	if(x + y <= xPixel * xScale + yScale * yScale ) then
		z1 = TopLeft
		z2 = BottomRight
		z3 = BottomLeft
		x1 = (math.floor(xPixel) + 1) * xScale
		x2 = (math.floor(xPixel) + 2) * xScale
		x3 = (math.floor(xPixel) + 1) * xScale
		y1 = (math.floor(yPixel) + 2) * yScale
		y2 = (math.floor(yPixel) + 1) * yScale
		y3 = (math.floor(yPixel) + 1) * yScale

		first = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		second = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		third = 1 - first - second
		resultHeight = first * z1 + second * z2 + third * z3
	else
		z1 = TopLeft
		z2 = TopRight
		z3 = BottomRight
		x1 = (math.floor(xPixel) + 1) * xScale
		x2 = (math.floor(xPixel) + 2) * xScale
		x3 = (math.floor(xPixel) + 2) * xScale
		y1 = (math.floor(yPixel) + 2) * yScale
		y2 = (math.floor(yPixel) + 2) * yScale
		y3 = (math.floor(yPixel) + 1) * yScale

		first = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		second = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		third = 1 - first - second
		resultHeight = first * z1 + second * z2 + third * z3
	end
			--[[differenceInHeight = TopLeft - BottomLeft
		decimalPart = yPixel - math.floor(yPixel)
		changeBy = differenceInHeight * decimalPart
		leftSide = BottomLeft + changeBy

		differenceInHeight = TopRight - BottomRight
		decimalPart = yPixel - math.floor(yPixel)
		changeBy = differenceInHeight * decimalPart
		rightSide = BottomRight + changeBy

		differenceInHeight = leftSide - rightSide
		decimalPart = xPixel - math.floor(xPixel)
		changeBy = differenceInHeight * decimalPart
		resultHeight = leftSide + changeBy]]

	return resultHeight
end

function Initialize()

	LoadAPIs()
	
	printAPI.print('Initializing...\n')

    printAPI.print('Initialising engine...\n')

	engineAPI.Create(0);
	engineAPI.Initialise(1024,728);

	LoadAssets()
	
    printAPI.print('Initialising objects...\n')

	LoadInstances("SaveData/GO_Data.csv", "gameObject")
	LoadInstances("SaveData/NPC_Data.csv", "npc")
	
	Terrain01 = luaObjInstManager.addNewInstance("Terrain")
	objectInstanceAPI.setTranslation(Terrain01,0,0,0)
	
	plant01 = luaObjInstManager.addNewInstance("Plant")
	objectInstanceAPI.setTranslation(plant01,10,10,10)

	plant02 = luaObjInstManager.addNewInstance("Plant")
	objectInstanceAPI.setTranslation(plant02,0,0,0)
    
	giantPlant = luaObjInstManager.addNewInstance("Plant")
	objectInstanceAPI.setTranslation(giantPlant,100,20,100)
    objectInstanceAPI.setScale(giantPlant,10,10,10)

    printAPI.print('Initialising AABBs...\n')

    plantScale = objectInstanceAPI.getScale(giantPlant, context.handle)
    plantLoc = objectInstanceAPI.getTranslation(giantPlant, context.handle)

    plantBBox = AABBAPI.getAABB(giantPlant, context.handle)
    printAPI.print(plantScale.x .. "\n")
    plantBBox.min = luaVectorUtility.vec3_Multiply(plantBBox.min,plantScale,context.handle)
    plantBBox.min = luaVectorUtility.vec3_Sum(plantBBox.min,plantLoc,context.handle)
    plantBBox.max = luaVectorUtility.vec3_Multiply(plantBBox.max,plantScale,context.handle)
    plantBBox.max = luaVectorUtility.vec3_Sum(plantBBox.max,plantLoc,context.handle)

    -- plantBBox.min = objectInstanceAPI.getScale(giantPlant)
    -- plantBBox.max *= objectInstanceAPI.getScale(giantPlant)
    -- plantBBox.max *= objectInstanceAPI.getScale(giantPlant)


    renderManagerAPI.addObject(plant01)
    renderManagerAPI.addObject(plant02)


    printAPI.print('Initialising scene...\n')


	scene01 = Scene:new()

    
    printAPI.print('Initialising camera...\n')

    camera0 = cameraAPI.addNewInstance()

    cameraAPI.setPosition(camera0,0,25,10)

    printAPI.print('Initialising rendermanager...\n')
    renderManagerAPI.initialise()

    printAPI.print('Initialising player...\n')

	
	player0 = Player:new()
    player0:setAABB(-5,5,-50,50,-5,5) -- Y values higher than X and Z so the player doesn't jump above things with the island collisions. -- todo reduce if we implement jumping

    printAPI.print('Initialization finished.\n')
end

function GameLoop()
	run = true
	while run do
    	--printAPI.print('Running game loop...\n')

		Update()
		Render()
		--if count == 10 then
			--return
		--end
	end
end

function Finalize()
	printAPI.print('Finalizing...\n')
end

function Update()

    engineAPI.BeginUpdate()

    --engineAPI.handleEvents()

    --inputManagerAPI.update();

	--Lua update here
    count = (count or 0) + 1
	--run = mainAPI.update()
	
	
	e = inputManagerAPI.isKeyDown(8)
	if e then
		printAPI.print("e")
		objectInstanceAPI.setTranslation(plant01,0,0,0)

	end

    esc = inputManagerAPI.isKeyDown(SDL_SCANCODE_ESCAPE)
	if esc then
		printAPI.print("Quitting - pressed Esc.\n")
        run = false
	end
	
	if inputManagerAPI.isKeyDown(SDL_SCANCODE_P) then
		SaveInstances("SaveData/GO_Save.csv", gameObjects, "gameObject")
		SaveInstances("SaveData/NPC_Save.csv", gameObjects, "npc")
	end
	
	local numRows = 0
	for k,v in next, gameObjects do 
		numRows = numRows + 1
	end

	for i = 1, numRows do
		if gameObjects[i]["currentHealth"] ~= nil then
			gameObjects[i]:Update()
			if gameObjects[i]["alive"] == false then
				gameObjects[i] = nil
			end
		end
	end

    player0:update();
	engineAPI.EndUpdate();
	
end


function Render()

	--printAPI.print('count = ')
	--printAPI.print(count)
	--printAPI.print('\n')
	--mainAPI.render()

    engineAPI.BeginRender()

    --printAPI.print("Getting time...\n");

    time = timeAPI.elapsedTimeMs()

    --printAPI.print("Getting world matrix...\n");

    worldMatrix = luaVectorUtility.mat4_CreateIdentity(context.handle)

    --printAPI.print("Getting view matrix...\n");

    viewMatrix = cameraAPI.getViewMatrix(camera0, context.handle)

    --printAPI.print("Getting projection matrix...\n");

    projectionmatrix = cameraAPI.getProjectionMatrix(camera0, context.handle)

    
   -- printAPI.print("Rendering...\n");

    --renderManagerAPI.render(worldMatrix,viewMatrix,projectionMatrix,time)
    renderManagerAPI.renderFromCamera(camera0,time)
	--Lua render here

    
    --printAPI.print("Render Successful\n");

    engineAPI.EndRender()


end

local status, err = pcall(Run)
if not status then
	printAPI.print(err)
end
	

	
	
	
	
	

--[[

	

	

	local player = {}

	
	bodies = {}
	
	scenes = {}
	
	function world:enterScene(sceneToEnter)
	end
	
	function world:loadNewSceneFromFile(sceneFile) return 'sceneIndex'
		--newScene
		newScene.id = scenes.count
	end




]]