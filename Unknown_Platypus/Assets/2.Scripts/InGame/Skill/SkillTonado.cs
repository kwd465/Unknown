using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

public class SkillTonado : SkillObject
{
    [SerializeField] SkillCollisionChild[] planets;

    float elapsedTime;
    float m_rSpeed = 1f;
    private void Awake()
    {
        foreach (SkillCollisionChild planet in planets)
        {
            planet.SetParent(this);
        }
    }


    public override void Apply()
    {
        base.Apply();
        transform.SetParent(m_owner.transform);
        gameObject.SetActive(true);
        m_rSpeed = 1f + m_skillData.GetOptionValue(SKILLOPTION_TYPE.speed);
        elapsedTime = 0;
        int _count = m_count;
        for(int i = 0 ; i< _count; i++)
        {
            planets[i].gameObject.SetActive(true);
            planets[i].SetColliderActive(true);
            planets[i].targetList.Clear();


            float angle = i * Mathf.PI * 2 / _count;
            float x = Mathf.Cos(angle) * 4f;
            float y = Mathf.Sin(angle) * 4f;
            planets[i].transform.localPosition = new Vector3(x, y, 0);

        }

        for(int i = m_count; i < planets.Length; i++)
        {
            planets[i].gameObject.SetActive(false);
            planets[i].SetColliderActive(false);
        }

    }

    override public void UpdateLogic()
    {
          elapsedTime += Time.fixedDeltaTime;

        transform.Rotate(Vector3.forward, 180 * SkillData.skilllv * 0.25f * Time.fixedDeltaTime* m_rSpeed );

        if (elapsedTime >= m_duration)
        {
            elapsedTime = 0;

            foreach (SkillCollisionChild planet in planets)
            {
                planet.gameObject.SetActive(false);
                planet.SetColliderActive(true);
            }
      
            Close();
        }
    }


    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }


}
