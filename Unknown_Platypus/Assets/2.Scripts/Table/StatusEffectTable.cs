using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows;
using System.Linq;
using Unity.VisualScripting;

[System.Serializable]
public class StatusEffectTable : TTableBase<StatusEffectData>
{
    //public Dictionary<STATUS_EFFECT, Dictionary<float, StatusEffectData>> StatusEffectDataDict = new();
    Dictionary<STATUS_EFFECT, Dictionary<float, StatusEffectData>> statusEffectDict = new();

    public StatusEffectTable(ClassFileSave _save) : base("Table/StatusEffectTable", _save)
    {

    }

    public StatusEffectData GetStatusEffect(STATUS_EFFECT _effect, float _duration)
    {
        if (statusEffectDict.TryGetValue(_effect, out var timedict) is false)
        {
            Debug.LogError($@"not exist {_effect}");
            return null;
        }

        if (timedict.TryGetValue(_duration, out var data) is false)
        {
            Debug.LogError($@"not exist {_effect} {_duration}");
            return null;
        }

        return data;
    }


    public override void Load()
    {
        base.Load();

        //var dataList = (List<StatusEffectData>)m_fileSave.LoadRes(getPath);
        
        //StatusEffectDataDict = new();
        //Debug.Log("여기 오긴하냐");
        //foreach(var effect in getRecordList)
        //{
        //    if(StatusEffectDataDict.TryGetValue(effect.Status_Effect ,out var existDict) is false)
        //    {
        //        StatusEffectDataDict.Add(effect.Status_Effect, new());
        //    }

        //    if (StatusEffectDataDict[effect.Status_Effect].TryGetValue(effect.Duration ,out var existData) is false)
        //    {
        //        StatusEffectDataDict[effect.Status_Effect].Add(effect.Duration, effect);
        //    }
        //}

        //for (int i = 0; i < dataList.Count; i++)
        //{
        //    if (StatusEffectDataDict.TryGetValue(dataList[i].Status_Effect, out var existDict) is false)
        //    {
        //        StatusEffectDataDict.Add(dataList[i].Status_Effect, new());
        //    }

        //    if (StatusEffectDataDict[dataList[i].Status_Effect].TryGetValue(dataList[i].Duration, out var existData) is false)
        //    {
        //        StatusEffectDataDict[dataList[i].Status_Effect].Add(dataList[i].Duration, dataList[i]);
        //    }
        //    else
        //    {
        //        Debug.LogError(@$"ㅇ있으면  그게 문제 {dataList[i].Status_Effect} {dataList[i].Duration}");
        //    }
        //}
    }

    public override void Write()
    {
        //var dataList = new List<StatusEffectData>();

        //foreach (var durationDict in StatusEffectDataDict.Values)
        //{
        //    foreach (var data in durationDict.Values)
        //    {
        //        dataList.Add(data);
        //    }
        //}
        //m_fileSave.Save(m_fileSave.GetResPath(getPath), dataList);
    }

    public override void LoadExcel(string _sheet, List<Dictionary<string, string>> _data)
    {
        //    StatusEffectDataDict = new();

        //    for (int i = 0; i < _data.Count; ++i)
        //    {
        //        Dictionary<string, string> _dicData = _data[i];
        //        StatusEffectData data = new();
        //        data.LoadExcel(_dicData);

        //        if(StatusEffectDataDict.TryGetValue(data.Status_Effect , out var existDict) is false)
        //        {
        //            StatusEffectDataDict.Add(data.Status_Effect, new());
        //        }

        //        if (StatusEffectDataDict[data.Status_Effect].TryGetValue(data.Duration , out var existData) is false)
        //        {
        //            StatusEffectDataDict[data.Status_Effect].Add(data.Duration, data);
        //        }
        //        else
        //        {
        //            StatusEffectDataDict[data.Status_Effect][data.Duration] = data;
        //        }
        //    }
    }
}

[System.Serializable]
public class StatusEffectData : RecordBase
{
    public STATUS_EFFECT Status_Effect = STATUS_EFFECT.NONE;
    public string name = "";
    public float Duration 
    {
        get
        {
            if(value == null || value.Count <= 0)
            {
                return 0;
            }
            return value[1];
        }
    }
    public List<float> value;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        name = FileUtil.Get<string>(_data, "name");
        //Duration= FileUtil.Get<float>(_data, "duration");
        //Status_Effect = FileUtil.Get<STATUS_EFFECT>(_data, "STATUS_EFFECT");
        Status_Effect = System.Enum.Parse<STATUS_EFFECT>(name);
        string stringValue = FileUtil.Get<string>(_data, "value");
        
        // 안전하게 TryParse 사용 (숫자 변환 실패는 Skip)
        List<float> safeNumbers = stringValue
            .Split(';')
            .Select(s => {
                bool ok = float.TryParse(s, out float v);
                return (ok, v);
            })
            .Where(tuple => tuple.ok)
            .Select(tuple => tuple.v)
            .ToList();

        value = safeNumbers;
    }
}