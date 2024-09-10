using System.Collections;
using System.Collections.Generic;
using BH;
using UnityEngine;

public class SkillEnegeBomb : SkillObject
{
  
    [SerializeField]
    private SkillCollisionChild m_collisionChild;

    float elapsedTime;

    private void Awake()
    {
        m_collisionChild.SetParent(this);
        m_collisionChild.SetColliderActive(false);
    }

    public override void Apply()
    {
        base.Apply();
        elapsedTime = 0;
        m_collisionChild.SetColliderActive(true);

        float _area = m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.area);
        transform.localScale = new Vector3(_area , _area, _area);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        elapsedTime += Time.fixedDeltaTime;
        if (elapsedTime >= m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.duration))
        {
            elapsedTime = 0;
            Close();
        }
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }
}
