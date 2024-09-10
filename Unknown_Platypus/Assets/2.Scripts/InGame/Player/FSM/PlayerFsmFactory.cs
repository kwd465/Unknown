using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class PlayerFsmFactory
{
    public abstract PlayerFsm Create(Player _player);
}

public class PlayerFsm_User : PlayerFsmFactory
{
    public override PlayerFsm Create(Player _player)
    {
        PlayerFsm _fsm = new PlayerFsm(_player);
        _fsm.AddFsm(new PlayerState_Idle(_player));
        _fsm.AddFsm(new PlayerState_Move(_player));
        _fsm.AddFsm(new PlayerState_IdleAttack(_player));
        _fsm.AddFsm(new PlayerState_MoveAttack(_player));
        _fsm.AddFsm(new PlayerState_Die(_player));
        return _fsm;
    }
}

public class PlayerFsm_Monster : PlayerFsmFactory
{
    public override PlayerFsm Create(Player _player)
    {
        PlayerFsm _fsm = new PlayerFsm(_player);
        _fsm.AddFsm(new MonsterState_Move(_player));
        _fsm.AddFsm(new MonsterState_Die(_player));
        _fsm.AddFsm(new MonsterState_Attack(_player));
        return _fsm;
    }
}




