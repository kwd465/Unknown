using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//보스 등장 연출이 필요하면 여기서 처리한다
//맵에서 벽만드는것도 여기서 진행하자
public class StageState_BossStart : StageState
{
    public StageState_BossStart() : base(eSTAGE_STATE.BOSS_START)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.BOSS);
    }

}
