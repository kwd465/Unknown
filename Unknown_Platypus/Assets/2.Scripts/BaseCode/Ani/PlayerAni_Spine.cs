

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Spine.Unity;

public class PlayerAni_Spine : PlayerAni
{
    protected SkeletonAnimation m_spine;

    public PlayerAni_Spine(SkeletonAnimation _spine)
    {
        m_spine = _spine;
    }

    public override void SetDir(Vector3 _dir)
    {
        base.SetDir(_dir);
        
        if (_dir.x != 0)
        {
            m_spine.Skeleton.ScaleX = _dir.x > 0 ?-1f:1f;
        }
    }

    public override void Play(string _name, bool _loop)
    {
        if (null == m_spine)
            return;

        m_spine.state.SetAnimation(0, _name, _loop);
    }

    public override void PlayTime(string _name, float _time)
    {
        if (null == m_spine)
            return;

        Play(_name);
        Spine.TrackEntry _state = m_spine.state.GetCurrent(0);
        if (_state == null)
            return;
        _state.TrackTime = _time;
    }

    public override void SetPause(bool _isPause)
    {
        m_spine.timeScale = _isPause == true ? 0f : m_speed;
    }

    public override bool IsPlay()
    {
        if (null == m_spine)
            return false;

        Spine.TrackEntry _state = m_spine.state.GetCurrent(0);
        if (_state == null)
            return false;

        return _state.IsComplete == false;
    }

    public override float GetAniTime()
    {
        if (null == m_spine)
            return 0f;

        Spine.TrackEntry _state = m_spine.state.GetCurrent(0);
        if (_state == null)
            return 0f;

        return _state.TrackTime;
    }

    public override void SetSpeed(float _speed)
    {
        m_speed = _speed;
        m_spine.timeScale = m_speed;
    }


    public override List<string> GetAniNameList()
    {
        if (null == m_spine)
            return null;

        List<string> _aniList = new List<string>();
        foreach (var _var in m_spine.skeleton.Data.Animations)
        {
            _aniList.Add(_var.Name);
        }
        return _aniList;
    }

    public override float GetMaxTime(string _name)
    {
        if (null == _name)
            return 1f;

        if (null == m_spine)
            return 1f;

        Spine.Animation _ani = m_spine.skeleton.Data.FindAnimation(_name);
        if (_ani == null)
            return 1f;

        return _ani.Duration;
    }

    public override void ResetAni()
    {
        m_spine.state.SetAnimation(0, "idle", false);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
        SetSpeed(Define.timeScale);
    }
}
