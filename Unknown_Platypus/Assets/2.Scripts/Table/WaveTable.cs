using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public enum MonsterType
{
    NORMAL,
    BOSS,
}

[System.Serializable]
public class WaveTableData : RecordBase
{
    public int group;
    public int wave;
    public int startTime;
    public int duration;
    public float respawnTime;
    public MonsterType monsterType;
    public int monsterIdx;
    public int monsterLv;
    public string rewardIdx;
    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);
        group = FileUtil.Get<int>(_data, "group");
        wave = FileUtil.Get<int>(_data, "wave");
        startTime = FileUtil.Get<int>(_data, "startTime");
        respawnTime = FileUtil.Get<float>(_data, "respawnTime");
        duration = FileUtil.Get<int>(_data, "duration");
        monsterType = FileUtil.Get<MonsterType>(_data, "monsterType");
        monsterIdx = FileUtil.Get<int>(_data, "monsterIdx");
        monsterLv = FileUtil.Get<int>(_data, "monsterLv");
        rewardIdx = FileUtil.Get<string>(_data, "rewardIdx");

    }
}

public class WaveGroup
{
    public List<WaveTableData> m_list = new List<WaveTableData>();

    public WaveGroup() 
    {
        m_list.Clear();
    }

    public void Add(WaveTableData _data)
    {
        m_list.Add(_data);
    }
}


public class WaveTable : TTableBase<WaveTableData>
{

    private Dictionary<int, WaveGroup> m_dicGroup = new Dictionary<int, WaveGroup>();

    public WaveTable(ClassFileSave _save) : base("Table/WaveTable", _save)
    {

    }

    public WaveGroup GetGroupData(int _group)
    {
        if (m_dicGroup.ContainsKey(_group) == false)
            return null;

        return m_dicGroup[_group];
    }

    public override void Load()
    {
        base.Load();
        m_dicGroup.Clear();
        foreach (var table in m_recordList.getRecordList)
        {
            if(m_dicGroup.ContainsKey(table.group) == false) 
                m_dicGroup.Add(table.group, new WaveGroup());

            m_dicGroup[table.group].Add(table);
        }

    }

}
