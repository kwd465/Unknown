using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillShotGun : SkillBase
{
    PolygonCollider2D checkCollider;        

    private void Awake()
    {
        checkCollider = GetComponent<PolygonCollider2D>();
        checkCollider.enabled = false;
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
        checkCollider.enabled = true;
    }

    private void FixedUpdate()
    {
        elapsedTime += Time.fixedDeltaTime;


        if (state == 0)
        {
            if (elapsedTime >= 0.1f)
            {
                state = 1;
                checkCollider.enabled = false;
            }
        }
        else if (state == 1)
        {
            if (elapsedTime >= 0.1f)
            {
                state = 2;
                targetList.Clear();
                checkCollider.enabled = true;
            }
        }
        else if (state == 2)
        {
            if (elapsedTime >= 0.1f)
            {
                state = 3;
                checkCollider.enabled = false;
            }
        }
        else if (state == 3)
        {
            if (elapsedTime >= 1f)
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
