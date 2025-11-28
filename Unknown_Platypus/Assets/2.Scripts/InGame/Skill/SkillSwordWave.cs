using System.Collections;
using System.Collections.Generic;
using System.Linq;
using BH;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEngine.RuleTile.TilingRuleOutput;

public class SkillSwordWave : SkillObject
{
    private float m_checkTime = 0;

    [SerializeField] SkillCollisionChild MaxSkillCollision;
    [SerializeField] Animator MaxLevelAnimator;

    private void Awake()
    {
        gameObject.SetActive(false);
    }


    override public void Apply()
    {
        base.Apply();
        targetList.Clear();
        gameObject.SetActive(true);

        m_checkTime = 0;

        //transform.localScale = new Vector3(m_area ,m_area , 1f);

        if (m_skillData.m_skillTable.skilllv == ConstData.SkillMaxLevel)
        {
            LowLevelEffectObj.gameObject.SetActive(false);
            MaxLevelEffectObj.gameObject.SetActive(true);
            
            MaxSkillCollision.SetParent(this);
            MaxSkillCollision.SetArea(m_area);
            MaxSkillCollision.gameObject.SetActive(true);
            MaxSkillCollision.SetColliderActive(true);
            MaxSkillCollision.EventCallBackAction = null;
            MaxSkillCollision.EventCallBackAction = MaxSkillCollisionEvent;
            MaxSkillCollision.EndAction = null;
            MaxSkillCollision.EndAction = Close;

            Vector2 randomPos = new Vector2(Random.Range(-m_distance, m_distance), Random.Range(-m_distance, m_distance));

            int random = UnityEngine.Random.Range(0, 2);
            Vector2 targetPos = random == 0 ? gameObject.transform.position : m_owner.transform.position;
            randomPos += targetPos;
            Debug.Log("이거 맞냐?");
            MaxSkillCollision.transform.position = randomPos;
            MaxSkillCollision.SetColliderActive(true);
            MaxSkillCollision.gameObject.SetActive(true);

            MaxLevelAnimator.Play("SwordAni");
        }
        else
        {
            LowLevelEffectObj.gameObject.SetActive(true);
            MaxLevelEffectObj.gameObject.SetActive(false);
        }
    }

    override public void UpdateLogic()
    {
        base.UpdateLogic();

        if (m_skillData.m_skillTable.skilllv != ConstData.SkillMaxLevel)
        {
            m_checkTime += Time.fixedDeltaTime;

            if (m_dir == Vector3.zero)
            {
                m_dir = new Vector2(Random.Range(0f, 1f), Random.Range(0f, 1f)).normalized;
            }

            Vector3 _target = m_dir * 5f * Time.fixedDeltaTime;
            transform.position += _target;
            // 이동 방향의 각도를 구합니다.
            float angle = Mathf.Atan2(m_dir.y, m_dir.x) * Mathf.Rad2Deg;

            // 오브젝트의 회전 각도를 설정합니다.
            transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);

            if (m_checkTime >= m_duration)
            {
                m_checkTime = 0;
                Close();
            }
        }
        //스킬 level  5 == 즉 최대 레벨 다한 놈은 내려찍고 그 범위 안에서 데미지 입혀줌 -Jun 25-11-01
        else
        {
            m_checkTime = 0;
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
            return;

        var player = collision.GetComponent<Player>();

        if (player == null || m_skillData.m_skillTable.skilllv == ConstData.SkillMaxLevel)
        {
            return;
        }

        if (targetList.Contains(player))
        {
            targetList.Remove(player);
        }

        targetList.Add(player);

        BattleControl.instance.ApplySkill(m_skillData, m_owner, player);
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        if (m_skillData.m_skillTable.skilllv != ConstData.SkillMaxLevel)
        {
            return;
        }

        var player = collision.GetComponent<Player>();

        if (player == null)
        {
            return;
        }

        if (targetList.Contains(player))
        {
            targetList.Remove(player);
        }

        targetList.Add(player);
    }

    public override void OnTriggerExitChild(Collider2D collision)
    {
        if (m_skillData.m_skillTable.skilllv != ConstData.SkillMaxLevel)
        {
            return;
        }

        var player = collision.GetComponent<Player>();

        if (player == null)
        {
            return;
        }

        if (targetList.Contains(player))
        {
            targetList.Remove(player);
        }
    }

    public void MaxSkillCollisionEvent()
    {
        for (int i = 0; i < targetList.Count; i++)
        {
            BattleControl.instance.ApplySkill(m_skillData, m_owner, targetList[i]);
        }
    }
}