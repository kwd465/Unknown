using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using BH;
using static UnityEngine.GraphicsBuffer;
using System.Runtime.InteropServices.ComTypes;


public class SkillBullet : SkillObject
{
    private int effectIndex = 1;
    int targetCount = 1;
    private float m_checkDistace = 0f;
    float time = 0;
    private bool isPosSetting = false;
    //private Player m_target;
    Player target;
    private Vector3 targetPos;
    System.Action callBackAction;

    public void Init(SkillEffect _data, Player _target, Player _owner, Vector3 _dir , int _targetCount)
    {
        gameObject.SetActive(false);
        base.Init(_data, _target, _owner, _dir);
        //m_target = _target;
        target = _target;
        targetList.Clear();
        targetList.Add(target);
        isPosSetting = false;
        SetRotation();

        ImpactEffectPlay(_target.gameObject.transform.position);

        if (impactEffect != null)
        {
            impactEffect.gameObject.transform.SetParent(target.gameObject.transform);
        }

        effectIndex = 1;
        targetCount = _targetCount;
        gameObject.SetActive(true);
    }

    public void InitPosSetting(SkillEffect _data, Vector2 _targetPos, Vector2 _initPos, Player _owner, Vector3 _dir, int _targetCount, bool _isNotSetRotation = false, int _effectIndex = 0 )
    {
        gameObject.SetActive(false);
        targetPos = _targetPos;
        transform.position = _initPos;
        target = null;
        targetList.Clear();
        base.Init(_data, target, _owner, _dir);
        targetCount = _targetCount;
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
        gameObject.SetActive(true);
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
                //if (m_target != null)
                //{
                //    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_target, effectIndex);
                //}
                //else
                //{

                //}
                foreach(var target in targetList)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, target, effectIndex);
                }

                HitEffectPlay(targetPos);
                Close();
            }

            return;
        }

        if (target == null)
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
            transform.position = Vector3.MoveTowards(transform.position, target.transform.position, Time.deltaTime * 8f);

            if (Vector2.Distance(transform.position, target.transform.position) < 0.2f)
            {
                //if (target.getData.HP >= 0)
                //{
                //    BattleControl.instance.ApplySkill(m_skillData, m_owner, target, effectIndex);
                //}
                foreach (var target in targetList)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, target, effectIndex);
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

        if(targetCount <= targetList.Count)
        {
            return;
        }

        var enemy = collision.GetComponent<Player>();

        if (targetList.Contains(enemy))
        {
            return;
        }

        targetList.Add(enemy);

        //if (targetCount == 1)
        //{
        //    if (m_target == null)
        //    {
        //        m_target = enemy;
        //    }

        //    return;
        //}

    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.tag != "Monster")
        {
            return;
        }

        var enemy = collision.GetComponent<Player>();

        //if (m_target != null)
        //{
        //    if (m_target.gameObject.GetHashCode() == collision.gameObject.GetHashCode())
        //    {
        //        m_target = null;
        //    }
        //}

        if (targetList.Contains(enemy) == false)
        {
            return;
        }

        targetList.Remove(enemy);
    }
}