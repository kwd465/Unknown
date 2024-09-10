using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

public enum Conditiontype
{
    StageClear,
    Lv
}

public enum StageAttribute
{
    None,
    Fire,
    Water,
    Earth,
    Wind,
}

[System.Serializable]
public class StageTableData : RecordBase
{
    public int name;
    public int desc;
    public string image;
    public Conditiontype conditionType;
    public int rewardItem;
    public int rewardCount;
    public StageAttribute attribute;
    public int stageeffect;
    public int wavegroup;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);
        name = FileUtil.Get<int>(_data, "name");
        desc = FileUtil.Get<int>(_data, "desc");
        image = FileUtil.Get<string>(_data, "image");
        conditionType = FileUtil.Get<Conditiontype>(_data, "conditionType");
        rewardItem = FileUtil.Get<int>(_data, "rewardItem");
        rewardCount = FileUtil.Get<int>(_data, "rewardCount");
        attribute = FileUtil.Get<StageAttribute>(_data, "attribute");
        stageeffect = FileUtil.Get<int>(_data, "stageeffect");
        wavegroup = FileUtil.Get<int>(_data, "wavegroup");
    }
}

public class StageTable : TTableBase<StageTableData>
{
    public StageTable(ClassFileSave _save) : base("Table/StageTable", _save)
    {
    }


}
