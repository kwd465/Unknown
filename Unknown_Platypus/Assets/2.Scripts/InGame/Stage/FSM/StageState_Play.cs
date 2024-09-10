using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_Play : StageState
{

    public StageState_Play() : base(eSTAGE_STATE.PLAY)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_SpawnLogic.Init();
    }

    public override void Update()
    {
        base.Update();
        StagePlayLogic.instance.m_SpawnLogic.UpdateLogic();
        StagePlayLogic.instance.m_Player.UpdateLogic();
    }

   
}
