#ifndef TextureLibrary_h__
#define TextureLibrary_h__

#include <unordered_map>
#include "Gl/glew.h"
#include "Types.h"
#include "Singleton.h"

class TextureLibrary : public Singleton<TextureLibrary>
{

public:

	void InitTextureLibrary();

	void AddTexture(string const& name, GLuint textureID);

	void AddTexture(string const& name, string const& filePath, bool useMips = true);

	GLuint GetTexture(string const& name) const;

private:

	std::unordered_map<string, GLuint> textures;

};


#endif