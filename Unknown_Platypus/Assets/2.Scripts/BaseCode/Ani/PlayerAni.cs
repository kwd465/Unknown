using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class PlayerAni
{
    protected float m_speed = 1f;
    protected Vector3 m_dir = Vector3.zero;

    public Vector3 Dir => m_dir;

    public PlayerAni()
    {
        
    }

    public virtual void Init()
    {
    }

    public virtual void SetDir(Vector3 _dir)
    {
        m_dir = _dir;
    }

    public virtual void Play(string _name)
    {
        Play(_name, false);
    }

    public virtual void SetPlayActive(string _name, bool _active) { }
    public virtual void SetAniInt(string _name, int _idx) { }

    public virtual void SetSpeed(float _speed)
    {
        m_speed = _speed;
    }

    public virtual float GetMaxTime(string _name)
    {
        return 1f;
    }

    public virtual float GetMoveDelta()
    {
        return 1f;
    }

    public virtual void UpdateLogic()
    {
    }

    public virtual void EndAnimation(int _nameHash)
    {

    }
    public virtual void ResetAni()
    {

    }
    public virtual void ResetAni(string _name)
    {

    }


    public abstract void Play(string _name, bool _loop);
    public abstract void PlayTime(string _name, float _time);
    public abstract bool IsPlay();
    public abstract void SetPause(bool _isPause);
    public abstract float GetAniTime();
    public abstract List<string> GetAniNameList();

    public virtual void SetCullMode(bool _isOn)
    {

    }

    public virtual bool IsInitAni()
    {
        return false;
    }
    public virtual void InitAni()
    {

    }
}
