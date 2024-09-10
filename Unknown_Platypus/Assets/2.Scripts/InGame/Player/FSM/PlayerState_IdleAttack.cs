using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState_IdleAttack : PlayerState
{

    private float m_attackTime = 1.3f;


    public PlayerState_IdleAttack(Player _player) : base(_player, ePLAYER_STATE.idle_Attack)
    {
    }

    public override void Enter()
    {
        base.Enter();
        m_attackTime = 1.3f;
        m_player.Ani.Play(Define.IdleAttack, false);
    }

    public override void Update()
    {
        base.Update();

        if(m_attackTime <= 0)
        {
            m_player.Fsm.SetState(ePLAYER_STATE.idle);
        }

        m_attackTime -= Time.fixedDeltaTime;

    }
}
