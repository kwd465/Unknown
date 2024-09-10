using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Monster : Player
{
    
    private float m_checkAttackTime = 0f;


    public override void Init(e_PlayerType _type, PlayerData _data, PlayerFsmFactory _fsm, Vector3 _pos)
    {
        if (m_damageList != null)
            m_damageList.Clear();

        m_checkAttackTime =1f;
        m_navMeshAgent.updateRotation = false;
        m_navMeshAgent.updateUpAxis = false;

        isAttack = false;
        PlayerType = _type;
        transform.position = _pos;
        m_skillList.Clear();
        m_damageList = new PoolObjectGroup<DamageEffect>(m_trDamage);
        m_Data = _data;
        m_fsm = _fsm.Create(this);
        m_PlayerAni = new PlayerAni_Sprite(transform.GetComponentInChildren<SpriteRenderer>());
        m_fsm.SetState(ePLAYER_STATE.move);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if(m_checkAttackTime >= 1f)
            return;

        m_checkAttackTime += Time.fixedDeltaTime;
    
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag.Equals("Player")){
            if(isAttack)
                return;
            StartCoroutine("Attack");
            NavMeshAgent.isStopped = true;
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.gameObject.tag.Equals("Player"))
        {
            isAttack = false;
            StopCoroutine("Attack");
            NavMeshAgent.isStopped = false;
            Rig.velocity = Vector2.zero;
        }
    }

    IEnumerator Attack()
    {
        isAttack = true;
        while(isAttack)
        {
            if(getData.IsDead())
            {
                break;
            }

            if(m_checkAttackTime >= 1f)
            {
                m_checkAttackTime = 0;
                StagePlayLogic.instance.m_Player.SetDamage(getData.GetStatValue(eSTAT.atk));
            }
            yield return null;
        }
        yield break;
    }

}
