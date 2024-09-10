using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomMove : MonoBase
{

    private SkillObject m_parent;

    private Vector3 m_dir = Vector3.zero;
    private float m_speed = 1.0f;

    public void Init(SkillObject _parent ,Vector3 _pos , float _speed)
    {
        m_parent = _parent;
        transform.position = _pos;
        m_speed = _speed;
        SetChangeDir();
    }

    public void SetChangeDir()
    {
        m_dir = Random.insideUnitCircle.normalized;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        Vector3 _targtPos = transform.position + m_dir * m_speed * Time.fixedDeltaTime;

        if (CameraManager.instance.isOverMap(_targtPos))
            SetChangeDir();
        else if(CameraManager.instance.IsOverCamera(_targtPos))
        {
            m_dir = (StagePlayLogic.instance.m_Player.transform.position - transform.position).normalized;
            transform.position = transform.position + m_dir * m_speed * Time.fixedDeltaTime;
        }
        else
            transform.position = _targtPos;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag.Equals("Monster")) {
            m_parent.OnTriggerEnterChild(collision);
            SetChangeDir();
        }
            
    }


}
