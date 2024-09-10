using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_Finish : StageState
{
    public StageState_Finish() : base(eSTAGE_STATE.FINISH)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_SpawnLogic.Clear();
        GameData.m_isWin = true;
        UIPopControl.instance.Open(UIDefine.UIpopBattleResult);
    }

    public override void Update()
    {
        base.Update();
    }
}
  
