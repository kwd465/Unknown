using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{

    public Transform[] spawnPoint;

    float timer;

    private void Awake()
    {
        spawnPoint = GetComponentsInChildren<Transform>();
        
    }

    private void Update()
    {
        //timer += Time.deltaTime;

        //if(timer>1.2f)
        //{
        //    Spawn();
        //    timer = 0;
        //}
    }

    void Spawn()
    {
        int id = 1;
        Transform point = spawnPoint[Random.Range(1, spawnPoint.Length)];
        FactoryManager.instance.MonsterFactory(id, point);
    }


}
