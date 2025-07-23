using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using BH;
using static UnityEngine.GraphicsBuffer;
using System.Runtime.InteropServices.ComTypes;


public class SkillBullet : SkillObject
{
    private int effectIndex = 0;
    private float m_checkDistace = 0f;
    float time = 0;
    private Player m_target;
    private Vector3 targetPos;
    private bool isPosSetting = false;
    System.Action callBackAction;

    public override void Init(SkillEffect _data, Player _target, Player _owner, Vector3 _dir)
    {
        base.Init(_data, _target, _owner, _dir);
        m_target = _target;
        isPosSetting = false;
        SetRotation();

        ImpactEffectPlay(_target.gameObject.transform.position);

        if (impactEffect != null)
        {
            impactEffect.gameObject.transform.SetParent(m_target.gameObject.transform);
        }

        effectIndex = 0;
    }

    public void InitPosSetting(SkillEffect _data, Vector2 _targetPos, Vector2 _initPos, Player _owner, Vector3 _dir, bool _isNotSetRotation = false, int _effectIndex = 0)
    {
        m_target = null;
        m_taretList.Clear();
        base.Init(_data, m_target, _owner, _dir);

        targetPos = _targetPos;
        transform.position = _initPos;
        isPosSetting = true;

        if (_isNotSetRotation is false)
        {
            SetRotation();
        }

        ImpactEffectPlay(targetPos);

        if (impactEffect != null)
        {
            impactEffect.gameObject.transform.SetParent(null);
        }

        effectIndex = _effectIndex;
    }

    override public void UpdateLogic()
    {
        base.UpdateLogic();

        if (isPosSetting)
        {
            transform.position = Vector3.MoveTowards(transform.position, targetPos, Time.deltaTime * 8f);
            time += Time.deltaTime;
            if (Vector2.Distance(transform.position, targetPos) < 0.2f)
            {
                if (m_target != null)
                {
                    Debug.Log($@"active damage nuclear {time} ");
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_target, effectIndex);
                }
                else
                {

                }

                HitEffectPlay(targetPos);
                Close();
            }

            return;
        }

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

            if (Vector2.Distance(transform.position, m_target.transform.position) < 0.2f)
            {
                if (m_target.getData.HP >= 0)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_target, effectIndex);
                }

                HitEffectPlay(transform.position);
                Close();
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
        {
            return;
        }

        if (m_target == null)
        {
            m_target = collision.GetComponent<Player>();
            Debug.Log($@"find target m_target {m_target != null} {gameObject.name}");
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
        {
            return;
        }

        if (m_target != null)
        {
            if (m_target.gameObject.GetHashCode() == collision.gameObject.GetHashCode())
            {
                m_target = null;
            }
        }
    }
}