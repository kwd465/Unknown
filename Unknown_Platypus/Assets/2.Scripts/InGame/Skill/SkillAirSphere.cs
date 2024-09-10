using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillAirSphere : SkillObject
{
    [SerializeField] SkillCollisionChild[] sphere;
    [SerializeField] SkillCollisionChild[] subSphere;


    Vector2[] defaultPosMain = new Vector2[4];
    Vector2[] defaultPosSub = new Vector2[4];

    private float m_checkTime = 0;
    private float m_speed = 0;
    private float m_checkDistance = 0;

    private void Awake()
    {
        for( int i=0; i<4; i++)
        {
            defaultPosMain[i] = sphere[i].transform.localPosition;
            defaultPosSub[i] = subSphere[i].transform.localPosition;
            sphere[i].SetParent(this);
            subSphere[i].SetParent(this);
        }
    }

    public override void Apply()
    {
        base.Apply();
        m_checkTime = 0;
        m_checkDistance = 0;
        transform.position = m_owner.transform.position;
        m_speed = m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.distance) / m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration)* 3f;
        int i = 0;
        foreach (var obj in sphere)
        {
            obj.gameObject.SetActive(false);
            obj.gameObject.SetActive(true);
            obj.SetColliderActive(true);
            obj.targetList.Clear();
            obj.transform.localPosition = defaultPosMain[i++];
        }

        if (m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.count) > 1)
        {
            i = 0;
            foreach (var obj in subSphere)
            {
                obj.gameObject.SetActive(false);
                obj.gameObject.SetActive(true);
                obj.SetColliderActive(true);
                obj.targetList.Clear();
                obj.transform.localPosition = defaultPosSub[i++];
            }
        }
        else
        {
            i = 0;
            foreach (var obj in subSphere)
            {
                obj.gameObject.SetActive(false);
                obj.gameObject.SetActive(false);
                obj.SetColliderActive(false);
                obj.targetList.Clear();
                obj.transform.localPosition = defaultPosSub[i++];
            }
        }
    }

    public override void UpdateLogic()
    {
        m_checkTime += Time.fixedDeltaTime;
        m_checkDistance += m_speed * Time.fixedDeltaTime;
        foreach (var obj in sphere)
        {
            obj.transform.position += obj.transform.right * m_speed * Time.fixedDeltaTime;
        }

        foreach (var obj in subSphere)
        {
            obj.transform.position += obj.transform.right * m_speed * Time.fixedDeltaTime;
        }

        if(m_checkDistance >= m_distance)
        {
            Close();
        }

        if (m_checkTime >= m_duration)
        {
            Close();
        }
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }
}
