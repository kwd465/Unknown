using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShotGun : MonoBehaviour, IWeapon
{
    [SerializeField] Bullet bullet;
    [SerializeField] GameObject effect;

    OldPlayer player;
    public HashSet<GameObject> targetList = new HashSet<GameObject>();

    Vector3 dir;

    float timer;
    float coolTime = 1;

    public void Init(OldPlayer _player)
    {
        player = _player;
        effect.transform.SetParent(null);
    }

    private void FixedUpdate()
    {
        timer += Time.fixedDeltaTime;
        if(timer>=coolTime)
        {
            timer = 0;
            Attack();
        }
    }

    public void Attack()
    {        
        StartCoroutine(AttackProcess());
    }
    
    IEnumerator AttackProcess()
    {
        int bulletCnt = 5;
        int gapDegree = 5;

        float angle = Mathf.Atan2(-dir.y, dir.x) * Mathf.Rad2Deg + 90;
        angle = angle - (bulletCnt * gapDegree) / 2;

        void MakeBullet(float newAngle)
        {
            Vector2 newDir = new Vector2(Mathf.Sin(newAngle * Mathf.Deg2Rad), Mathf.Cos(newAngle * Mathf.Deg2Rad));
            GameObject obj = Instantiate(bullet.gameObject);
            obj.GetComponent<Bullet>().Shot(transform.position, 15, newDir, 0.5f);
        }

        for (int i = 0; i < bulletCnt; i++)
        {
            MakeBullet(angle);
            angle += gapDegree;
        }

        effect.SetActive(false);
        effect.SetActive(true);
        effect.transform.position = transform.position + dir * 0.76f;
        effect.transform.right = dir;

        yield return new WaitForSeconds(0.5f);

        targetList.Clear();
        gameObject.SetActive(false);        

    }

    public void SetDir(Vector3 dir)
    {
        this.dir = dir;      
    }

    public void TargetListClear()
    {
        targetList.Clear();
    }

}
