using UnityEngine;
using System.Collections;

public abstract class ParticleBase
{
    public abstract void Play(bool _loop);
    public virtual void Play(string _aniname, bool _loop) { }
    public abstract void Stop();
    public abstract bool IsStop();
    public abstract void SetSpeed(float _speed);

    public virtual void SetSize(float _size) { }
    //public abstract float GetMaxTime();
}
