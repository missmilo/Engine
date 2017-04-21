#include "FrameBuffer.h"
#include "Shader.h"



/**
* @file SceneDecomposeEffect.h
* @Author Maddisen Topaz
* @date   S1, 2017
* @brief
*/

class SceneDecomposeEffect
{
public:

  SceneDecomposeEffect();
  void Bind(GLuint DiffuseTexture, GLuint DepthTexture, GLuint LinearDepthTexture, GLuint NormalTexture, GLuint WorldPosTexture);
  void Unbind();

private:
  FrameBuffer m_fb;
  IShader const* m_pShader;
};
