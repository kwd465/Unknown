using BH;
using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

public class SkillElemental : SkillObject
{
    [SerializeField] SkillCollisionChild[] elementalArr;
    [SerializeField] Rigidbody2D[] elementalRigArr;

    //Vector2[] defaultPos = new Vector2[] { new Vector2(-2, 2), new Vector2(2, -2), new Vector2(2, 2), new Vector2(-2, -2) };
    //Vector2[] targetPos = new Vector2[4];
    //float[] elementalMoveTimeArr = new float[4];
    //bool[] hasTarget = new bool[4];
    //int state;
    float elapsedTime;
    //List<Player> targetList = new List<Player>();
    Player targetUnit = null;
    int level = 0;
    //int m_objectCount = 0;

    //Coroutine resetCoroutine = null;
    public void Awake()
    {
        gameObject.SetActive(false);

        foreach (var element in elementalArr)
        {
            element.SetParent(this);
            element.gameObject.SetActive(false);
            element.SetColliderActive(false);
        }
    }

    public override void RefreshSkill(SkillEffect _data)
    {
        base.RefreshSkill(_data);
        //m_objectCount = (int)m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count);
        //for (int i = 0; i < m_objectCount; i++)
        //{
        //    elementalArr[i].gameObject.SetActive(true);
        //    elementalArr[i].SetColliderActive(true);
        //    elementalArr[i].transform.localPosition = SkillEffect.isActiving ? elementalArr[i].transform.localPosition : defaultPos[i];
        //}

        //Debug.Log(@$"element check refresh {m_objectCount} {m_skillData.m_skillTable.skilllv}");

        level = m_skillData.m_skillTable.skilllv - 1;

        for (int i = 0; i < elementalArr.Length; i++)
        {
            if(level == i)
            {
                elementalArr[i].gameObject.SetActive(true);
                elementalArr[i].SetColliderActive(true);
                continue;
            }

            elementalArr[i].gameObject.SetActive(false);
            elementalArr[i].SetColliderActive(false);
        }
    }

    //public override void Init(SkillEffect _data, List<Player> _targets, Player _owner, Vector3 _dir)
    //{
    //    base.Init(_data, _targets, _owner, _dir);
    //    Apply();
    //}

    public override void Apply()
    {
        gameObject.SetActive(true);
        
        elapsedTime = 0;
        targetUnit = null;

        transform.localPosition = Vector2.zero;
        //m_objectCount = (int)m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count);
        //for (int i = 0; i < m_objectCount; i++)
        //{
        //    elementalArr[i].gameObject.SetActive(true);
        //    elementalArr[i].SetColliderActive(true);
        //    elementalArr[i].transform.localPosition = defaultPos[i];
        //    elementalMoveTimeArr[i] = 0;
        //}

        level = m_skillData.m_skillTable.skilllv - 1;

        for (int i = 0; i < elementalArr.Length; i++)
        {
            if (level == i)
            {
                elementalArr[i].gameObject.SetActive(true);
                elementalArr[i].SetColliderActive(true);
                continue;
            }

            elementalArr[i].gameObject.SetActive(false);
            elementalArr[i].SetColliderActive(false);
        }

        //Debug.Log(@$"element check apply {m_objectCount} {m_skillData.m_skillTable.skilllv}");

        //if (ConstData.SkillMaxLevel == m_skillData.m_skillTable.skilllv)
        //{
        //    LowLevelEffectObj.gameObject.SetActive(false);
        //    MaxLevelEffectObj.gameObject.SetActive(true);
        //}
        //else
        //{
        //    MaxLevelEffectObj.gameObject.SetActive(false);
        //    LowLevelEffectObj.gameObject.SetActive(true);
        //}

        //if(resetCoroutine is not null)
        //{
        //    StopCoroutine(resetCoroutine);
        //}
        //SkillEffect.isActiving = false;
    }

    public override void UpdateLogic()
    {
        gameObject.transform.position = Owner.transform.position;

        elapsedTime += Time.deltaTime;

        //if (elapsedTime < m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.coolTime))
        //{
        //    return;
        //}

        //if (FindTarget() is false)
        //{
        //    return;
        //}

        Move();

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
                elementalArr[i].transform.position = Vector2.Lerp(elementalArr[i].transform.position, targetPos[i], elapsedTime);
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
                elementalArr[i].transform.position = Vector2.Lerp(elementalArr[i].transform.position, targetPos[i], elapsedTime);
            }

