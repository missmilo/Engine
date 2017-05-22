#include "SoundManager.h"


static std::vector<ChannelHandle> channels;


void channelFinishedCB(int channel)
{
	channels.push_back(channel);
}


void SoundManager::InitSoundManager()
{
		//m_numChannels = 16;

		Mix_AllocateChannels(16);

		for (int i = 0; i < 16; i++)
		{
			channels.push_back(i);
		}	
	
	Mix_ChannelFinished(channelFinishedCB);
}

void SoundManager::AddSound(string name, string filepath)
{
	Mix_Chunk* newEffect = Mix_LoadWAV(filepath.c_str());
	
	if (!newEffect) 
	{
		printf("Mix_LoadWAV: %s\n", Mix_GetError());
	}
	m_soundMap.emplace(name, newEffect);
}

ChannelHandle SoundManager::PlaySound(string name, int loopCount)
{
	if (channels.size() == 0)
	{
		return -1;
	}

	auto got = m_soundMap.find(name);

	if (got == m_soundMap.end())
	{
		printf("Sound with name %s not found.", name.c_str());
		return -1;
	}

	ChannelHandle channel = channels[channels.size() - 1];
	channels.pop_back();

	Mix_PlayChannel(channel, got->second, loopCount);

	return channel;
}

void SoundManager::ResumeChannel(ChannelHandle sound)
{
  Mix_Resume(sound);
}

void SoundManager::PauseChannel(ChannelHandle myChannel)
{
  Mix_HaltChannel(myChannel);
}
