using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState : FsmState<eSTAGE_STATE>
{
    public StageState(eSTAGE_STATE _state) : base(_state)
    {
    }

    public override void End()
    {
        base.End();
    }

    public override void Enter()
    {
        base.Enter();
    }

    public override void Update()
    {
        base.Update();
    }
}
