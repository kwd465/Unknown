using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Spine.Unity;
using UnityEditor;
using UnityEngine;

public class SkillMecaTurret : SkillObject
{
    
    [SerializeField]
    private Transform m_trBullet;

    [SerializeField]
    private SpineAnimation m_spineTop;
    [SerializeField]
    private SpineAnimation m_spineBottom;
   

    private int m_state = 0;
    private float m_checkTime = 0f;
    private float m_attackDealy = 0;
    [SerializeField]
    private TargetObjectRandomMove m_randomMove;


    public override void Apply()
    {
        base.Apply();
        m_state = 0;
        m_checkTime = 0;
        m_attackDealy = 0;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;
        m_attackDealy += Time.fixedDeltaTime;
        m_randomMove.UpdateLogic();


     
        if(m_attackDealy >= 0.5f)
        {
    

            Player _target = GameUtil.GetAreaTarget(m_owner ,m_area , m_distance, false, true);
            if(_target == null)
                return;


            Vector3 _dir = (_target.transform.position - transform.position).normalized;
            float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
            Effect _bullet  = EffectManager.instance.Play("MecaBullet", m_trBullet.position, Quaternion.AngleAxis(angle, Vector3.forward));
            SkillObject _obj = _bullet.GetComponent<SkillObject>();
            _obj.Init(m_skillData, _target, m_owner, _dir);

            m_attackDealy = 0;
            
        }

        if(m_checkTime >= m_duration)
            Close();
    }

    
}
