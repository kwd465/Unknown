using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class SkillSatelliteItem : MonoBase
{

    [SerializeField]
    private Transform m_trBullet;
    
    private int m_curState = 0;     //0 : 대기, 1 : 공격
    private float m_waitTime = 0;
    private float m_attackTime = 0; 
    private float m_attackDealy = 0;
    private SkillObject m_parent;

    private Player m_target;

    public virtual void Open(SkillObject _parent)
    {
        base.Open();
        m_parent = _parent;
        
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if(m_curState == 0)
        {
            m_waitTime += Time.fixedDeltaTime;
            if(m_waitTime >= 1.5f)
            {
                m_curState = 1;
                m_waitTime = 0;
            }
        }
        else if(m_curState == 1)
        {
            m_attackTime += Time.fixedDeltaTime;
            m_attackDealy += Time.fixedDeltaTime;
            if(m_attackTime >= m_parent.m_duration)
            {
                m_curState = 0;
                m_attackTime = 0;
            }

            if(m_attackDealy >= 0.3f)
            {
                
            
                m_target =GameUtil.GetAreaTarget(m_parent.Owner ,m_parent.m_distance ,m_parent.m_distance, false);
                
                if(m_target == null || m_target.getData.HP <= 0)
                {
                    return;
                }
                
                Vector3 _dir = (m_target.transform.position - transform.position).normalized;
                // 이동 방향의 각도를 구합니다.
                float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
                // 오브젝트의 회전 각도를 설정합니다.
                transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
                Effect _bullet = EffectManager.instance.Play("SatelliteBullet" , m_trBullet.position , Quaternion.AngleAxis(angle, Vector3.forward));
                SkillObject _obj = _bullet.GetComponent<SkillObject>();
                _obj.Init(m_parent.SkillEffect, _target:null, m_parent.Owner, _dir);       
                m_attackDealy = 0;      
            }

        }
    }
}
