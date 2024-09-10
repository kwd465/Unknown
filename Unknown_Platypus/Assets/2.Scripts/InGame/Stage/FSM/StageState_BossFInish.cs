using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//보스를 죽였을때 스테이지 종료할지 다음 스테이지 이어갈지 체크 하면될듯
//캐릭터 막고있던 물체들도 여기서 없애자
public class StageState_BossFInish : StageState
{
    public StageState_BossFInish() : base(eSTAGE_STATE.BOSS_FINISH)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_SpawnLogic.BossMonsterDie();
    }

    public override void Update()
    {
        base.Update();
    }

}
