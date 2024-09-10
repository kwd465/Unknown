using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//������ �׿����� �������� �������� ���� �������� �̾�� üũ �ϸ�ɵ�
//ĳ���� �����ִ� ��ü�鵵 ���⼭ ������
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
