using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_Start : StageState
{
    //스테이지 시작
    //연출같은거 들어가면 여기서 처리해야되는데 없으면 바로 패스
    public StageState_Start() : base(eSTAGE_STATE.START)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.PLAY);
    }

}
