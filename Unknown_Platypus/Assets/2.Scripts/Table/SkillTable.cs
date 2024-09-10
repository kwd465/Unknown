using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;
using Unity.VisualScripting;

[System.Serializable]
public enum e_SkillType
{
    InGameSkill,
    EquipSkill,
    CharacterSkill,
}

[System.Serializable]
public enum e_SkillSubType
{
    Active,
    Auto,
    Passive,
    Upgrade
}


[System.Serializable]
public enum e_SkillEffect
{
    none,
    damage,
    piercedamage,
    buff,
    debuff
}


[System.Serializable]
public enum e_SkillEffectType
{
    atk,
    def,
    cri,
    hp,
    movespeed,
    atks,
    hpregen,
}

[System.Serializable]
public enum e_SkillAreaType
{
    Box,            //�簢��
    SemiCircle,     //�ݿ�
    Circle,         //��
    Sector,         //��ä��
    Projectile,     //�߻�ü
    Drop,           //�������� ����
}

[System.Serializable]
public enum e_StatType
{
    add,
    mul,
}


[System.Serializable]
public class SkillEffectData
{
    public e_SkillEffect skillEffect;
    public e_SkillEffectType skillEffectType;
    public e_StatType statType;
    public float skillEffectValue;
    public float skillEffectTime;
}



[System.Serializable]
public class SkillTableData : RecordBase
{

    public e_SkillType skillType;
    public e_SkillSubType skillSubType;
    public e_SkillAreaType skillAreaType;
    
    public int group;
    public int skillName;
    public int skillDesc;
    public int skillSubDesc;
    public string skillicon;
    public int skilllv;
    public float skillDistance;
    public float skillArea;
    public int skillTargetCount;
    public int skillHitCount;
    public float coolTime;
    public float duration;
    public string effectPath;

    public List<SkillEffectData> skillEffectDataList;

    public List<int> skillOptionLiist;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);

        group = FileUtil.Get<int>(_data, "group");
        skillType = FileUtil.Get<e_SkillType>(_data, "skillType");
        skillSubType = FileUtil.Get<e_SkillSubType>(_data, "skillSubType");
        skillAreaType = FileUtil.Get<e_SkillAreaType>(_data, "skillAreaType");
        skillName = FileUtil.Get<int>(_data, "skillName");
        skillDesc = FileUtil.Get<int>(_data, "skillDesc");
        skillSubDesc = FileUtil.Get<int>(_data, "skillSubDesc");
        skillicon = FileUtil.Get<string>(_data, "skillicon");
        skilllv = FileUtil.Get<int>(_data, "skilllv");

        skillDistance = FileUtil.Get<int>(_data, "skillDistance");
        skillArea = FileUtil.Get<int>(_data, "skillArea");

        skillTargetCount = FileUtil.Get<int>(_data, "skillTargetCount");

        skillHitCount = FileUtil.Get<int>(_data, "skillHitCount");

        duration = FileUtil.Get<float>(_data, "duration");
        coolTime = FileUtil.Get<float>(_data, "coolTime");
        effectPath = FileUtil.Get<string>(_data, "effectPath");
        
        skillEffectDataList = new List<SkillEffectData>();

        for (int i = 1; i < 4; i++)
        {
            e_SkillEffect skillEffect = FileUtil.Get<e_SkillEffect>(_data, "skillEffect" + i);

            if (skillEffect == e_SkillEffect.none)
                continue;

            SkillEffectData effectData = new SkillEffectData();
            effectData.skillEffect = skillEffect;
            effectData.skillEffectType = FileUtil.Get<e_SkillEffectType>(_data, "skillEffectType" + i);
            effectData.statType = FileUtil.Get<e_StatType>(_data, "e_stat" + i);
            effectData.skillEffectValue = FileUtil.Get<float>(_data, "skillEffectValue" + i);
            effectData.skillEffectTime = FileUtil.Get<float>(_data, "skillEffectTime" + i);
            skillEffectDataList.Add(effectData);
        }

        string _skillOption = FileUtil.Get<string>(_data, "skillOption");
        if(string.IsNullOrEmpty(_skillOption) == false)
        {
            skillOptionLiist = new List<int>();
            string[] _optionList = _skillOption.Split(',');
            foreach (var option in _optionList)
            {
                skillOptionLiist.Add(int.Parse(option));
            }
        }

    }
}

public class SkillGroupData
{
    public int m_group;
    public List<SkillTableData> m_skillList = new List<SkillTableData>();
    
    public SkillGroupData(int _group)
    {
        m_group = _group;
    }

    

    public void Add(SkillTableData _data)
    {
        m_skillList.Add(_data);
    }

}

public class SkillTable : TTableBase<SkillTableData>
{
    private Dictionary<e_SkillType, List<SkillGroupData>> m_dicSkill = new Dictionary<e_SkillType, List<SkillGroupData>>();

    public SkillTable(ClassFileSave _save) : base("Table/SkillTable", _save)
    {

    }

    public List<SkillGroupData> GetSkillGroupList(e_SkillType _type)
    {
        if (m_dicSkill.ContainsKey(_type) == false)
            return null;

        return m_dicSkill[_type];
    }


    public override void Load()
    {
        base.Load();
        m_dicSkill.Clear();
        foreach (var skill in getRecordList)
        {
            
            if(m_dicSkill.ContainsKey( skill.skillType) == false)
                m_dicSkill.Add(skill.skillType, new List<SkillGroupData>());

            SkillGroupData _groupData = m_dicSkill[skill.skillType].Find(item => item.m_group == skill.group);
            if (_groupData == null)
            {
                _groupData = new SkillGroupData(skill.group);
                m_dicSkill[skill.skillType].Add(_groupData);
            }
            _groupData.Add(skill);
        }

    }


}
