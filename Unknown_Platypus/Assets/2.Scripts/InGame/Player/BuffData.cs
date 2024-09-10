using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using BH;

public class BuffData
{
    public int m_skillId;
    public SkillEffectData m_data;

    public float LastTime;

    public BuffData(int _skillId, SkillEffectData _data)
    {
        m_skillId = _skillId;
        m_data = _data;
        LastTime = m_data.skillEffectTime;
    }

    public void UpdateTime(float _deltaTime)
    {
        LastTime -= _deltaTime;
    }

}
