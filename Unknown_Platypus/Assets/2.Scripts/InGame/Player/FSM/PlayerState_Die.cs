using BH;
using Spine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState_Die : PlayerState
{

    public PlayerState_Die(Player _player) : base(_player, ePLAYER_STATE.death)
    {
    }

    public override void Enter()
    {
        base.Enter();

        StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.FAIL);
    }

    public override void Update()
    {
        base.Update();
        //시간 체크후 게임종료


    }
    
}
