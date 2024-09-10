using System.Collections;
using System.Collections.Generic;
using BH;
using UnityEngine;

public class SkillMeteo : SkillObject
{
    [SerializeField]
    private SkillCollisionChild[] m_Effects;

    private int m_curObject= 0;
    private int m_objectCount = 0;
    private float m_delayTime = 0.5f;
    private float m_checkTime= 0;

    private void Awake()
    {
        foreach (var effect in m_Effects)
        {
            effect.gameObject.SetActive(false);
            effect.SetParent(this);
        }
    }

    public override void Apply()
    {
        base.Apply();

        m_checkTime = 0;
        m_curObject =0;
        m_delayTime = 0.5f;
        m_objectCount = m_count;
        for (int i = 0; i < m_count; i++)
        {
            m_Effects[i].SetColliderActive(false);
            m_Effects[i].transform.position = (Vector2)m_owner.transform.position + Random.insideUnitCircle.normalized * m_skillData.m_skillTable.skillDistance;
            m_Effects[i].SetArea(m_skillData.m_skillTable.skillArea);
        }
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_delayTime -= Time.fixedDeltaTime;
        m_checkTime += Time.fixedDeltaTime;
        if(m_delayTime <= 0 && m_curObject < m_objectCount)
        {
            m_delayTime = 0.5f;
            m_Effects[m_curObject].gameObject.SetActive(true);
            m_Effects[m_curObject].DelaySetActive(true , 1f);
            m_curObject++;
        }

        if (m_checkTime >= m_duration)
        {
             foreach (var effect in m_Effects)
            {
                effect.gameObject.SetActive(false);
            }
            Close();
        }
    }

    override public void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }

}
