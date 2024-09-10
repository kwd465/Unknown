using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public class SkillOptionTableData : RecordBase
{
    public SKILLOPTION_TYPE optionType;
    public float duration;
    public float value;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        optionType = FileUtil.Get<SKILLOPTION_TYPE>(_data, "optionType");
        duration = FileUtil.Get<float>(_data, "duration");
        value = FileUtil.Get<float>(_data, "value");
    }

}

public class SkillOptionTable : TTableBase<SkillOptionTableData>
{
    
    public SkillOptionTable(ClassFileSave _save) : base("Table/SkillOptionTable", _save)
    {

    }


}
