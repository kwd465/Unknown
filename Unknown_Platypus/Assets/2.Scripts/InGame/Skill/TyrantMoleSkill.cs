using System.Collections;
using System.Collections.Generic;
using BH;
using UnityEngine;

public class TyrantMoleSkill : SkillObject
{
    [SerializeField]
    private SkillCollisionChild[] m_Effects;

    [SerializeField]
    private TargetObjectRandomMove[] m_randomMove;


    private float m_checkTime = 0f;


    private void Awake()
    {
        foreach (var effect in m_Effects)
        {
            effect.gameObject.SetActive(false);
            effect.SetParent(this);
        }

        
        

    }


    override public void Apply()
    {
        base.Apply();
        m_checkTime = 0;
        for(int i = 0  ; i < m_count; i++)
        {
            m_Effects[i].gameObject.SetActive(true);
            m_Effects[i].SetColliderActive(true);
        }

        for(int i = m_count; i < m_Effects.Length; i++)
        {
            m_Effects[i].gameObject.SetActive(false);
            m_Effects[i].SetColliderActive(false);
        }

        for(int i = 0; i < m_randomMove.Length; i++)
        {
            m_randomMove[i].SetMoveSpeed(3f * (1 + m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.speed)));
        }

    }

    override public void UpdateLogic()
    {
        base.UpdateLogic();
        
        m_checkTime += Time.fixedDeltaTime;

        for(int i = 0  ; i < m_count; i++)
        {
            m_randomMove[i].UpdateLogic();
        }

        if(m_checkTime >= m_duration)
        {
            Close();
        }

       
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
         BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }


}
