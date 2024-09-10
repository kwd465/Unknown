using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.RuleTile.TilingRuleOutput;

public class MonsterState_Move : PlayerState
{
    public float obstacleAvoidanceDistance = 4f; // ��ֹ� ȸ�� �Ÿ�
    public MonsterState_Move(Player _monster) : base(_monster, ePLAYER_STATE.move)
    {

    }

    public override void Enter()
    {
        base.Enter();
        
        m_player.NavMeshAgent.speed = m_player.getData.Table.moveSpeed;
    }

    public override void Update()
    {
        base.Update();
        
        Vector2 dirVec = StagePlayLogic.instance.m_Player.Rig.position - m_player.Rig.position;
        m_player.Ani.SetDir(dirVec);


        //���߿� A* �˰������� ����Ͽ� ���Ͱ� �÷��̾ ���� �̵��ϵ��� ������ �����Դϴ�.
        //// ��ֹ� ȸ�Ǹ� ���� ��ֹ� �ֺ��� ȸ���մϴ�.
        //RaycastHit2D hit = Physics2D.Raycast(m_player.transform.position, dirVec, obstacleAvoidanceDistance , 9);
        //if (hit.collider != null)
        //{
        //    // ��ֹ��� �����Ǹ� ��ֹ��� ���ϱ� ���� ������ �����մϴ�.
        //    Vector2 avoidDirection = Vector2.Perpendicular(hit.normal).normalized;
        //    dirVec += avoidDirection; // ������ ȸ�� �������� �̵�
        //}

        // ��ǥ �������� �̵��մϴ�.
        //Vector2 nextVec = dirVec.normalized * m_player.getData.Table.moveSpeed * Time.fixedDeltaTime;
        // m_player.Rig.MovePosition(m_player.Rig.position + nextVec);
        if(m_player.IsAttack == false){
            m_player.NavMeshAgent.SetDestination(StagePlayLogic.instance.m_Player.Rig.position);
            m_player.Rig.velocity = Vector2.zero;
        }

    }
    
}
