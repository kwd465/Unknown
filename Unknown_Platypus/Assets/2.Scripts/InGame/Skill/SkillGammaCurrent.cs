using BH;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using UnityEngine;

public class SkillGammaCurrent : SkillObject
{
    [SerializeField]
    private Transform[] m_Effect;

    private float m_checkTime = 0;
    private int m_curIdx = 0;

    private Vector3 m_startPos;
    private Vector3 m_targetPos;

    public override void Apply()
    {
        base.Apply();
        m_curIdx = 0;
        m_checkTime = 0;
        for (int i = 0; i < m_Effect.Length; i++)
        {
            m_Effect[i].gameObject.SetActive(false);
        }

        m_startPos = m_owner.transform.position;
        m_curIdx ++;
        SetTargetPos(m_startPos);
    }


    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;

        if (m_checkTime >= 0.1f )
        {
            if (m_count <= m_curIdx)
            {
                Close();
            }

            m_checkTime = 0;
            m_curIdx++;

            SetTargetPos(m_targetPos);
           
        }
    }


    private void SetTargetPos(Vector3 _startPos)
    {
        Player _target = GameUtil.GetNearestTarget(StagePlayLogic.instance.m_SpawnLogic.m_monList , _startPos, m_distance);

        if (_target == null)
        {
            Close();
            return;
        }

        m_startPos = _startPos;
        m_targetPos = _target.transform.position;

        Vector3 _dir = (m_targetPos - _startPos).normalized;

        // �̵� ������ ������ ���մϴ�.
        float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
        float _distance = Vector3.Distance(m_startPos, m_targetPos);
        // ������Ʈ�� ȸ�� ������ �����մϴ�.
        m_Effect[m_curIdx].gameObject.SetActive(true);
        m_Effect[m_curIdx].transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
        m_Effect[m_curIdx].transform.position = m_startPos;
        m_Effect[m_curIdx].transform.localScale = new Vector3(_distance, 1f, 1f);

        BattleControl.instance.ApplySkill(m_skillData, m_owner, _target);
    }











}
