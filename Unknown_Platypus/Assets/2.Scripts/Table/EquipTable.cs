using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;
using JetBrains.Annotations;

[System.Serializable]
public enum e_EquipType
{
    weapon,
    armor,
    ring,
    boots,
    amulet,
    helmet,
}

[System.Serializable]
public enum e_EquipGrade
{
    normal,
    rare,
    unique,
    legend,
}

[System.Serializable]
public class EquipStatData
{
    public eSTAT stat;
    public e_StatType statType;
    public float value;
}



[System.Serializable]
public class EquipTableData : RecordBase
{

    public string image;
    public e_EquipType equipType;
    public e_EquipGrade grade;
    public float area;
    public float coolTime;
    public List<EquipStatData> equipStatDatas = new List<EquipStatData>();
    public List<int> equipSkills = new List<int>();

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        image = FileUtil.Get<string>(_data, "image");
        equipType = FileUtil.Get<e_EquipType>(_data, "equipType");
        grade = FileUtil.Get<e_EquipGrade>(_data, "grade");
        area = FileUtil.Get<float>(_data, "area");
        coolTime = FileUtil.Get<float>(_data, "coolTime");


        for (int i = 1; i < 4; i++)
        {
            eSTAT stat = FileUtil.Get<eSTAT>(_data, "stat_" + i);

            if (stat == eSTAT.none)
                continue;

            EquipStatData effectData = new EquipStatData();
            effectData.stat = stat;
            effectData.statType = FileUtil.Get<e_StatType>(_data, "e_statType_" + i);
            effectData.value = FileUtil.Get<float>(_data, "statValue_" + i);
            equipStatDatas.Add(effectData);
        }

        int _skill = FileUtil.Get<int>(_data, "skill1");
        if (_skill != 0)
            equipSkills.Add(_skill);
        _skill = FileUtil.Get<int>(_data, "skill2");
        if (_skill != 0)
            equipSkills.Add(_skill);
        _skill = FileUtil.Get<int>(_data, "skill3");
        if(_skill != 0)
            equipSkills.Add(_skill);

    }
}

public class EquipTable : TTableBase<EquipTableData>
{
    public EquipTable(ClassFileSave _save) : base("Table/EquipTable", _save)
    {
    }

}
