using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Unity.VisualScripting;

public enum SKILLOPTION_TYPE
{
    none,
    distance,
    coolTime,
    damage,
    cri,
    criDam,
    count,
    speed,
    duration,
    multyDamage,
    area,
    bossdamage,
    bossCri,
    bossCirDam,
    resetCoolTime,
    piercingDamage,
    debuff_movespeed,
}

public class SkillEffect
{
    public bool isBaseSkill = false;
    public SkillTableData m_skillTable;
    public float m_coolTime;
    public bool m_isUpdateCool;
    public Player m_ownerData;
    public Action<SkillEffect> m_updateCallBack;


    public Dictionary<SKILLOPTION_TYPE , float> m_dicCurSelectOption = new Dictionary<SKILLOPTION_TYPE, float>();



    public bool m_isReady;

    public float CoolTimeNormalized
    {
        get
        {
            if (m_skillTable == null)
                return 0f;

            return m_coolTime / m_skillTable.coolTime;
        }
    }


    public SkillEffect(SkillTableData _skillTable, Player _ownerData, bool _isBaseSkill = false)
    {
        m_dicCurSelectOption.Clear();
        isBaseSkill = _isBaseSkill;
        m_skillTable = _skillTable;
        m_ownerData = _ownerData;
        m_coolTime = 0;
        m_isUpdateCool = true;
        if(_isBaseSkill){
            m_isReady = false;
        }else
        {
            m_isReady = true;
        }
        
    }

    /// <summary>
    /// 스킬 업데이트 데이터 설정 
    /// </summary>
    /// <param name="_skillTable">스킬 테이블</param>
    /// <param name="_selectOption">선택한 옵션</param>
    /// <param name="_value">선택한 옵션 값</param>
    public void SetUpdateData(SkillTableData _skillTable , SKILLOPTION_TYPE _selectOption = SKILLOPTION_TYPE.none, float _value = 0)
    {
        m_skillTable = _skillTable;   

        if(_selectOption == SKILLOPTION_TYPE.none || _value == 0)
            return;

        if(m_dicCurSelectOption.ContainsKey(_selectOption))
            m_dicCurSelectOption[_selectOption] += _value;
        else
            m_dicCurSelectOption.Add(_selectOption , _value);
    }


    public virtual void UseSkill()
    {
        m_coolTime = 0f;
        m_isReady = false;
    }

    public virtual void UpdateSkill()
    {
        if (m_isUpdateCool == false)
            return;

        if (m_isReady)
            return;

        if (m_coolTime < m_skillTable.coolTime)
            m_coolTime += Time.fixedDeltaTime;
        else
            m_isReady = true;

        m_updateCallBack?.Invoke(this);
    }

    public float GetOptionValue(SKILLOPTION_TYPE _option)
    {
        if (m_dicCurSelectOption.ContainsKey(_option))
            return m_dicCurSelectOption[_option];
        else
            return 0;
    }

    public float GetBaseAddValue(SKILLOPTION_TYPE _option)
    {
        if (m_skillTable == null)
            return 0;
        float _value = GetOptionValue(_option);
        switch (_option)
        {
            case SKILLOPTION_TYPE.distance:
                return  m_skillTable.skillDistance * (1 + _value);
            case SKILLOPTION_TYPE.coolTime:
                return m_skillTable.coolTime * (1 - _value);
            case SKILLOPTION_TYPE.count:
                return m_skillTable.skillTargetCount + _value;
            case SKILLOPTION_TYPE.duration:
                return m_skillTable.duration + _value;
            case SKILLOPTION_TYPE.area:
                return m_skillTable.skillArea * (1+ _value);
            case SKILLOPTION_TYPE.speed:
                return _value;
            default:
                return _value;
        }
    }


}

