using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillGravityfield : SkillObject
{
    [SerializeField]
    private RandomMove[] m_randomMove;

    private float m_checkTime;

    private int m_count;
    private float m_duration;
    private float m_distance;
    private void Awake()
    {
        for (int i = 0; i < m_randomMove.Length; i++)
        {
            m_randomMove[i].Close();
        }
    }

    public override void Apply()
    {
        base.Apply();
        m_checkTime = 0;
        m_duration = m_skillData.GetBaseAddValue( SKILLOPTION_TYPE.duration);
        m_distance = m_skillData.GetBaseAddValue( SKILLOPTION_TYPE.distance);
        m_count = (int)m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count);
        for (int i = 0; i < m_count; i++)
        {
            m_randomMove[i].Init(this, m_owner.transform.position,  m_distance);
            m_randomMove[i].Open();
        }
    }


    public override void UpdateLogic()
    {
        base.UpdateLogic();
        m_checkTime += Time.fixedDeltaTime;
        for (int i = 0; i <m_count; i++)
        {
            if (m_randomMove[i].gameObject.activeInHierarchy)
                m_randomMove[i].UpdateLogic();
        
        }

        if(m_checkTime >= m_duration)
        {
            Close();
        }


    }


    public override void OnTriggerEnterChild(Collider2D collision)
    {
        base.OnTriggerEnterChild(collision);
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }


}
