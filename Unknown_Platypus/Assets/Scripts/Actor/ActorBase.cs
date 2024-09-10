using DG.Tweening;
using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class ActorBase : MonoBehaviour
{
    public DataManager.State state;
    public ActorStatus status;
    public float HP;
    public Transform damagePos;
    public ActorType actorType;

    protected Animator animator;
    protected SkeletonAnimation skeletonAnimation;
    protected IWeapon weapon;
    protected Player target;
    protected SpriteRenderer spriteRenderer;
    public  Rigidbody2D rigid;
    public  BattleItem item = BattleItem.NONE;
    protected float knockbackForce = 3f;

    protected bool isLive = true;

    protected virtual void FSM()
    {
        //if (GameManager.instance.isPause)
        //    return;

        switch (status)
        {
            case ActorStatus.Idle:
                Idle();
                break;
            case ActorStatus.Move:
                Move();
                break;
            case ActorStatus.Hit:
                Hit(()=> {
                    if (HP > 0)
                        status = ActorStatus.Move;
                    else
                        status = ActorStatus.Die;
                });
                break;
            case ActorStatus.Attack:
                break;
            case ActorStatus.Die:
                Die();
                break;
        }
    }
    public virtual void SetHP(float damage)
    {
    }
    protected virtual void Idle()
    {
        if (target != null)
        {
            status = ActorStatus.Move;
           // animator.SetBool("Idle", false);
           // animator.SetBool("Move", true);
            return;
        }
        target = FindObjectOfType<Player>();
    }

    public virtual void SkillHit(SkillBase skill)
    { }
    public abstract void init(DataManager.State data);
    protected abstract void Move();
    protected abstract void Die();
    protected virtual void Hit(System.Action callback)
    {
        Vector2 knockbackDirection = (transform.position - target.transform.position).normalized;
        rigid.velocity = knockbackDirection * knockbackForce;
        spriteRenderer.DOColor(Color.red, 0.1f)
       .OnComplete(() =>
       {
           rigid.velocity = Vector3.zero;
           spriteRenderer.DOColor(Color.white, 0.1f);
           callback?.Invoke();
       });
    }
}
