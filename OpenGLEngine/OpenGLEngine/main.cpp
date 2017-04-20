#include "LuaManager.h"
#include "IEngine.h"
#include "GLEngine.h"
#include "DXEngine.h"


int main(int argc, char **argv)
{
	LuaManager::Initialize();
	//MainAPI::Initialise();
	LuaManager::GetInstance().CreateContext("LuaScripts/Game.lua");

		
  //return(0);
}