//#if USE_SPINE
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particle_spineAnimation : ParticleBase
{
    Spine.Unity.SkeletonAnimation m_spine;

    public Particle_spineAnimation(Spine.Unity.SkeletonAnimation _ani)
    {
        m_spine = _ani;
    }   

    public override void Play(bool _loop)
    {        
        if (null == m_spine)
            return;

        Spine.TrackEntry _track = m_spine.AnimationState.GetCurrent(0);
        if (null == _track)
            return;
               
        Spine.TrackEntry _entity = m_spine.state.SetAnimation(0, _track.Animation.Name, false);
        _entity.Loop = _loop;
        _entity.TrackTime = 0f;
    }

    public override void Stop()
    {
        if (null == m_spine)
            return;

        m_spine.StopAllCoroutines();
    }   

    public override void SetSpeed(float _speed)
    {
        if (null == m_spine)
            return;

        m_spine.timeScale = _speed;
    }

    public override bool IsStop()
    {
        if (null == m_spine)
            return true;

        Spine.TrackEntry _track = m_spine.AnimationState.GetCurrent(0);
        if (null == _track)
            return true;

        if (_track.Loop == true)
            return false;
        return _track.IsComplete == true;
    }

    public override void Play(string _aniName, bool _loop)
    {  
        if (null == m_spine)
            return;

        Spine.TrackEntry _track = m_spine.AnimationState.GetCurrent(0);
        if (null == _track)
            return;

        Spine.TrackEntry _entity = m_spine.state.SetAnimation(0, _aniName, false);
        _entity.Loop = _loop;
        _entity.TrackTime = 0f;
    }

#if false
    public override float GetMaxTime()
    {
        if (null == m_spine)
            return 0f;

        Spine.TrackEntry _track = m_spine.AnimationState.GetCurrent(0);
        if (null == _track)
            return 0f;

        return _track.trackTime;
    }
#endif
}

//#endif