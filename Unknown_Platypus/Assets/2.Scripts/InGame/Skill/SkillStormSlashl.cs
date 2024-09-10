using System;
using System.Collections;
using System.Collections.Generic;
using BH;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;

public class SkillStormSlashl : SkillObject
{

    [SerializeField]
    private SkillCollisionChild m_collisionChild;

    private List<TargetPlayer> m_targetList = new List<TargetPlayer>();

    float m_tickTime = 0;
    float elapsedTime;

    private void Awake()
    {
        m_collisionChild.SetParent(this);
        m_collisionChild.SetColliderActive(false);
    }

    public override void Apply()
    {
        base.Apply();
        m_targetList.Clear();
        transform.position = m_owner.transform.position + m_owner.m_inputVec.normalized*m_distance;
        m_tickTime = m_count / m_duration;
        elapsedTime = 0;
        m_collisionChild.SetColliderActive(true);
        m_collisionChild.targetList.Clear();
        transform.localScale = new Vector3(m_area ,m_area , 1f);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        
        float _deltiTime = Time.fixedDeltaTime;
        elapsedTime += _deltiTime;

        
        for(int i = 0 ; i < m_targetList.Count; i++)
        {
            m_targetList[i].UpdateLogic(_deltiTime);
            if(m_targetList[i].CheckTime() && m_targetList[i].m_target != null &&
            m_targetList[i].m_target.getData.IsDead() == false)
            {
                 BattleControl.instance.ApplySkill(m_skillData, m_owner, m_targetList[i].m_target);
                 m_targetList[i].Apply();
            }
        }




        if (elapsedTime >= m_duration)
        {
            elapsedTime = 0;
            gameObject.SetActive(false);
            m_collisionChild.SetColliderActive(false);
            m_targetList.Clear();
            m_collisionChild.targetList.Clear();
        }

    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        Player _player = collision.GetComponent<Player>();
        BattleControl.instance.ApplySkill(m_skillData, m_owner, _player);

        m_targetList.Add(new TargetPlayer(_player, m_tickTime));

    }

    public override void OnTriggerExitChild(Collider2D collision)
    {
        Player _player = collision.GetComponent<Player>();
        TargetPlayer _targetPlayer = m_targetList.Find(item=>item.m_target == _player);

        if(_targetPlayer != null)
            m_targetList.Remove(_targetPlayer);    
        
    }

}
