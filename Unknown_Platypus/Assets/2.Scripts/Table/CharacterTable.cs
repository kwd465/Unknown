using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public class CharacterTableData : RecordBase
{
    public int name;
    public int hp;
    public int atk;
    public int def;
    public float range;
    public float moveSpeed;
    public float attackSpeed;
    public WeaponStyle AttackType;
    public string prefab;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);
        name = FileUtil.Get<int>(_data , "name");
        hp = FileUtil.Get<int>(_data, "hp");
        atk = FileUtil.Get<int>(_data, "atk");
        def = FileUtil.Get<int>(_data, "def");
        range = FileUtil.Get<float>(_data, "range");
        moveSpeed = FileUtil.Get<float>(_data, "moveSpeed");
        attackSpeed = FileUtil.Get<float>(_data, "attackSpeed");
        AttackType = FileUtil.Get<WeaponStyle>(_data, "AttackType");
        prefab = FileUtil.Get<string>(_data, "prefab");
    }

    public float GetStat(eSTAT _stat)
    {
        switch (_stat)
        {
            case eSTAT.hp:
                return hp;
            case eSTAT.atk:
                return atk;
            case eSTAT.def:
                return def;
            case eSTAT.movespeed:
                return moveSpeed;
            case eSTAT.atks:
                return attackSpeed;
        }
        return 0;
    }


}

public class CharacterTable : TTableBase<CharacterTableData>
{

    public CharacterTable(ClassFileSave _save) : base("Table/CharacterTable", _save)
    {
    }

}
