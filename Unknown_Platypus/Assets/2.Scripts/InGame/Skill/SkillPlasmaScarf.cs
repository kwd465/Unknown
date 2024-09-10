using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillPlasmaScarf : SkillBase
{

    Collider2D collider2d;


    private void Awake()
    {
        collider2d = GetComponent<Collider2D>();
        collider2d.enabled = false;
    }

    public override void Init()
    {
        gameObject.SetActive(false);
        state = 0;
    }

    public override void UseSkill(Vector3 pos)
    {
        gameObject.SetActive(true);
        state = 0;
        elapsedTime = 0;
        collider2d.enabled = true;
        targetList.Clear();

        transform.position = (Vector2)pos + (Random.insideUnitCircle * 7f);

    }


    private void FixedUpdate()
    {
        elapsedTime += Time.fixedDeltaTime;

        if( state == 0 )
        {
            if( elapsedTime >=0.5f)
            {
                collider2d.enabled = false;
                state = 1;
            }
        }
        else if( state ==1 )
        {
            if(elapsedTime >= 1f)
            {                
                targetList.Clear();
                gameObject.SetActive(false);
            }
        }
    }


    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster" || targetList.Contains(collision.gameObject))
            return;

        targetList.Add(collision.gameObject);
        BattleManager.instance.Attacking(1, collision.GetComponent<ActorBase>());
    }

}
