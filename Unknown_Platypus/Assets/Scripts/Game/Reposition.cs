using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Reposition : MonoBehaviour
{

    Collider2D coll;

    private void Awake()
    {
        coll = GetComponent<Collider2D>();
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (!collision.CompareTag("Area"))
            return;

        Vector3 playerPos = Vector3.zero;//GameManager.instance.player.transform.position;
        Vector3 myPos = transform.position;

        float diffX = Mathf.Abs(playerPos.x - myPos.x);
        float diffY = Mathf.Abs(playerPos.y - myPos.y);

        Vector3 playerDir = Vector3.zero;
        float dirX = playerDir.x < 0 ? -1 : 1;
        float dirY = playerDir.y < 0 ? -1 : 1;

        switch(transform.tag)
        {
            case "Ground":
                if(diffX > diffY)
                {
                    transform.Translate(Vector3.right * dirX * 80);
                }
                else if( diffX < diffY)
                {
                    transform.Translate(Vector3.up * dirY * 80);
                }
                break;

            case "Monster":
                if(coll.enabled)
                {
                    transform.Translate(playerDir * 30 + new Vector3(Random.Range(-3f, 3), Random.Range(-3f, 3f), 0));
                }
                break;
        }

        
    }
}
