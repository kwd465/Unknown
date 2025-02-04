using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillPulseBeam : SkillObject
{
    [SerializeField] Animator LowLevelAnimator;
    [SerializeField] Animator HighLevelAnimator;
    [SerializeField] SkillCollisionChild NotMaxLevelBeam;
    [SerializeField] SkillCollisionChild MaxLevelBeam;    
    [SerializeField] float activeFalseWaitingTime;
    [SerializeField] float activeTrueWaitingTime;

    private int state;
    private int count;
    private float elapsedTime;
    private float allElapsedTime;
    private float attackPerTime;
    private bool isFirstWaiting;
    private List<Player> targetList = new List<Player>();

    private SkillCollisionChild beam;

    private void Awake()
    {
        gameObject.SetActive(false);

        NotMaxLevelBeam.gameObject.SetActive(false);
        MaxLevelBeam.gameObject.SetActive(false);

        NotMaxLevelBeam.SetParent(this);
        MaxLevelBeam.SetParent(this);
    }

    public override void Apply()
    {
        base.Apply();

        if(m_skillData.m_skillTable.skilllv == ConstData.SkillMaxLevel)
        {
            beam = MaxLevelBeam;
        }
        else
        {
            beam = NotMaxLevelBeam;
        }

        count = 0;
        beam.gameObject.SetActive(false);
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        allElapsedTime = 0;
        targetList.Clear();
        transform.position = (Vector2)m_owner.transform.position + (Random.insideUnitCircle * m_distance);
        attackPerTime = m_skillData.m_skillTable.duration / m_skillData.m_skillTable.skillHitCount;
        isFirstWaiting = false;
        SkillRangeImage.gameObject.SetActive(true);
        SetRangeImage();
    }

    public override void UpdateLogic()
    {
        elapsedTime += Time.fixedDeltaTime;
        allElapsedTime += Time.fixedDeltaTime;

        if (isFirstWaiting is false && elapsedTime <= activeTrueWaitingTime)
        {
            return;
        }
        else if(isFirstWaiting is false && elapsedTime > activeTrueWaitingTime)
        {
            isFirstWaiting = true;
        }

        if (elapsedTime > attackPerTime && count < m_skillData.m_skillTable.skillHitCount)
        {
            count++;
            elapsedTime = 0;
            SpawnBeam();
            return;
        }

        if (allElapsedTime > m_duration && gameObject.activeInHierarchy)
        {
            if(allElapsedTime - m_duration < activeFalseWaitingTime + activeTrueWaitingTime)
            {
                if (m_skillData.m_skillTable.skilllv == ConstData.SkillMaxLevel)
                {
                    HighLevelAnimator.SetTrigger("Disapper");
                }
                else
                {
                    LowLevelAnimator.SetTrigger("Disapper");
                }
                    
                return;
            }

            Close();
            return;
        }

        //if (count < HitCount)
        //{
        //    return;
        //}

        //if(elapsedTime < activeFalseWaitingTime)
        //{
        //    return;
        //}

        //Close();
    }

    void SpawnBeam()
    {
        beam.gameObject.SetActive(false);
        beam.gameObject.SetActive(true);
        beam.targetList.Clear();
        beam.SetColliderActive(true);
        var pos = (Vector2)transform.position + Random.insideUnitCircle * m_skillData.m_skillTable.skillArea * 2;

        if (pos.x >= ConstData.MapMaxPos.x)
        {
            pos = new Vector2(ConstData.MapMaxPos.x, pos.y);
        }
        else if(pos.x < ConstData.MapMinPos.x)
        {
            pos = new Vector2(ConstData.MapMinPos.x, pos.y);
        }

        if(pos.y >= ConstData.MapMaxPos.y)
        {
            pos = new Vector2(pos.x, ConstData.MapMaxPos.y);
        }
        else if(pos.y < ConstData.MapMinPos.y)
        {
            pos = new Vector2(pos.x, ConstData.MapMinPos.y);
        }

        beam.transform.position = (Vector2)transform.position + Random.insideUnitCircle * m_skillData.m_skillTable.skillArea * 2;
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }
}