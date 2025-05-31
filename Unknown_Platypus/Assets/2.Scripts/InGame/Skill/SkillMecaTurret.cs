using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;
using Spine.Unity;
using UnityEditor;
using UnityEngine;

public class SkillMecaTurret : SkillObject
{
    [SerializeField] Transform m_trBullet;
    [SerializeField]SpineAnimation m_spineTop;
    [SerializeField] SpineAnimation m_spineBottom;
    [SerializeField] TargetObjectRandomMove m_randomMove;
    [SerializeField] SpriteRenderer NuclearTargetSprite;

    int m_state = 0;

    float m_checkTime = 0f;
    float nowNormalCoolTime = 0;
    float nowNuclearCoolTime = 0;

    float maxNormalCoolTime { get => m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue; }
    float maxNuclearCoolTime { get=> m_skillData.m_skillTable.skillEffectDataList[2].skillEffectValue; }


    public override void Apply()
    {
        base.Apply();
        m_state = 0;
        m_checkTime = 0;
        nowNormalCoolTime = 0;
        nowNuclearCoolTime = 0;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;
        nowNormalCoolTime += Time.fixedDeltaTime;
        m_randomMove.UpdateLogic();

        if (nowNormalCoolTime >= maxNormalCoolTime)
        {
            Player _target = GameUtil.GetAreaTarget(m_owner, m_area, m_distance, false, true);
            if (_target == null)
                return;

            Vector3 _dir = (_target.transform.position - transform.position);

            Effect _bullet = EffectManager.instance.Play("MecaBullet", gameObject.transform.position, Quaternion.FromToRotation(Vector3.right,_dir));
            var bullet = _bullet.GetComponent<SkillBullet>();
            bullet.Init(m_skillData, _target, m_owner, _dir);
            _bullet.gameObject.transform.rotation = Quaternion.FromToRotation(Vector3.right, _dir);

            //if (moveCoroutine is not null)
            //{
            //    StopCoroutine(moveCoroutine);
            //}

            //moveCoroutine = StartCoroutine(CoMoveToTarget(_bullet, _target, _dir));

            nowNormalCoolTime = 0;
        }

        if (m_skillData.m_skillTable.skilllv == ConstData.SkillMaxLevel)
        {
            nowNuclearCoolTime += Time.fixedDeltaTime;

            if (nowNuclearCoolTime >= maxNuclearCoolTime)
            {
                Player _target = GameUtil.GetAreaTarget(m_owner, m_area, m_distance, false, true);
                if (_target == null)
                    return;

                Vector3 _dir = (_target.transform.position - transform.position);

                Effect _bullet = EffectManager.instance.Play("Nuclear", gameObject.transform.position, Quaternion.FromToRotation(Vector3.right, _dir));
                var bullet = _bullet.GetComponent<SkillBullet>();
                bullet.InitPosSetting(m_skillData, _target.transform.position, m_owner, _dir, true);
                bullet.transform.position = new Vector2(_target.transform.position.x, _target.transform.position.y + 5);
                //_bullet.gameObject.transform.rotation = Quaternion.FromToRotation(Vector3.up, _dir);
                _bullet.gameObject.transform.rotation = Quaternion.Euler(0, 0, 180);
                nowNuclearCoolTime = 0;
            }
        }

        if (m_checkTime >= m_duration)
            Close();
    }

    //Coroutine moveCoroutine = null;
    //float moveTime = 0.25f;

    //IEnumerator CoMoveToTarget(Effect _bullet , Player _target,Vector3 _dir )
    //{
    //    SkillObject _obj = _bullet.GetComponent<SkillObject>();
        
    //    float elapseTIme = 0;

    //    Vector3 firstPos = gameObject.transform.position;
    //    _bullet.gameObject.transform.position = firstPos;
    //    Debug.Log($@"bullet game object {_bullet.gameObject.name} {_bullet.gameObject.activeSelf}");
    //    while (elapseTIme < moveTime)
    //    {
    //        elapseTIme += Time.deltaTime;
    //        _bullet.transform.position = Vector3.Lerp(firstPos, _target.gameObject.transform.position, elapseTIme / moveTime);
    //        yield return null;
    //    }

    //    _obj.Init(m_skillData, _target, m_owner, _dir);
    //}
}