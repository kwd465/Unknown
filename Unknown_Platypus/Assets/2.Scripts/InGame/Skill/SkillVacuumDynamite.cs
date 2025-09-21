using System.Collections;
using System.Collections.Generic;
using System.Xml;
using BH;
using Unity.VisualScripting;
using UnityEngine;

public class SkillVacuumDynamite : SkillObject
{
    [Header("피격 콜라이더")]
    [SerializeField] List<SkillCollisionChild> collisionList = new();

    [SerializeField] List<GameObject> HitEffectList = new List<GameObject>();

    [Header("아래 자식  오브젝트들 -Jun 25-09-21")]
    [SerializeField] List<GameObject> LowLevelBoomList;
    [SerializeField] List<GameObject> MaxLevelBoomList;

    List<GameObject> chooseList;

    private int m_state = 0;
    private int boomCount = 2;

    float elapsedTime;

    private void Awake()
    {
        collisionList.ForEach(x =>
        {
            x.SetParent(this);
        });

        LowLevelBoomList.ForEach(x => x.gameObject.SetActive(false));
        MaxLevelBoomList.ForEach(x => x.gameObject.SetActive(false));
        HitEffectList.ForEach(x => x.gameObject.SetActive(false));
    }

    [SerializeField]
    private AnimationCurve m_curve;
    [SerializeField]
    private float m_moveTime = 1f;
    
    private float m_time = 0;

    //float speed = 3f;

    //float m_HeightArc = 3;

    private Vector3 _startPos;
    //private Vector3 _targetPos;
    List<Vector3> targetPosList = new();

    Quaternion LookAt2D(Vector2 forward)
    {
        return Quaternion.Euler(0, 0, Mathf.Atan2(forward.y, forward.x) * Mathf.Rad2Deg);
    }

    public override void Apply()
    {
        base.Apply();
        m_state = 0;
        elapsedTime = 0;

        _startPos = m_owner.transform.position;
        m_time = 0;
        transform.position = _startPos;

        HitEffectList.ForEach(x =>
        {
            x.gameObject.transform.localScale = new Vector3(m_area, m_area, 1f);
            x.gameObject.SetActive(false);
        });

        collisionList.ForEach(x =>
        {
            x.SetArea(SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.area));
            x.SetColliderActive(false);
        });

        boomCount = Mathf.RoundToInt(SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.count));

        if (boomCount <= 0)
        {
        }
        boomCount = 2;

        chooseList = new();

        if (SkillData.skilllv >= ConstData.SkillMaxLevel)
        {
            MaxLevelEffectObj.gameObject.SetActive(true);
            LowLevelEffectObj.gameObject.SetActive(false);

            chooseList = MaxLevelBoomList;
        }
        else
        {
            MaxLevelEffectObj.gameObject.SetActive(false);
            LowLevelEffectObj.gameObject.SetActive(true);

            chooseList = LowLevelBoomList;
        }
        if (chooseList.Count < boomCount)
        {
            Debug.LogError($@"갯수 더있어야 함 {boomCount} {chooseList.Count}");
            boomCount = chooseList.Count;
        }

        chooseList.ForEach(x => x.gameObject.SetActive(false));

        targetPosList = new();

        for (int i = 0; i < boomCount; i++)
        {
            Vector2 randomPos = new Vector2(Random.Range(-1f, 1f), Random.Range(-1, 1f)).normalized;
            targetPosList.Add((Vector2)m_owner.transform.position + (randomPos * m_distance));
            chooseList[i].gameObject.SetActive(true);
        }
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        elapsedTime += Time.fixedDeltaTime;

        if (m_state == 0 && elapsedTime < m_moveTime)
        {
            MoveProjectile();
        }
        if (m_state == 0 && elapsedTime >= 1f)
        {
            elapsedTime = 0;
            //m_collisionChild.SetColliderActive(true);

            //MaxLevelBoomEffect.gameObject.SetActive(false);
            //LowLevelBoomEffect.gameObject.SetActive(false);

            for (int i = 0; i < boomCount; i++)
            {
                chooseList[i].gameObject.SetActive(false);

                HitEffectList[i].gameObject.SetActive(true);
                HitEffectList[i].gameObject.transform.position = chooseList[i].transform.position;
                collisionList[i].SetColliderActive(true);
            }

            m_state = 1;
        }
        else if (m_state == 1 && elapsedTime >= 0.3f)
        {
            elapsedTime = 0;
            //m_HitEffect.SetActive(false);

            for (int i = 0; i < boomCount; i++)
            {
                chooseList[i].gameObject.SetActive(false);
                HitEffectList[i].gameObject.SetActive(false);
                collisionList[i].SetColliderActive(false);
            }

            Close();
        }
    }

    void MoveProjectile()
    {
        if(m_time < m_moveTime)
        {
            m_time += Time.deltaTime;

            for (int i = 0; i < boomCount; i++)
            {
                float linearT = m_time / m_moveTime;
                float heighT = m_curve.Evaluate(linearT);
                float height = Mathf.Lerp(0f, 2f, heighT);                
                chooseList[i].transform.position = Vector2.Lerp(_startPos, targetPosList[i], linearT) + new Vector2(0.0f, height);
            }

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
