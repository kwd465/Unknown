using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Melee : MonoBehaviour, IWeapon
{

    public GameObject[] effects;
    public List<GameObject> targetList = new List<GameObject>();
    OldPlayer player;
    Collider2D coll;

    float timer;
    float coolTime = 2;

    private void Awake()
    {
        coll = GetComponent<Collider2D>();
        coll.enabled = false;
    }

    public void Init(OldPlayer _player)
    {
        player = _player;
    
    }

    private void FixedUpdate()
    {
        timer += Time.fixedDeltaTime;

        if(timer > coolTime)
        {
            timer = 0;
            Attack();
        }

    }

    public void Attack()
    {
        coll.enabled = true;
        Vector3 f =  player.AttackAngle.localRotation * Vector3.up;        
        SetDir(f.normalized);
        
        IEnumerator AttackProcess()
        {
            yield return new WaitForSeconds(0.17f);
            EndAttack();
        }

        StartCoroutine(AttackProcess());
    }
    public void EndAttack()
    {
        effects[0].SetActive(false);
        effects[1].SetActive(false);
        coll.enabled = false;

        targetList.Clear();        
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {        
        if (collision.tag != "Monster" || targetList.Contains(collision.gameObject))
            return;
        
        targetList.Add(collision.gameObject);
        BattleManager.instance.Attacking(player.state.atk, collision.GetComponent<ActorBase>());
    }

    public void SetDir(Vector3 dir)
    {
        if (dir.x < 0)
        {
            effects[0].gameObject.SetActive(true);
            effects[1].gameObject.SetActive(false);            
        }
        else if (dir.x > 0)
        {
            effects[0].gameObject.SetActive(false);
            effects[1].gameObject.SetActive(true);
        }
    }

    public void TargetListClear()
    {
        targetList.Clear();
    }
}
