using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState : FsmState<ePLAYER_STATE>
{
    protected Player m_player;

    public Player getPlayer
    {
        get
        {
            return m_player;
        }
            
    }

    public PlayerState(Player _player , ePLAYER_STATE _state) : base(_state)
    {
        m_player = _player;
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
