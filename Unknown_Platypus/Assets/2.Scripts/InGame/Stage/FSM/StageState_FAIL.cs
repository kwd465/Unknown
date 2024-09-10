using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_FAIL : StageState
{
    public StageState_FAIL() : base(eSTAGE_STATE.FAIL)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_SpawnLogic.Clear();
        GameData.m_isWin = false;
        UIPopControl.instance.Open(UIDefine.UIpopBattleResult);
    }

    public override void Update()
    {
        base.Update();
    }
}
