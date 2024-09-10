using System.Collections;
using UnityEngine;
using BH;
using DarkTonic.MasterAudio;

public class SoundControl
{
    public static void PlayBtn()
    {
        MasterAudio.PlaySound("click");
    }
    public static void Play(string soundPath)
    {
        MasterAudio.PlaySound(soundPath);
    }

    public static void StopBGM()
    {
        MasterAudio.StopPlaylist();
    }

    public static void AllPause(bool _isPause)
    {
        PauseSE(_isPause);
        PauseBGM(_isPause);
    }

    public static void PauseSE(bool _isPause)
    {
        MasterAudio.MixerMuted = _isPause;
    }

    public static void PauseBGM(bool _isPause)
    {
        MasterAudio.PlaylistsMuted = _isPause;
    }

    public static void PlayBGM(string _bgmName)
    {
        MasterAudio.StartPlaylist(_bgmName);
    }

    
}
