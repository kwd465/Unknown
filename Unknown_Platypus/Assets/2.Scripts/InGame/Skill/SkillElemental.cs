using BH;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

public class SkillElemental : SkillObject
{
    [SerializeField] SkillCollisionChild[] elemental;

    Vector2[] defaultPos = new Vector2[] { new Vector2(-2, 2), new Vector2(2, -2), new Vector2(2, 2), new Vector2(-2, -2) };
    Vector2[] targetPos = new Vector2[4];
    float[] elementalMoveTimeArr = new float[4];
    bool[] hasTarget = new bool[4];
    int state;
    float elapsedTime;
    List<Player> targetList = new List<Player>();
    int m_objectCount = 0;

    Coroutine resetCoroutine = null;
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
            elemental[i].SetColliderActive(true);
            elemental[i].transform.localPosition = SkillEffect.isActiving ? elemental[i].transform.localPosition : defaultPos[i];
        }

        Debug.Log(@$"element check refresh {m_objectCount} {m_skillData.m_skillTable.skilllv}");
    }

    //public override void Init(SkillEffect _data, List<Player> _targets, Player _owner, Vector3 _dir)
    //{
    //    base.Init(_data, _targets, _owner, _dir);
    //    Apply();
    //}

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
            elementalMoveTimeArr[i] = 0;
        }

        Debug.Log(@$"element check apply {m_objectCount} {m_skillData.m_skillTable.skilllv}");

        if (ConstData.SkillMaxLevel == m_skillData.m_skillTable.skilllv)
        {
            LowLevelEffectObj.gameObject.SetActive(false);
            MaxLevelEffectObj.gameObject.SetActive(true);
        }
        else
        {
            MaxLevelEffectObj.gameObject.SetActive(false);
            LowLevelEffectObj.gameObject.SetActive(true);
        }

        if(resetCoroutine is not null)
        {
            StopCoroutine(resetCoroutine);
        }
        //SkillEffect.isActiving = false;
    }

    public override void UpdateLogic()
    {
        gameObject.transform.position = Owner.transform.position;

        elapsedTime += Time.deltaTime;

        if (elapsedTime < m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.coolTime))
        {
            return;
        }

        if (FindTarget() is false)
        {
            return;
        }

        Move();
        

        //for (int i = 0; i < m_objectCount; i++)
        //{
        //    Vector3 calcPos = Vector3.zero;

        //    elementalMoveTimeArr[i] += Time.deltaTime;

        //    if (elementalMoveTimeArr[i] >= 1 || hasTarget[i] is false)
        //    {
        //        if (elementalMoveTimeArr[i] >= 2)
        //        {
        //            elementalMoveTimeArr[i] = 0;
        //            elemental[i].transform.localPosition = defaultPos[i];
        //            continue;
        //        }

        //        calcPos = (defaultPos[i] - (Vector2)elemental[i].transform.localPosition).normalized * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue;
                
        //        if((defaultPos[i] - (Vector2)elemental[i].transform.localPosition).sqrMagnitude <= 0.01f)
        //        {
        //            elementalMoveTimeArr[i] = 2;
        //            elemental[i].transform.localPosition = defaultPos[i];
        //        }
        //        else
        //        {
        //            elemental[i].transform.localPosition += calcPos;
        //        }
        //    }
        //    else
        //    {
        //        calcPos = (targetPos[i] - (Vector2)elemental[i].transform.position).normalized * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue;

        //        if ((targetPos[i] - (Vector2)elemental[i].transform.position).sqrMagnitude <= 0.01f)
        //        {
        //            elementalMoveTimeArr[i] = 1;
        //            elemental[i].transform.position = targetPos[i];
        //        }
        //        else
        //        {
        //            elemental[i].transform.position += calcPos;
        //        }
        //    }
        //    Debug.Log($@"move time check {elementalMoveTimeArr[i]} {i} {elapsedTime}");
        //    //elemental[i].transform.position = Vector2.Lerp(defaultPos[i] + (Vector2)m_owner.transform.position, targetPos[i], elementalMoveTimeArr[i]);
        //    //Debug.Log(@$" move to target {i} {targetPos[i]} {calcPos} {elemental[i].transform.position} {m_skillData.m_skillTable.skillEffectDataList[1].skillEffectType}");
        //}

        if (elapsedTime >= m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration) + m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.coolTime))
        {
            Close();
        }

        /*
        //state 0
        if (state == 0)
        {
            elapsedTime += Time.fixedDeltaTime;
            transform.position = m_owner.transform.position;
            //transform.Rotate(new Vector3(0, 0, 40 * Time.fixedDeltaTime));
            if (elapsedTime >= m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration))
            {
                if (FindTarget())
                {
                    elapsedTime = 0;
                    state = 1;
                }
            }
        }
        //state 1
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
        //state 2
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
        //state 3
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
        */
    }

    bool[] isMoveStartArr = new []{ false, false, false, false };

    private void Move()
    {
        for (int i = 0; i < m_objectCount; i++)
        {
            if (isMoveStartArr[i] || hasTarget[i] is false)
            {
                continue;
            }

            Vector3[] vec3 = new Vector3[] { gameObject.transform.InverseTransformPoint(targetPos[i]), defaultPos[i] };
            float distance = Vector2.Distance(targetPos[i], (Vector2)elemental[i].transform.position);
            float moveTime = distance / (m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)/*한 프레임당 이동 거리  (distance * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)*/;
            Debug.Log($@" move {moveTime} {distance} {targetPos[i]} {i}");
            int myIndex = i;
            isMoveStartArr[myIndex] = true;
            elemental[i].transform.DOLocalPath(vec3, moveTime).OnComplete(() =>
            {
                //elemental[i].transform.DOLocalMove(defaultPos[myIndex], moveTime).OnComplete(() =>
                //{
                //    Debug.Log(@$"move end go to defalut {elemental[i].gameObject.transform.position} {elemental[i].gameObject.transform.localPosition} {defaultPos[myIndex]} {myIndex} {moveTime}");
                //    isMoveStartArr[myIndex] = false;
                //});
                DOVirtual.DelayedCall(0.5f, () =>
                {
                    isMoveStartArr[myIndex] = false;
                });
            });
        }
    }

    private IEnumerator CoBackToDefaultPos()
    {
        //bool[] allPosCheck = Enumerable.Repeat(false, m_objectCount).ToArray();

        //while (allPosCheck.Contains(false))
        //{
        //    gameObject.transform.position = Owner.transform.position;

        //    for (int i = 0; i < m_objectCount; i++)
        //    {
        //        if (allPosCheck[i])
        //        {
        //            continue;
        //        }

        //        isMoveStartArr[i] = false;
        //        elemental[i].transform.DOKill();

        //        if (allPosCheck[i] is false && (defaultPos[i] - (Vector2)elemental[i].transform.localPosition).sqrMagnitude <= 0.01f)
        //        {
        //            elemental[i].transform.localPosition = defaultPos[i];
        //            allPosCheck[i] = true;
        //            elementalMoveTimeArr[i] = 0;
        //            continue;
        //        }

        //        Vector3 calcPos = (defaultPos[i] - (Vector2)elemental[i].transform.localPosition).normalized * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue;

        //        elemental[i].transform.localPosition += calcPos;
        //        Debug.Log(@$"clost {i} {elemental[i].transform.localPosition} {defaultPos[i]} {calcPos}");
        //    }

        //    yield return null;
        //}
        for (int i = 0; i < m_objectCount; i++)
        {
            isMoveStartArr[i] = false;
            elemental[i].transform.DOKill();
            float distance = (defaultPos[i] - (Vector2)elemental[i].transform.localPosition).magnitude;
            float moveTime = distance / (m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue);
            Debug.Log($@"close {moveTime} {i}");
            int nowIndex = i;
            elemental[i].transform.DOLocalMove(defaultPos[i], moveTime).OnComplete(() =>
            {
                elemental[i].transform.localPosition = defaultPos[nowIndex];
            });
        }
        yield return null;
        resetCoroutine = null;
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }

    public override void Close()
    {
        elapsedTime = 0;

        SkillEndAction?.Invoke();

        if (resetCoroutine is not null)
        {
            StopCoroutine(resetCoroutine);
        }
        resetCoroutine = StartCoroutine(CoBackToDefaultPos());
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

            if (pos2.x > pos1.x)
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

            if (dist > farthestDist[idx])
            {
                farthestDist[idx] = dist;
                farthestMon[idx] = mon;
            }
        }

        bool _isTarget = false;
        for (int i = 0; i < 4; i++)
        {
            if (farthestMon[i] == null)
            {
                hasTarget[i] = false;
                elementalMoveTimeArr[i] = 0;
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