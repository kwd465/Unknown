using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//���� ���� ������ �ʿ��ϸ� ���⼭ ó���Ѵ�
//�ʿ��� ������°͵� ���⼭ ��������
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
