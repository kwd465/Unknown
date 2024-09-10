using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

public class MonsterTable : TTableBase<CharacterTableData>
{
    public MonsterTable(ClassFileSave _save) : base("Table/MonsterTable", _save)
    {
    }
}
