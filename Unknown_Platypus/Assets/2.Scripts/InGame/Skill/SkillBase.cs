using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum SkillType
{
    Planet,
    Pulsebeam,
    Elemental,
    Airsphere
}

public class SkillBase : MonoBehaviour
{
    protected ActorBase actor;

    protected int level;
    protected int state;
    protected float elapsedTime = 0;    

    public HashSet<GameObject> targetList = new HashSet<GameObject>();
    
    
    public virtual void Init()
    {   
    }


    public virtual void UseSkill(Vector3 pos)
    {

    }

    public virtual void OnTriggerEnterChild(Collider2D collision)
    {

    }

    public virtual void SetLevel(int level)
    {

    }

    public ActorBase Actor
    {
        set
        {
            actor = value;
        }
        get
        {
            return actor;
        }
    }

}
