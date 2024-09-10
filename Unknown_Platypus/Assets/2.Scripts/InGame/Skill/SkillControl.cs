using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillControl : BHSingleton<SkillControl>
{

    public override void Init()
    {
        base.Init();
    }

    public int GetSkillHitCount(Player _owner, SkillTableData _skillData)
    {
        int _count = 1;
        if (_skillData == null)
            return _count;

        if (_skillData.skillHitCount > 0)
            _count = _skillData.skillHitCount;

        return _count;
    }

    public float GetSkillArea(Player _owner, SkillTableData _data)
    {
        return _data.skillArea;

        //double _lv = GetSkillLevel(_owner, _data);
        //double _incCount = Math.Truncate(_lv / _data.skillAreaIncLv);
        //float _result = _data.skillArea + (float)(_data.skillAreaInc * _incCount);
        //return _result;
    }

    public float GetSkillDistance(Player _owner, SkillTableData _data)
    {
        return _data.skillDistance;
        //double _lv = GetSkillLevel(_owner, _data);

        //double _incCount = Math.Truncate(_lv / _data.skillDistanceIncLv);
        //float _result = _data.skillDistance + (float)(_data.skillDistanceInc * _incCount);
        //return _result;
    }

}
