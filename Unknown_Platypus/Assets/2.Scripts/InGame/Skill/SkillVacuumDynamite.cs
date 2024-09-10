using System.Collections;
using System.Collections.Generic;
using BH;
using Unity.VisualScripting;
using UnityEngine;

public class SkillVacuumDynamite : SkillObject
{
    

    [SerializeField]
    private SkillCollisionChild m_collisionChild;

    [SerializeField]
    private GameObject m_HitEffect;

    private int m_state = 0;

    float elapsedTime;

    private void Awake()
    {
        m_collisionChild.SetParent(this);
        m_collisionChild.SetColliderActive(false);
        m_HitEffect.SetActive(false);
    }

    [SerializeField]
    private bool isShowIndicator;
    [SerializeField]
    private AnimationCurve m_curve;
    [SerializeField]
    private float m_moveTime = 1f;
    
    private float m_time = 0;

    //float speed = 3f;

    //float m_HeightArc = 3;

    private Vector3 _startPos;
    private Vector3 _targetPos;



    Quaternion LookAt2D(Vector2 forward)
    {
        return Quaternion.Euler(0, 0, Mathf.Atan2(forward.y, forward.x) * Mathf.Rad2Deg);
    }

    public override void Apply()
    {
        base.Apply();
        m_state = 0;
        elapsedTime = 0;
        
        _targetPos = m_owner.m_inputVec.normalized * 4 + m_owner.transform.position;
        _startPos = m_owner.transform.position;
        m_time = 0;
        transform.position = _startPos;
              
        m_HitEffect.transform.localScale = new Vector3(m_area , m_area , 1f);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        elapsedTime += Time.fixedDeltaTime;

        if(m_state == 0 && elapsedTime < m_moveTime)
        {
            MoveProjectile();
        }
        if (m_state == 0  && elapsedTime >= 1f)
        {
            elapsedTime = 0;
            m_HitEffect.SetActive(true);
            m_collisionChild.SetColliderActive(true);
            m_state = 1;
        }else if(m_state == 1 && elapsedTime >= 0.3f)
        {
            elapsedTime = 0;
            m_HitEffect.SetActive(false);
            Close();
        }
    }

    void MoveProjectile()
    {
        if(m_time < m_moveTime)
        {
            m_time += Time.deltaTime;
            float linearT = m_time / m_moveTime;
            float heighT = m_curve.Evaluate(linearT);
            float height = Mathf.Lerp(0f, 2f, heighT);
            transform.position = Vector2.Lerp(_startPos, _targetPos, linearT) + new Vector2(0.0f, height);
            //m_indicator?.UpdateLogic();
        }
    }

    bool IsOutOfBounds(Vector3 pos)
    {
        // 예를 들어, 화면 밖으로 나가는지 여부를 검사할 수 있는 로직
        return false;
    }


    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }
}
