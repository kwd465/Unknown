using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState_MoveAttack : PlayerState
{

    private float m_fAttackTime = 2.3f;
    Bounds bounds;
    public PlayerState_MoveAttack(Player _player) : base(_player, ePLAYER_STATE.move_Attack)
    {
    }

    public override void Enter()
    {
        base.Enter();
        bounds = StagePlayLogic.instance.mapSize;
        m_fAttackTime = 2.3f;
        m_player.Ani.Play(Define.MoveAttack, false);
    }

    public override void Update()
    {
        base.Update();
        Vector2 nextVec = m_player.inputVec * m_player.getData.Table.moveSpeed * Time.fixedDeltaTime;

        Vector2 targetPos = m_player.Rig.position + nextVec;

        float clampX = Mathf.Clamp(targetPos.x, bounds.min.x + 2, bounds.max.x - 2);
        float clampY = Mathf.Clamp(targetPos.y, bounds.min.y + 2, bounds.max.y - 2);

        targetPos.x = clampX;
        targetPos.y = clampY;

        m_player.Rig.MovePosition(targetPos);
        m_player.Ani.SetDir(m_player.inputVec);

        if (m_fAttackTime <= 0)
        {
            if(m_player.inputVec == Vector3.zero)
            {
                m_player.Fsm.SetState(ePLAYER_STATE.idle);
            }
            else
            {
                m_player.Fsm.SetState(ePLAYER_STATE.move);
            }
        }

        m_fAttackTime -= Time.fixedDeltaTime;

    }

}
