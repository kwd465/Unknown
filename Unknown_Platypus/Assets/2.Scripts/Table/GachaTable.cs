using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;


[System.Serializable]
public class GachaLevelGroupData
{
    public string group;
    public Dictionary<int, GachaGroupData> m_dataDic = new Dictionary<int, GachaGroupData>();


    public void ADD(GachaTableData _data)
    {
        if (m_dataDic.ContainsKey(_data.lv) == false)
            m_dataDic.Add(_data.lv, new GachaGroupData());

        m_dataDic[_data.lv].ADD(_data);
    }

    public void SetPercent()
    {
        foreach(var data in m_dataDic.Values)
        {
            data.SetPercent();
        }
    }

    public GachaTableData GetGachaItem(int _lv = 0)
    {
        if (m_dataDic.ContainsKey(_lv) == false)
        {
#if DEBUG_LOG
            Debug.LogWarning("Lv GachaGroupData Null :" + _lv);
#endif
            return null;
        }

        return m_dataDic[_lv].GetGachaItem();
    }
}


[System.Serializable]
public class GachaGroupData
{
    public ItemType itemType;
    public string group;
    public int totalPercent;
    public float totlaRatioPer;
    public List<GachaTableData> m_dataList = new List<GachaTableData>();
    public int skillMaxValue;

    public void ADD(GachaTableData _data)
    {
        if(m_dataList.Count > 0 && m_dataList.Find(item => item.index.Equals(_data.index)) != null)
        {
#if DEBUG_LOG
            Debug.LogError("GachaTableData Same Index :" + _data.index);
#endif
            return;
        }

        m_dataList.Add(_data);
        totalPercent += _data.percent;
    }

    public void SetPercent()
    {
        totlaRatioPer = 0;
        foreach (var _data in m_dataList)
        {
            _data.ratio = (float)_data.percent / totalPercent * 100f;
            totlaRatioPer += _data.ratio;
            _data.ratioPer = totlaRatioPer;
        }
        skillMaxValue = m_dataList.Count;
        itemType = m_dataList[0].itemType;
    }

    public GachaTableData GetGachaItem()
    {
        GachaTableData result = null;
        
        float range = Random.Range(0f, totlaRatioPer);
        foreach (var _data in m_dataList)
        {
            if (_data.ratioPer >= range)
            {
                result = _data;
                break;
            }
        }

        return result;
    }
}

[System.Serializable]
public class GachaTableData : RecordBase
{
    public string group;
    public int lv;        
    public int percent;
    public float ratioPer;
    public float ratio;
    public ItemType itemType;
    public int itemidx;
    public int itemcount;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        group = FileUtil.Get<string>(_data, "group");
        lv = FileUtil.Get<int>(_data, "level");
        percent = FileUtil.Get<int>(_data, "percent");
        itemType = FileUtil.Get<ItemType>(_data, "itemType");
        itemidx = FileUtil.Get<int>(_data, "itemidx");
        itemcount = FileUtil.Get<int>(_data, "itemcount");
    }
}

public class GachaTable : TableBase
{

    public List<GachaLevelGroupData> m_GroupList = new List<GachaLevelGroupData>();

    public GachaTable(ClassFileSave _save) : base("Table/GachaTable", _save)
    {
    }

    public GachaTableData GetGacha(string _groupKey)
    {
        GachaLevelGroupData _levelData = m_GroupList.Find(item => item.group.Equals(_groupKey.ToString()));

        if (_levelData == null)
            return null;

        return _levelData.GetGachaItem();
    }


    public override void Load()
    {
        m_GroupList = (List<GachaLevelGroupData>)m_fileSave.LoadRes(getPath);
    }

    public override void Write()
    {
        m_fileSave.Save(m_fileSave.GetResPath(getPath), m_GroupList);
    }


    public override void LoadExcel(string _sheet, List<Dictionary<string, string>> _data)
    {
        m_GroupList.Clear();
        for(int i = 0; i < _data.Count; ++i)
        {
            Dictionary<string, string> _dicData = _data[i];
            GachaTableData _record = new GachaTableData();
            _record.LoadExcel(_dicData);

            GachaLevelGroupData _groupData = null;

            if(m_GroupList.Count > 0)
                _groupData = m_GroupList.Find(item => item.group.Equals(_record.group));

            if (_groupData == null)
            {
                _groupData = new GachaLevelGroupData() { group = _record.group };
                m_GroupList.Add(_groupData);
            }

            _groupData.ADD(_record);
        }

        foreach (var group in m_GroupList)
        {
            group.SetPercent();
        }
    }
}
