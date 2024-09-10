using DG.Tweening.Core.Easing;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class PlayerState_Move : PlayerState
{
    Bounds bounds;
    public PlayerState_Move(Player _player) : base(_player, ePLAYER_STATE.move)
    {
    }

    public override void Enter()
    {
        base.Enter();
        bounds = StagePlayLogic.instance.mapSize;
        m_player.Ani.Play(Define.Move , true);
    }

    public override void Update()
    {
        base.Update();
        Vector2 nextVec = m_player.inputVec * m_player.getData.Table.moveSpeed * Time.fixedDeltaTime;

        Vector2 targetPos = m_player.Rig.position + nextVec;

        float clampX = Mathf.Clamp(targetPos.x, bounds.min.x+2, bounds.max.x-2);
        float clampY = Mathf.Clamp(targetPos.y, bounds.min.y+2, bounds.max.y-2);

        targetPos.x = clampX;
        targetPos.y = clampY;

        
        m_player.Rig.MovePosition(targetPos);
        m_player.Ani.SetDir(m_player.inputVec);
    }

    public override void End()
    {
        base.End();
    }
}
