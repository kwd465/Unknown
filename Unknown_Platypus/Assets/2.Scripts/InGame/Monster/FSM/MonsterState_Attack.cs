using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterState_Attack : PlayerState
{
    
    private float m_checkTime = 0f;


    public MonsterState_Attack(Player _monster) : base(_monster, ePLAYER_STATE.attack)
    {

    }

    //아무것도 하지 않음 대기 상태
    public override void Enter()
    {
        base.Enter();
        m_checkTime = 0;
        m_player.NavMeshAgent.isStopped = true;
    }

    public override void Update()
    {
        base.Update();
        m_checkTime += Time.fixedDeltaTime;
        if(m_checkTime >= m_player.getData.Table.attackSpeed)
        {
            StagePlayLogic.instance.m_Player.SetDamage(m_player.getData.GetStatValue(eSTAT.atk));
            m_checkTime = 0;
        }


    }


    public override void End()
    {
        base.End();
        m_player.NavMeshAgent.isStopped = false;
    }


}
