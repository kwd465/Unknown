using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAni_Animator : PlayerAni
{
    protected Player m_player;
    public int m_moveHash = Animator.StringToHash("move");

    protected Animator m_animator;

    protected int m_curPlayName;
    protected bool m_isPlay = false;

    protected float m_curMove = 0f;
    protected float m_moveChangeSpeed = 20f;
    AnimatorCullingMode m_defaultCullMode;
    bool m_isInit;

    public PlayerAni_Animator(Player _Plyaer)
    {
        m_player = _Plyaer;
        m_animator = _Plyaer.gameObject.GetComponentInChildren<Animator>();
        m_defaultCullMode = m_animator.cullingMode;
    }

    public override void Init()
    {

        if (null == m_animator)
            return;
        m_animator.SetBool("death", false);
        m_animator.SetBool("stun", false);
    }

    public override void ResetAni()
    {
        m_animator.Play("beHit");
    }

    public override void ResetAni(string _name)
    {
        if (m_curPlayName == Animator.StringToHash(_name))
            return;

        m_animator.ResetTrigger(_name);
    }


    public override void Play(string _name, bool _loop)
    {
        m_curPlayName = Animator.StringToHash(_name);
        for (int i = 0; i < m_animator.parameters.Length; ++i)
        {
            AnimatorControllerParameter _param = m_animator.parameters[i];
            if (_param.type == AnimatorControllerParameterType.Trigger)
                m_animator.ResetTrigger(_param.name);
        }
        //Debug.Log("Play Ani: " + _name + "=>" + m_curPlayName);
        //m_isInit = false;
        m_animator.SetTrigger(_name);
        m_isPlay = true;
    }

    public override void SetPlayActive(string _name, bool _active)
    {
        m_animator.SetBool(_name, _active);
    }

    public override void EndAnimation(int _nameHash)
    {
        if (m_curPlayName != _nameHash)
            return;

        //if (false == m_isInit)
        //    return;

        m_isPlay = false;
    }

    public override float GetAniTime()
    {
        if (null == m_animator)
            return 0f;

        AnimatorStateInfo _info = m_animator.GetCurrentAnimatorStateInfo(0);
        if (_info.shortNameHash != m_curPlayName)
            return 0f;

        return _info.normalizedTime;
    }

    public override void PlayTime(string _name, float _time)
    {
        if (null == m_animator)
            return;

        m_animator.Play(_name, 0, _time);
    }

    public override bool IsPlay()
    {
        return m_isPlay;
    }

    public override void SetSpeed(float _speed)
    {
        m_animator.speed = m_speed = _speed;
    }

    public override void SetPause(bool _isPause)
    {
        m_animator.speed = _isPause == true ? 0f : m_speed;
    }

    public override float GetMoveDelta()
    {
        return m_curMove;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if (null == m_animator)
            return;

        m_curMove = m_animator.GetFloat(m_moveHash);
        float _targetMove = m_player.IsMove == false ? 1f : 0f;
        float _move = m_curMove;

        if (_targetMove != m_curMove)
            _move = Mathf.Lerp(m_curMove, _targetMove, Time.deltaTime * m_moveChangeSpeed * Define.timeScale);

        if (m_curMove != _move)
            m_animator.SetFloat(m_moveHash, _move);
    }

    public override void SetAniInt(string _name, int _idx)
    {

        m_animator.SetInteger(_name, _idx);
    }

    public override void SetCullMode(bool _isOn)
    {
        m_animator.cullingMode = (_isOn) ? m_defaultCullMode : AnimatorCullingMode.AlwaysAnimate;
    }


    public override bool IsInitAni()
    {
        return m_isInit;
    }
    public override void InitAni()
    {
        m_isInit = true;
    }
#if UNITY_EDITOR

    public override List<string> GetAniNameList()
    {
        List<string> _anilist = new List<string>();

        UnityEditor.Animations.AnimatorController ac
                = m_animator.runtimeAnimatorController as UnityEditor.Animations.AnimatorController;

        if (null == ac)
            return _anilist;

        UnityEditor.Animations.AnimatorControllerLayer acl = ac.layers[0];
        UnityEditor.Animations.AnimatorStateMachine sm = acl.stateMachine;
        foreach (var _var in sm.states)
        {
            _anilist.Add(_var.state.name);
        }

        return _anilist;
    }

#else
    public override List<string> GetAniNameList()
    {
        return null;
    }
#endif
}
