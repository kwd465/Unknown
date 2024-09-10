using BH;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class SkillElemental : SkillObject
{
    [SerializeField] SkillCollisionChild [] elemental;

    Vector2[] defaultPos = new Vector2[] { new Vector2(-2, 2), new Vector2(2, -2), new Vector2(2, 2), new Vector2(-2, -2) };
    Vector2[] targetPos = new Vector2[4];
    bool[] hasTarget = new bool[4];
    int state;
    float elapsedTime;
    List<Player> targetList = new List<Player>();
    int m_objectCount = 0;
    public void Awake()
    {
        gameObject.SetActive(false);

        foreach (var element in elemental)
        {
            element.SetParent(this);
            element.gameObject.SetActive(false);
            element.SetColliderActive(false);
        }
    }

    public override void RefreshSkill(SkillEffect _data)
    {
        base.RefreshSkill(_data);
        m_objectCount = (int)m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count);
        for (int i = 0; i < m_objectCount; i++)
        {
            elemental[i].gameObject.SetActive(true);
            elemental[i].SetColliderActive(false);
            elemental[i].transform.localPosition = defaultPos[i];
        }
    }

    public override void Apply()
    {
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        targetList.Clear();

        transform.localPosition = Vector2.zero;
        m_objectCount = (int)m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count);
        for (int i = 0; i < m_objectCount; i++)
        {
            elemental[i].gameObject.SetActive(true);
            elemental[i].SetColliderActive(true);
            elemental[i].transform.localPosition = defaultPos[i];
        }
    }

    public override void UpdateLogic()
    {
        if (state == 0)
        {
            elapsedTime += Time.fixedDeltaTime;
            transform.position = m_owner.transform.position;
            transform.Rotate(new Vector3(0, 0, 40 * Time.fixedDeltaTime));
            if (elapsedTime >= m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration))
            {
                if (FindTarget())
                {
                    elapsedTime = 0;
                    state = 1;
                }
            }
        }
        else if (state == 1)
        {
            // Ÿ���� ���� ���ư�
            elapsedTime += Time.fixedDeltaTime;
            transform.rotation = Quaternion.identity;
            for (int i = 0; i < m_objectCount; i++)
            {
                if (hasTarget[i] == false)
                    continue;
                elemental[i].transform.position = Vector2.Lerp(elemental[i].transform.position, targetPos[i], elapsedTime);
            }

            if (elapsedTime >= 0.5f)
            {
                state = 2;
                elapsedTime = 0;
            }
        }
        else if (state == 2)
        {
            // 2�� ���

            elapsedTime += Time.deltaTime;
            if (elapsedTime >= m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration))
            {
                elapsedTime = 0;
                state = 3;
            }
        }
        else if (state == 3)
        {
            // �ٽ� ���ƿ�.
            elapsedTime += Time.fixedDeltaTime;

            for (int i = 0; i < m_objectCount; i++)
            {
                targetPos[i] = (Vector2)m_owner.transform.position + defaultPos[i];
                elemental[i].transform.position = Vector2.Lerp(elemental[i].transform.position, targetPos[i], elapsedTime);
            }

            if (elapsedTime >= 0.5f)
            {
                state = 0;
                elapsedTime = 0;

                for (int i = 0; i < m_objectCount; i++)
                {
                    elemental[i].transform.localPosition = defaultPos[i];
                    elemental[i].SetColliderActive(true);
                }
            }
        }
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }



    bool FindTarget()
    {
        //collder2Düũ �ϴ°� ������
        //���Ͱ� ���������� ������ �� ���� ��
        //Collider2D[] _target = Physics2D.OverlapCircleAll(actor.transform.position, 50, 7);

        var liveMonster = StagePlayLogic.instance.m_SpawnLogic.m_monList;
        
        Vector3 pos1 = m_owner.transform.position;
        Vector3 pos2;
        float dist;
        float[] farthestDist = new float[4];
        Player[] farthestMon = new Player[4]; 

        foreach (var mon in liveMonster)
        {
            pos2 = mon.transform.position;
            dist = (pos1 - pos2).sqrMagnitude;
            if (dist > 50)
                continue;

            int idx = 0;

            if( pos2.x > pos1.x )
            {
                if (pos2.y > pos1.y)
                    idx = 2;
                else
                    idx = 1;
            }
            else
            {
                if (pos2.y > pos1.y)
                    idx = 0;
                else
                    idx = 3;
            }

            if( dist > farthestDist[idx])
            {
                farthestDist[idx] = dist;
                farthestMon[idx] = mon;
            }
        }

        bool _isTarget = false;
        for(int i=0; i<4; i++)
        {
            if (farthestMon[i] == null)
            {
                hasTarget[i] = false;                
            }
            else
            {
                _isTarget = true;
                hasTarget[i] = true;
                targetPos[i] = farthestMon[i].transform.position;
            }
        }


        return _isTarget;

    }



}
