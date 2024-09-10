using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;

public class SkillCollisionChild : MonoBehaviour
{

    [SerializeField]
    private bool m_isContainCheck = true;

    new Collider2D collider;

    SkillObject parent;

    public HashSet<GameObject> targetList = new HashSet<GameObject>();

    public void DelaySetActive(bool isActive, float delay)
    {
        StartCoroutine(DelaySetActiveCoroutine(isActive, delay));
        
    }

    IEnumerator DelaySetActiveCoroutine(bool isActive, float delay)
    {
        yield return new WaitForSeconds(delay);
        SetColliderActive(isActive);
        yield return  new WaitForSeconds(0.1f);
        SetColliderActive(!isActive);
    }

    public void SetParent(SkillObject parent)
    {
        collider = GetComponent<Collider2D>();
        this.parent = parent;
        SetColliderActive(false);
    }

    public void SetArea(float _area){

        if(collider is CircleCollider2D)
        {
            ((CircleCollider2D)collider).radius = _area;
        }
        else if(collider is BoxCollider2D)
        {
            ((BoxCollider2D)collider).size = new Vector2(_area, _area);
        }
    }   


    public void SetColliderActive(bool isActive)
    {
        collider.enabled = isActive;
        targetList.Clear();
    }

    
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
            return;

        if (m_isContainCheck && targetList.Contains(collision.gameObject))
            return;

        targetList.Add(collision.gameObject);

        parent.OnTriggerEnterChild(collision);
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
            return;

        if (m_isContainCheck && targetList.Contains(collision.gameObject))
            return;

       parent.OnTriggerExitChild(collision);
    }


}
