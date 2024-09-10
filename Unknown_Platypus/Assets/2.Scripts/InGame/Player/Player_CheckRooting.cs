using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Player_CheckRooting : MonoBehaviour
{
    [SerializeField]
    private CircleCollider2D m_collider2D;
    
    public void SetArea(float _area)
    {
        m_collider2D.radius = _area;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Item")
        {
            //»πµÊ«—¥Ÿ
            collision.GetComponent<DropItem>()?.Rooting();
        }
    }


}