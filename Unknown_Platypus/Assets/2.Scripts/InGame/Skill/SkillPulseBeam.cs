using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillPulseBeam : SkillObject
{
    [SerializeField] SkillCollisionChild beam;
    private int state;
    private int count;
    private float elapsedTime;
    private List<Player> targetList = new List<Player>();

    private void Awake()
    {
        gameObject.SetActive(false);
        beam.gameObject.SetActive(false);
        beam.SetParent(this);
    }

    public override void Apply()
    {
        count = 0;
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        targetList.Clear();
        transform.position = (Vector2)m_owner.transform.position + (Random.insideUnitCircle * m_distance);
    }

    public override void UpdateLogic()
    {

        elapsedTime += Time.fixedDeltaTime;

        if (elapsedTime > 1)
        {
            count++;
            elapsedTime = 0;
            SpawnBeam();
            return;
        }

        if (count == 0)
            return;

        if (elapsedTime >= m_duration)
        {
            if (count >= m_count)
            {
                gameObject.SetActive(false);
                return;
            }
            else
            {
                count++;
                elapsedTime = 0;
                SpawnBeam();
            }
        }
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
