using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_Boss : StageState
{

    public StageState_Boss() : base(eSTAGE_STATE.BOSS)
    {

    }

    public override void Enter()
    {
        base.Enter();
    }

    public override void Update()
    {
        base.Update();
        StagePlayLogic.instance.m_SpawnLogic.UpdateLogic();
        StagePlayLogic.instance.m_Player.UpdateLogic();
    }
}
