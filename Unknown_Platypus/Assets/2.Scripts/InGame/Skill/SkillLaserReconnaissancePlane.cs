using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

public class SkillLaserReconnaissancePlane : SkillObject
{
    

    [SerializeField]
    private Transform[] m_trLaser;
    [SerializeField]
    private Transform[] m_trLaserHit;

    [SerializeField]
    private Transform m_trPlane;


    private int m_curState = 0;     //0 : 대기, 1 : 공격
    private float m_waitTime = 0;
    private float m_attackTime = 0; 
    float m_tickTime = 0.3f;
    private float m_attackDealy = 0.3f; //공격 타임? 데미지 들어가는 시간?

    private List<TargetPlayer> m_targetList = new List<TargetPlayer>();


    private void Awake()
    {
        for(int i = 0; i < m_trLaser.Length; i++)
        {
            m_trLaser[i].gameObject.SetActive(false);
            m_trLaserHit[i].gameObject.SetActive(false);
        }
    }

    
    public override void Apply()
    {
        base.Apply();

        transform.SetParent(m_owner.transform);
        transform.rotation = Quaternion.identity;
        transform.localPosition = Vector3.zero;
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
                        
            if(m_attackTime >= m_duration)
            {
                m_curState = 0;
                m_attackTime = 0;
                for(int i = 0; i < m_trLaser.Length; i++)
                {
                    m_trLaser[i].gameObject.SetActive(false);
                    m_trLaserHit[i].gameObject.SetActive(false);
                }

                return;
            }

            
            Player m_target =GameUtil.GetAreaTarget(Owner ,m_distance,m_distance, false);
            
            if(m_target == null)
            {
                return;
            }
            
            m_attackTime += Time.fixedDeltaTime;


            Vector3 _dir = (m_target.transform.position - transform.position).normalized;
            // 이동 방향의 각도를 구합니다.
            float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
            // 오브젝트의 회전 각도를 설정합니다.
            m_trPlane.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
           

            // 레이저 발사
            float _dis = m_distance;
            for(int i = 0; i < m_trLaser.Length; i++)
            {
                m_trLaser[i].gameObject.SetActive(true);
                m_trLaser[i].localScale = new Vector3(_dis * 0.1f, 1, 1);

                m_trLaserHit[i].gameObject.SetActive(true);
                m_trLaserHit[i].localPosition = new Vector3(_dis, 0, 0);
            }
           

            for(int i = 0 ; i < m_targetList.Count; i++)
            {
            m_targetList[i].UpdateLogic(Time.fixedDeltaTime);
                if(m_targetList[i].CheckTime() && m_targetList[i].m_target != null &&
                m_targetList[i].m_target.getData.IsDead() == false)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_targetList[i].m_target);
                    m_targetList[i].Apply();
                }
            }



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
