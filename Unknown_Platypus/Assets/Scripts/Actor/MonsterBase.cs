using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterBase : ActorBase
{
    protected bool isAttack = false;

    private void Awake()
    {
        rigid = GetComponent<Rigidbody2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    protected void FixedUpdate()
    {
        //FSM();

        if (!isLive)
            return;

        if (HP <= 0)
        {
            Die();
            return;
        }

        Move();
    }

    private void LateUpdate()
    {
        //.flipX = target.rigid.position.x < rigid.position.x;
    }

    public override void init(DataManager.State data)
    {
        state = data;
        state.AttackType = WeaponStyle.Melee;
        HP = 10;
        actorType = ActorType.Monster;
        animator = GetComponent<Animator>();
        spriteRenderer = GetComponent<SpriteRenderer>();
        rigid = GetComponent<Rigidbody2D>();
        status = ActorStatus.Idle;
        //weapon = state.AttackType == WeaponStyle.Melee ? new Melee() : new Arrow();        
        weapon = null;
        isLive = true;

        
    }

    protected override void Move()
    {
        //Vector2 dirVec = target.Rig.position - rigid.position;
        //Vector2 nextVec = dirVec.normalized * state.moveSpeed * Time.fixedDeltaTime;
        //rigid.MovePosition(rigid.position + nextVec);
        //rigid.velocity = Vector2.zero;
    }

    public override void SetHP(float damage)
    {
        HP -= damage;
        status = ActorStatus.Hit;
    }
    protected override void Die()
    {
        //animator.SetBool("Die", true);
        isLive = false;
        HP = 0;
        BattleManager.instance.GetDropItem(this);
        ObjectPoolManager.instance.DieMonsterAdd(this);
        gameObject.SetActive(false);
    }
    protected virtual IEnumerator Attack()
    {
        isAttack = true;
        while (isAttack)
        {
            //BattleManager.instance.Attacking(state.atk, target);
            yield return new WaitForSeconds(state.attackSpeed);
        }
        yield break;
    }
    public override void SkillHit(SkillBase skill)
    {
        //StartCoroutine(SkillDelay(skill.GetTime, skill));
        StartCoroutine(SkillDelay(1, skill));
    }

    IEnumerator SkillDelay(float time, SkillBase skill)
    {
        yield return new WaitForSeconds(time);
        //skill.RemoveTarget(this);
        yield break;
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {     
        if (collision.tag != "Player" )
            return;

        //Debug.Log("!!Monster TriggerEnter " + collision.tag);

        //target = collision.GetComponent<Player>();
        StartCoroutine(Attack());
    }
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.tag != "Player")
            return;

        //if (collision.gameObject == target.gameObject)
        //    isAttack = false;
    }
}
