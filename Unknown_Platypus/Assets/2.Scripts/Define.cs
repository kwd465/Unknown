using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum ePLAYER_STATE
{
    none,
    appear,
    idle,
    idle_Attack,
    attack,
    skill,
    skill_repeat,
    death,
    stun,
    move,
    move_Attack,
    //disappear,
    victory,
    lose,
    freeze,
    hold,
    dash_attack,
    patrol,
    KnockBack,
    wait,

}

[System.Serializable]
public enum eSTAT
{
    none,
    atk,
    atks,
    def,
    hp,
    hpregen,
    movespeed,
    cri,
    goldup,
    cooltime,
    itemrange
}

[System.Serializable]
public enum e_PlayerType
{
    CHAR,
    MON,
    MON_IGNORE, //공격을 받지 않는 몹
    MON_BOSS,
    PVPAI,
}


[System.Serializable]
public enum ItemType
{
    PROPERTY,
    STUFF,
}

[System.Serializable]
public enum ItemSubType
{
    FREECASH,
    CASH,
    GOLD,
    EXP,

}

public enum eDUMMY
{
    none,
    npc = 1,
    around = 2,
    WeaponTop = 3,
    Height = 4,
    body = 5,
    center = 6,
    WeaponTop_1 = 7,
    camTarget = 8,
    follow = 9,
    weapon = 10,
    weapon_1 = 11,
    max,
}

public static class Define
{
    static readonly public string TAG_DROP_ITEM = "DropItem";
    static public float timeScale = 1f;

    static readonly public string Move = "run";
    static readonly public string Idle = "idle";
    static readonly public string MoveAttack = "run_attack";
    static readonly public string IdleAttack = "idle_attack";

    static readonly public string TAG_MONSTER = "Monster";
    static readonly public string TAG_PLAYER = "Player";
}
