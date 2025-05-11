using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using BH;
using static UnityEngine.GraphicsBuffer;


public class SkillBullet : SkillObject
{
    private float m_checkDistace = 0f;
    private Player m_target;

    System.Action callBackAction;

    public override void Init(SkillEffect _data, Player _target, Player _owner, Vector3 _dir)
    {
        base.Init(_data, _target, _owner, _dir);
        m_target = _target;
        SetRotation();

        ImpactEffectPlay(_target.gameObject.transform.position);

        if (impactEffect != null)
        {
            impactEffect.gameObject.transform.SetParent(m_target.gameObject.transform);
        }
    }

    public void InitNotSetRotation(SkillEffect _data, Player _target, Player _owner, Vector3 _dir)
    {
        base.Init(_data, _target, _owner, _dir);
        m_target = _target;
        //SetRotation();

        ImpactEffectPlay(_target.gameObject.transform.position);

        if (impactEffect != null)
        {
            impactEffect.gameObject.transform.SetParent(m_target.gameObject.transform);
        }
    }

    override public void UpdateLogic()
    {
        base.UpdateLogic();

        if (m_target == null)
        {
            m_checkDistace += Time.deltaTime * 8f;
            transform.position += m_dir * Time.deltaTime * 8f;
            if (m_checkDistace == m_skillData.GetBaseAddValue(SKILLOPTION_TYPE.distance))
            {
                HitEffectPlay(transform.position);

                Close();
            }
        }
        else
        {
            transform.position = Vector3.MoveTowards(transform.position, m_target.transform.position, Time.deltaTime * 8f);
            //transform.rotation = Quaternion.LookRotation(Vector3.forward, m_target.transform.position - transform.position);

            //if (m_target.getData.HP <= 0)
            //{
            //    Close();
            //}

            if (Vector2.Distance(transform.position, m_target.transform.position) < 0.2f)
            {
                if (m_target.getData.HP >= 0)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_target);
                }

                HitEffectPlay(transform.position);
                Close();
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.tag.Equals("Monster"))
        {

            if(m_target == null){
                BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
                HitEffectPlay(transform.position);
                Close();
            }
        }

    }


}
