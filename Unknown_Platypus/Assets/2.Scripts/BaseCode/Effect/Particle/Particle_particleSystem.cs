using UnityEngine;
using System.Collections;

public class Particle_particleSystem : ParticleBase
{
    ParticleSystem m_particle;
    float m_startSize = 1f;
  
    public Particle_particleSystem( ParticleSystem _particle )
    {
        m_particle = _particle;
        m_startSize = m_particle.startSize;
    }

    public override void SetSize(float _size)
    {
        base.SetSize(_size);

        if (null == m_particle)
            return;
        
        m_particle.startSize = m_startSize * _size;
    }

    public override void Play(bool _loop)
    {
        if (null == m_particle)
            return;
     
        m_particle.Play();
    }

    public override void Stop()
    {      
        if (null == m_particle)
            return;

        m_particle.Stop();
    }

    public override void SetSpeed(float _speed)
    {
        if (null == m_particle)
            return;

        m_particle.playbackSpeed = _speed;
    }

    public override bool IsStop()
    {
        if (null == m_particle)
            return true;

        return m_particle.isPlaying == false;
    }
    /*public override float GetMaxTime()
    {
        if (null == m_particle)
            return 0f;

        return m_particle.main.duration;
    }*/
}
