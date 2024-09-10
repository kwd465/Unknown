using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillBlackhole : SkillObject
{
    Collider2D collider2d;
    int state = 0;
    float elapsedTime = 0;

    class Target
    {
        public float hitTime;
        public GameObject gameObject;
    }

    new List<Target> targetList = new List<Target>();

    private void Awake()
    {
        collider2d = GetComponent<Collider2D>();
        Debug.Log($"Get BlakHole Collider2d {collider2d}");
        state = 0;
    }


    public override void Apply(Player _target)
    {
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        collider2d.enabled = false;
        targetList.Clear();

        transform.position = (Vector2)m_owner.transform.position + (Random.insideUnitCircle * 6f);
    }

   


    private void FixedUpdate()
    {
        elapsedTime += Time.fixedDeltaTime;

        if(state == 0)
        {
            if( elapsedTime>=0.5f)
            {
                state = 1;
                collider2d.enabled = true;
            }
        }
        else if( state == 1)
        {
            foreach(var enemy in targetList)
            {
                var dir = (transform.position - enemy.gameObject.transform.position).normalized;
                enemy.gameObject.transform.position += dir * 3f * Time.fixedDeltaTime;

                enemy.hitTime += Time.fixedDeltaTime;
                if(enemy.hitTime>=0.5f)
                {
                    enemy.hitTime = 0;
                    BattleManager.instance.Attacking(1, enemy.gameObject.GetComponent<ActorBase>());
                }
            }

            if(elapsedTime >= 2.0f)
            {
                foreach (var enemy in targetList)
                {
                    BattleManager.instance.Attacking(100, enemy.gameObject.GetComponent<ActorBase>());
                }

                collider2d.enabled = false;
                state = 2;
            }
        }
        else if( state == 2)
        {
            if(elapsedTime >= 4f)
            {
                targetList.Clear();
                gameObject.SetActive(false);
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster" )            
            return;

        if(targetList.Exists(e=>e.gameObject==collision.gameObject))        
            return;       

        Target target = new Target();
        target.gameObject = collision.gameObject;
        target.hitTime = 0;
        targetList.Add(target);
        //BattleManager.instance.Attacking(1, collision.GetComponent<ActorBase>());
    }

}
