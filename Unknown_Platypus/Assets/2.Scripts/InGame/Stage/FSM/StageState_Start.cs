using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageState_Start : StageState
{
    //�������� ����
    //���ⰰ���� ���� ���⼭ ó���ؾߵǴµ� ������ �ٷ� �н�
    public StageState_Start() : base(eSTAGE_STATE.START)
    {

    }

    public override void Enter()
    {
        base.Enter();
        StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.PLAY);
    }

}