            if (elapsedTime >= 0.5f)
            {
                state = 0;
                elapsedTime = 0;

                for (int i = 0; i < m_objectCount; i++)
                {
                    elementalArr[i].transform.localPosition = defaultPos[i];
                    elementalArr[i].SetColliderActive(true);
                }
            }
        }
        */
    }

    private Vector3 currentDirection = Vector3.zero;

    //bool[] isMoveStartArr = new []{ false, false, false, false };
    bool isMoveTargetStart = false;
    Vector3 targetPos = Vector3.zero;
    [SerializeField] float maxSpeed = 10;

    Vector3[] areaPos = { new Vector3(1, 1, 0), new Vector3(1, -1, 0), new Vector3(-1, -1, 0), new Vector3(-1, 1, 0) };
    bool[] selectArea = { true, false, false, false };

    private void SelectArea()
    {
        int index = UnityEngine.Random.Range(0, selectArea.Length);

        while (selectArea[index])
        {
            index = UnityEngine.Random.Range(0, selectArea.Length);
        }

        for (int i = 0; i < selectArea.Length; i++)
        {
            selectArea[i] = false;
        }

        selectArea[index] = true;

        targetPos = new Vector3
    (UnityEngine.Random.Range(0f, m_skillData.m_skillTable.skillDistance) * areaPos[index].x,
    UnityEngine.Random.Range(0f, m_skillData.m_skillTable.skillDistance) * areaPos[index].y,
    0);
    }

    private void Move()
    {
        if (isMoveTargetStart)
        {
            //elementalRigArr[level].AddForce((targetPos - elementalRigArr[level].transform.localPosition).normalized * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue * 2);
            //elementalRigArr[level].velocity = Vector3.ClampMagnitude(elementalRigArr[level].velocity, maxSpeed);
            elementalRigArr[level].transform.localPosition += (targetPos - elementalRigArr[level].transform.localPosition).normalized * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue[0] * Time.deltaTime * 2;
            //elementalRigArr[level].MovePosition((targetPos - elementalRigArr[level].transform.localPosition).normalized * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue * Time.deltaTime * 2);

            //Debug.Log($@"{targetPos} {elementalRigArr[level].transform.localPosition} random");

            if ((targetPos - elementalRigArr[level].transform.localPosition).sqrMagnitude <= 0.01f)
            {
                isMoveTargetStart = false;
            }

            return;
        }

        isMoveTargetStart = true;
        SelectArea();

        // 클래스의 멤버 변수로 선언 (초기값은 Vector3.zero)
        //if (isMoveTargetStart)
        //{
        //    Vector3 currentPos = elementalRigArr[level].transform.localPosition;
        //    Vector3 desiredDir = (targetPos - currentPos).normalized;

        //    //if (currentDirection == Vector3.zero)
        //    //{
        //    //currentDirection = desiredDir;
        //    //}

        //    float maxRadiansDelta = Mathf.Deg2Rad * 90f * Time.deltaTime;
        //    currentDirection = Vector3.RotateTowards(currentDirection, desiredDir, maxRadiansDelta, 0f);
        //    Quaternion q = Quaternion.LookRotation(desiredDir);
        //    Quaternion rotationValue = Quaternion.RotateTowards(elementalRigArr[level].transform.rotation, q, 60f * Time.deltaTime);
        //    // 실제 회전값 업데이트: 2D에서는 보통 Z축 회전만 적용합니다.
        //    elementalRigArr[level].transform.rotation = rotationValue;
        //    //Debug.Log(@$"rotation {rotationValue.eulerAngles}");
        //    elementalRigArr[level].transform.localPosition += desiredDir * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue * Time.deltaTime;

        //    if ((targetPos - elementalRigArr[level].transform.localPosition).sqrMagnitude <= 0.01f)
        //    {
        //        isMoveTargetStart = false;
        //        currentDirection = Vector3.zero;
        //    }

        //    return;
        //}

        //isMoveTargetStart = true;

        //targetPos = new Vector3
        //    (Random.Range(m_skillData.m_skillTable.skillDistance * -1, m_skillData.m_skillTable.skillDistance),
        //    Random.Range(m_skillData.m_skillTable.skillDistance * -1, m_skillData.m_skillTable.skillDistance),
        //    0);

        ///////////////////////이전꺼 -Jun 25-03-11
        //if(targetUnit is null)
        //{
        //    return;
        //}

        //Vector3[] vec3 = new Vector3[] { gameObject.transform.InverseTransformPoint(targetUnit.transform.position), Vector3.zero };
        //float distance = Vector2.Distance(targetUnit.transform.position, (Vector2)elementalArr[level].transform.position);
        //float moveTime = distance / (m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)/*한 프레임당 이동 거리  (distance * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)*/;

        //elementalArr[level].transform.DOLocalPath(vec3, moveTime).OnComplete(() =>
        //    {
        //        elementalArr[level].transform.DOLocalMove(targetUnit.transform.position, moveTime).OnComplete(() =>
        //        {

        //        });
        //    }
        //);

        //for (int i = 0; i < m_objectCount; i++)
        //{
        //    if (isMoveStartArr[i] || hasTarget[i] is false)
        //    {
        //        continue;
        //    }

        //    Vector3[] vec3 = new Vector3[] { gameObject.transform.InverseTransformPoint(targetPos[i]), defaultPos[i] };
        //    float distance = Vector2.Distance(targetPos[i], (Vector2)elementalArr[i].transform.position);
        //    float moveTime = distance / (m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)/*한 프레임당 이동 거리  (distance * Time.deltaTime * m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue)*/;
        //    Debug.Log($@" move {moveTime} {distance} {targetPos[i]} {i}");
        //    int myIndex = i;
        //    isMoveStartArr[myIndex] = true;
        //    elementalArr[i].transform.DOLocalPath(vec3, moveTime).OnComplete(() =>
        //    {
        //        //elementalArr[i].transform.DOLocalMove(defaultPos[myIndex], moveTime).OnComplete(() =>
        //        //{
        //        //    Debug.Log(@$"move end go to defalut {elementalArr[i].gameObject.transform.position} {elementalArr[i].gameObject.transform.localPosition} {defaultPos[myIndex]} {myIndex} {moveTime}");
        //        //    isMoveStartArr[myIndex] = false;
        //        //});
        //        DOVirtual.DelayedCall(0.5f, () =>
        //        {
        //            isMoveStartArr[myIndex] = false;
        //        });
        //    });
        //}
    }

    //private IEnumerator CoBackToDefaultPos()
    //{
    //    for (int i = 0; i < m_objectCount; i++)
    //    {
    //        isMoveStartArr[i] = false;
    //        elementalArr[i].transform.DOKill();
    //        float distance = (defaultPos[i] - (Vector2)elementalArr[i].transform.localPosition).magnitude;
    //        float moveTime = distance / (m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue);
    //        Debug.Log($@"close {moveTime} {i}");
    //        int nowIndex = i;
    //        elementalArr[i].transform.DOLocalMove(defaultPos[i], moveTime).OnComplete(() =>
    //        {
    //            elementalArr[i].transform.localPosition = defaultPos[nowIndex];
    //        });
    //    }
    //    yield return null;
    //    resetCoroutine = null;
    //}

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }

    public override void Close()
    {
        elapsedTime = 0;

        SkillEndAction?.Invoke();

        //if (resetCoroutine is not null)
        //{
        //    StopCoroutine(resetCoroutine);
        //}
        //resetCoroutine = StartCoroutine(CoBackToDefaultPos());
    }

    //bool FindTarget()
    //{
    //    //collder2Düũ �ϴ°� ������
    //    //���Ͱ� ���������� ������ �� ���� ��
    //    //Collider2D[] _target = Physics2D.OverlapCircleAll(actor.transform.position, 50, 7);

    //    var liveMonster = StagePlayLogic.instance.m_SpawnLogic.m_monList;

    //    Vector3 pos1 = m_owner.transform.position;
    //    Vector3 pos2;
    //    float dist;
    //    float[] farthestDist = new float[4];
    //    Player[] farthestMon = new Player[4];

    //    foreach (var mon in liveMonster)
    //    {
    //        pos2 = mon.transform.position;
    //        dist = (pos1 - pos2).sqrMagnitude;
    //        if (dist > 50)
    //            continue;

    //        int idx = 0;

    //        if (pos2.x > pos1.x)
    //        {
    //            if (pos2.y > pos1.y)
    //                idx = 2;
    //            else
    //                idx = 1;
    //        }
    //        else
    //        {
    //            if (pos2.y > pos1.y)
    //                idx = 0;
    //            else
    //                idx = 3;
    //        }

    //        if (dist > farthestDist[idx])
    //        {
    //            farthestDist[idx] = dist;
    //            farthestMon[idx] = mon;
    //        }
    //    }

    //    bool _isTarget = false;
    //    for (int i = 0; i < 4; i++)
    //    {
    //        if (farthestMon[i] == null)
    //        {
    //            hasTarget[i] = false;
    //            elementalMoveTimeArr[i] = 0;
    //        }
    //        else
    //        {
    //            _isTarget = true;
    //            hasTarget[i] = true;
    //            targetPos[i] = farthestMon[i].transform.position;
    //        }
    //    }

    //    return _isTarget;
    //}
}