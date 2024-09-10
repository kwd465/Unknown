using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class PlayerFsm : Fsm<ePLAYER_STATE>
{
    Player m_npc;
    ePLAYER_STATE[] m_notMove = new ePLAYER_STATE[]{
        ePLAYER_STATE.attack ,
        ePLAYER_STATE.skill ,
        ePLAYER_STATE.stun};

    public PlayerFsm(Player _npc)
    {
        m_npc = _npc;
    }

    bool IsImmuneState = false;

    public void EndImmunState()
    {
        IsImmuneState = false;
    }


    public override void Update()
    {
        base.Update();
        /*if (m_npc.getData.getHp <= 0f && IsState(eNPC_STATE.death) == false)
        {
            SetState(eNPC_STATE.death);          
        }*/
    }

    public bool IsHit()
    {
        //if (IsState(eNPC_STATE.disappear))//Diapper Block.
        //    return false;

        if (IsState(ePLAYER_STATE.attack) || IsState(ePLAYER_STATE.skill))
        {
            return true;
        }

        return false;
    }

    public bool IsNotMove()
    {
        for (int i = 0; i < m_notMove.Length; i++)
        {
            if (IsState(m_notMove[i]))
                return true;
        }

        return false;
    }

    public bool IsState(ePLAYER_STATE _state)
    {
        if (curState == _state)
            return true;

        if (nextState == _state)
            return true;

        return false;
    }

    public bool IsEnableBeHit()
    {
        //if (Player.IsLife(m_npc) == false)
        //    return false;

        ////if (m_npc.getData.getHp <= 0)
        ////    return false;

        //if (m_npc.getMove.isStop == false)
        //    return false;

        ////if (IsState(eNPC_STATE.disappear))//Diapper Block.
        ////    return false;

        //if (IsHit())
        //    return false;

        //if (IsState(eNPC_STATE.stun) == true)
        //    return false;

        //if (IsState(eNPC_STATE.behit) == true)
        //    return false;

        return true;
    }
}
