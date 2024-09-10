using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterState_Die : PlayerState
{
    float _checkTime = 0;

    public MonsterState_Die(Player _monster) : base(_monster, ePLAYER_STATE.death)
    {

    }

    public override void Enter()
    {
        base.Enter();
        _checkTime = 0;
        m_player.Death();
    }

    public override void Update()
    {
        base.Update();
        _checkTime += Time.deltaTime;
        if (_checkTime >= 0.5f)
        {
            m_player.Close();
            StagePlayLogic.instance.m_SpawnLogic.MonsterDie(m_player);
            StagePlayLogic.instance.AddKil();
        }
    }
}
