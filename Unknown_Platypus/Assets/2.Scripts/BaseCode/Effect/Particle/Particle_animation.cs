using UnityEngine;
using System.Collections;

public class Particle_animation : ParticleBase
{
    Animation m_animation;    

    public Particle_animation(Animation _ani)
    {
        m_animation = _ani;
    }

    public override void Play(bool _loop)
    {
        if (null == m_animation)
            return;

        m_animation.Play();
    }

    public override void Stop()
    {
        if (null == m_animation)
            return;

        m_animation.Stop();
    }

    public override bool IsStop()
    {
        if (null == m_animation)
            return true;

        return m_animation.isPlaying == false;
    }

    public override void SetSpeed(float _speed)
    {
        if (null == m_animation)
            return;
        //need test
        //m_animation[m_animation.clip.name].speed = _speed;        
    }


    /*public override float GetMaxTime()
    {
        if (null == m_animation)
            return 0f;

        //return m_animation.clip.length;
        return 1f;
    }*/
}
