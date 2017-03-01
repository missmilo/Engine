#include "ObjectInstanceAPI.h"
#include "LuaManager.h"


ObjectInstanceAPI::ObjectInstanceAPI()
{
}


ObjectInstanceAPI::~ObjectInstanceAPI()
{
}


static void SetTranslation(int instHandle, vec3 const& translation)
{

}

void ObjectInstanceAPI::Expose(LuaContextHandle contextHandle, string luaAPIName)
{
	LuaContext* pContext = LuaManager::GetInstance().GetContext(contextHandle);
	pContext->ExposeFunction(luaAPIName, "setTranslation", SetTranslation);
}