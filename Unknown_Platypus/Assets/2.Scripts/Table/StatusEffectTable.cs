//using BH;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;

//[System.Serializable]
//public class StatusEffectTable : TableBase
//{
//    public List<StatusEffectData> StatusEffectDataList = new();
//}

//[System.Serializable]
//public class StatusEffectData : RecordBase
//{
//    public STATUS_EFFECT Status_Effect = STATUS_EFFECT.NONE;
//    public string name = "";

//    public override void LoadExcel(Dictionary<string, string> _data)
//    {
//        name = FileUtil.Get<string>(_data, "name");
//        Status_Effect = System.Enum.Parse<STATUS_EFFECT>(name);
//    }
//}