using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillAstroCannon : SkillObject
{
    
    [SerializeField]
    private Transform m_trBullet;
    int m_state = 0;
    float m_checkTotalTime = 0;
    float m_checkTime;
    float m_attackDelay;

    float m_distance = 0;

    override public void Apply()
    {
        m_state = 0;
        m_checkTime = 0;
        m_attackDelay = 0;
        m_checkTotalTime = 0;
        m_distance = m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.distance);
        transform.position = (Vector2)m_owner.transform.position + (Random.insideUnitCircle * m_distance);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;
        m_checkTotalTime += Time.fixedDeltaTime;
        if(m_state == 0)
        {
            if(m_checkTime >= 2.5f)
            {
                m_state = 1;
                m_checkTime = 0;
            }
        }
        else if(m_state == 1)
        {
        
            m_attackDelay += Time.fixedDeltaTime;

            if(m_attackDelay >= 0.3f)
            {
                m_attackDelay = 0;
                Vector3 _dir = Vector2.right;
                Player _target = GameUtil.GetAreaTarget(m_owner, m_distance,m_distance, false);
                if(_target == null || _target.getData.HP <= 0)
                {
                    _target = GameUtil.GetNearestTarget(StagePlayLogic.instance.m_SpawnLogic.m_monList , m_owner);
                }

                if(_target != null)
                    _dir = (_target.transform.position - transform.position).normalized;
                // 이동 방향의 각도를 구합니다.
                float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
                
                Effect _bullet = EffectManager.instance.Play("AstroBullet" , m_trBullet.position , Quaternion.AngleAxis(angle, Vector3.forward));
                SkillObject _obj = _bullet.GetComponent<SkillObject>();
                _obj.Init(SkillEffect, _target:null, Owner, _dir);  

            }

            if(m_checkTime >= 3f)
            {
                m_state = 0;
                m_checkTime = 0;
            }
        }

        if(m_checkTotalTime >  SkillData.duration)
        {
            Close();
        }

    }

}
