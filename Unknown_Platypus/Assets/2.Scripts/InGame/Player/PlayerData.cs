using BH;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class StatValueData
{
    public double mulValue;
    public double addValue;

    public void SetValue(e_StatType _type, double _value)
    {
        if (_type == e_StatType.add)
            addValue += _value;
        else
            mulValue += _value;
    }

}



[System.Serializable]
public class StatData
{
    public eSTAT stat;
    public e_StatType type;
    public float baseValue;
    public float incValue;

    public StatData(eSTAT _stat, e_StatType _type, float _baseValue, float _incValue)
    {
        stat = _stat;
        type = _type;
        baseValue = _baseValue;
        incValue = _incValue;
    }
}


public class PlayerData
{
    protected int m_lv;
    protected e_PlayerType m_type;
    protected List<BuffData> m_FinishBuff = new List<BuffData>();
    protected List<SkillTableData> m_Skills = new List<SkillTableData>();
    protected Dictionary<eSTAT, double> _dicTotalStat = new Dictionary<eSTAT, double>();

    public List<BuffData> m_BuffList = new List<BuffData>();
    public List<BuffData> m_DeBuffList = new List<BuffData>();

    public int Lv => m_lv;

    public double HP { get; set; }
    public double MaxHP { get; set; }


    private CharacterTableData m_data;
    public CharacterTableData Table => m_data;

    public string m_rewardIdx;

    private int m_exp;

    public int Exp => m_exp;
    public int MaxExp => 10;

    public PlayerData(e_PlayerType _type, CharacterTableData _table)
    {
        m_lv = 1;
        m_exp = 0;
        m_type = _type;
        m_data = _table;
        HP = _table.hp;
        MaxHP = HP;
        m_Skills.Clear();
        RefreshData(eSTAT.hp);
        RefreshData(eSTAT.atk);
        RefreshData(eSTAT.atks);
        RefreshData(eSTAT.movespeed);
        RefreshData(eSTAT.def);
    }

    public PlayerData(e_PlayerType _type, CharacterTableData _table , string _rewardIdx , int _lv = 1)
    {
        m_exp = 0;
        m_type = _type;
        m_data = _table;
        HP = _table.hp;
        MaxHP = HP;
        m_Skills.Clear();
        m_lv = _lv;
        m_rewardIdx = _rewardIdx;
        RefreshData(eSTAT.hp);
        RefreshData(eSTAT.atk);
        RefreshData(eSTAT.atks);
        RefreshData(eSTAT.movespeed);
        RefreshData(eSTAT.def);
    }

  

    protected virtual void SetStat(eSTAT _stat, double _value)
    {
        if (_dicTotalStat.ContainsKey(_stat))
            _dicTotalStat[_stat] = _value;
        else
            _dicTotalStat.Add(_stat, _value);
    }

    public virtual void SetDamage(double _damage)
    {
        HP -= _damage;
    }

    public virtual void SetHeal(double _heal)
    {
        HP += _heal;
    }

    public virtual bool IsDead()
    {
        return HP <= 0;
    }

    public void AddExp(int _exp , Action<bool> _callBackLevelUp)
    {
        m_exp += _exp;

        if(m_type == e_PlayerType.CHAR)
        {
            //���� ���̺��� ��򰡿� �־�� �Ǵµ�?!
            //�ϴ� ���Ƿ� �־����
            if(m_exp >= 10)
            {
                m_lv++;
                m_exp = 0;
                _callBackLevelUp.Invoke(true);
            }else
                _callBackLevelUp.Invoke(false);
        }
    }

    public double GetStatValue(eSTAT _stat)
    {
        double _totalValue = 0;
        _dicTotalStat.TryGetValue(_stat, out _totalValue);
        return _totalValue;
    }

    public void AddBuff(int _skillID, SkillEffectData _data, bool isBuff)
    {
        //�ߺ� ������ �ð� �ʱ�ȭ
        if (isBuff)
        {
            BuffData _checkData = m_BuffList.Find(item => item.m_data == _data);
            if (_checkData != null)
            {
                _checkData.LastTime = _data.skillEffectTime;
                return;
            }
        }
        else
        {
            BuffData _checkData = m_DeBuffList.Find(item => item.m_data == _data);
            if (_checkData != null)
            {
                _checkData.LastTime = _data.skillEffectTime;
                return;
            }
        }

        BuffData _buffData = new BuffData(_skillID, _data);
        if (isBuff)
            m_BuffList.Add(_buffData);
        else
            m_DeBuffList.Add(_buffData);

        if (_data.skillEffectType.isStat())
            RefreshData(_data.skillEffectType.ToParseStat());
    }


    //Ư�� Ÿ�Ը� ���÷���
    public void RefreshData(eSTAT _type)
    {
        //StatValueData _EquipValue = GetEquipStatData(_type);
        //StatValueData _BuffValue = GetBuffStatData(_type);
        //StatValueData _DeBuffValue = GetDeBuffStatData(_type);
        //StatValueData _SkillValue = GetSkillStatData(_type);
        //StatValueData _SngValue = GetSngBuffData(_type);
        double totalValue = GetBaseStatData(_type);
        //double totalValue = (GetBaseStatData(_type) + _EquipValue.addValue + _BuffValue.addValue + _SkillValue.addValue + _SngValue.addValue - _DeBuffValue.addValue)
        //    * (1f + _EquipValue.mulValue + _BuffValue.mulValue + _SkillValue.mulValue + _SngValue.mulValue) * (1f - _DeBuffValue.mulValue);

        if (totalValue < 0)
            totalValue = 0;

        _dicTotalStat[_type] = totalValue;
    }

    public double GetBaseStatData(eSTAT _stat)
    {
        return m_data.GetStat(_stat);
    }



}
