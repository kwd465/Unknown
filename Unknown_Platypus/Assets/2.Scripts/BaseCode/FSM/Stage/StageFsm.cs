using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum eSTAGE_STATE
{
    NONE,
    START,
    PLAY,
    BOSS_START,
    BOSS,
    BOSS_FINISH,
    FINISH,
    FAIL,

}

[System.Serializable]
public class StageFsm : Fsm<eSTAGE_STATE>
{
    public StageFsm()
    {
    }

    public override void Update()
    {
        base.Update();
    }


}
