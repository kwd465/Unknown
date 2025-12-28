using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class SkillSatelliteItem : MonoBase
{
    [SerializeField]
    private Transform m_trBullet;
    [SerializeField] ParticleSystem ShootParticle;

    private int m_curState = 0;     //0 : 대기, 1 : 공격
    private float m_waitTime = 0;
    private float m_attackTime = 0;
    private float m_attackDealy = 0;
    private SkillObject m_parent;
    Vector3 dir = Vector3.zero;
    //private Player m_target;

    public virtual void Open(SkillObject _parent)
    {
        base.Open();
        m_parent = _parent;
        ShootParticle.gameObject.SetActive(true);
        ShootParticle.Stop();
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
        
        if (m_parent.Owner.inputVec.normalized != Vector3.zero)
        {
            dir = m_parent.Owner.inputVec.normalized;
        }

        // 이동 방향의 각도를 구합니다.
        float angle = Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg;
        // 오브젝트의 회전 각도를 설정합니다.
        transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);

        if (m_curState == 0)
        {
            m_waitTime += Time.fixedDeltaTime;
            if (m_waitTime >= 1.5f)
            {
                m_curState = 1;
                m_waitTime = 0;
            }
        }
        else if (m_curState == 1)
        {
            m_attackTime += Time.fixedDeltaTime;
            m_attackDealy += Time.fixedDeltaTime;
            if (m_attackTime >= m_parent.m_duration)
            {
                m_curState = 0;
                m_attackTime = 0;
            }

            if (m_attackDealy >= 0.3f)
            {
                Effect _bullet = EffectManager.instance.Play("SatelliteBullet", m_trBullet.position, Quaternion.AngleAxis(angle, Vector3.forward));
                SkillBullet _obj = _bullet.GetComponent<SkillBullet>();
                _obj.InitWithOutTarget(m_parent.SkillEffect, dir * 100, m_trBullet.position, m_parent.Owner, dir, 1, false, false, _isHitedClose: true);
                ShootParticle.Play();
                _obj = null;

                m_attackDealy = 0;
            }
        }
    }
}