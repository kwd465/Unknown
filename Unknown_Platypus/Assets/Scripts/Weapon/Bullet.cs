using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{

    float speed;
    float totalTime;

    float elapsedTime;

    public HashSet<GameObject> targetList = new HashSet<GameObject>();

    // Update is called once per frame
    void Update()
    {

        elapsedTime += Time.deltaTime;

        if( elapsedTime >= totalTime  )
        {
            gameObject.SetActive(false);
            targetList.Clear();
            return;
        }
        
        transform.position += speed * Time.deltaTime * transform.right;        
    }

    public void Shot( Vector3 startPos, float speed, Vector3 dir, float totalTime)
    {
        transform.position = startPos;
        transform.right = dir;
        this.speed = speed;
        this.totalTime = totalTime;
        elapsedTime = 0;

        gameObject.SetActive(true);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster" || targetList.Contains(collision.gameObject))
            return;

        targetList.Add(collision.gameObject);
        BattleManager.instance.Attacking(10, collision.GetComponent<ActorBase>());
    }
}
