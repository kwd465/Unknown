using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState_Idle : PlayerState
{
    public PlayerState_Idle(Player _player) : base(_player, ePLAYER_STATE.idle)
    {
    }

    public override void Enter()
    {
        base.Enter();
        m_player.Ani.Play(Define.Idle, true);
    }

    public override void Update()
    {
        base.Update();
    }


}
