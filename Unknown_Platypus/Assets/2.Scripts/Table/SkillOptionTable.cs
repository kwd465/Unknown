using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public class SkillOptionTableData : RecordBase
{
    public int Index;
    public SKILLOPTION_TYPE optionType;
    public float duration;
    public float value;
    public string Comment;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        optionType = FileUtil.Get<SKILLOPTION_TYPE>(_data, "optionType");
        duration = FileUtil.Get<float>(_data, "duration");
        value = FileUtil.Get<float>(_data, "value");
        Comment = FileUtil.Get<string>(_data, "comment");
        Index = FileUtil.Get<int>(_data, "index");
    }

}

public class SkillOptionTable : TTableBase<SkillOptionTableData>
{
    private Dictionary<int, SkillOptionTableData> optionDict = new();

    public SkillOptionTable(ClassFileSave _save) : base("Table/SkillOptionTable", _save)
    {

    }

    public SkillOptionTableData GetSkillOptionData(int _index)
    {
        if(optionDict.TryGetValue(_index ,out var data) is false)
        {
            Debug.LogError($@"{_index} not exist index");
            return null;
        }

        return data;
    }

    public override void Load()
    {
        base.Load();

        optionDict = new();

        foreach (var data in getRecordList)
        {
            optionDict.Add(data.Index, data);
        }
    }
}
