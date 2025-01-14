using BH;
using System.Collections;
using System.Collections.Generic;
using TMPro.EditorUtilities;
using UnityEngine;

public class SkillPulseBeam : SkillObject
{
    [SerializeField] SkillCollisionChild beam;
    [SerializeField] float activeFalseWaitingTime;
    private int state;
    private int count;
    private float elapsedTime;
    private float allElapsedTime;
    private float attackPerTime;
    private List<Player> targetList = new List<Player>();

    private void Awake()
    {
        gameObject.SetActive(false);
        beam.gameObject.SetActive(false);
        beam.SetParent(this);
    }

    public override void Apply()
    {
        base.Apply();

        count = 0;
        beam.gameObject.SetActive(false);
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        allElapsedTime = 0;
        targetList.Clear();
        transform.position = (Vector2)m_owner.transform.position + (Random.insideUnitCircle * m_distance);
        attackPerTime = m_skillData.m_skillTable.duration / m_skillData.m_skillTable.skillHitCount;
    }

    public override void UpdateLogic()
    {
        elapsedTime += Time.fixedDeltaTime;
        allElapsedTime += Time.fixedDeltaTime;

        if (elapsedTime > attackPerTime)
        {
            count++;
            elapsedTime = 0;
            SpawnBeam();
            return;
        }

        if(allElapsedTime > m_duration && gameObject.activeInHierarchy)
        {
            Close();
            return;
        }

        if (count < HitCount)
        {
            return;
        }

        if(elapsedTime < activeFalseWaitingTime)
        {
            return;
        }

        Close();
    }

    void SpawnBeam()
    {
        beam.gameObject.SetActive(false);
        beam.gameObject.SetActive(true);
        beam.targetList.Clear();
        beam.SetColliderActive(true);         
        beam.transform.position = (Vector2)transform.position + Random.insideUnitCircle * m_skillData.m_skillTable.skillArea * 2;
    }


    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }
}