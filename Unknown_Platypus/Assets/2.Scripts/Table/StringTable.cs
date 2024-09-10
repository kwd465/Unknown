
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public class StringTableData : RecordBase
{
    public string KR;
    public string EN;
    public string JP;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);
        KR = FileUtil.Get<string>(_data, "KR");
        EN = FileUtil.Get<string>(_data, "EN");
        JP = FileUtil.Get<string>(_data, "JP");
    }
}

public class StringTable : TTableBase<StringTableData>
{
    public StringTable(ClassFileSave _save) : base("Table/StringTable", _save)
    {
    }
}
