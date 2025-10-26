using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;
using Spine.Unity;
using UnityEditor;
using UnityEngine;
using Cysharp.Threading.Tasks;

public class SkillMecaTurret : SkillObject
{
    [SerializeField] Transform m_trBullet;
    [SerializeField] SpineAnimation m_spineTop;
    [SerializeField] SpineAnimation m_spineBottom;
    [SerializeField] TargetObjectRandomMove m_randomMove;
    [SerializeField] SpriteRenderer NuclearTargetSprite;

    int m_state = 0;

    float m_checkTime = 0f;
    float nowNormalCoolTime = 0;
    float nowNuclearCoolTime = 0;

    float maxNormalCoolTime { get => m_skillData.m_skillTable.skillEffectDataList[1].skillEffectValue[0]; }
    float maxNuclearCoolTime { get => m_skillData.m_skillTable.skillEffectDataList[2].skillEffectValue[0]; }


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
            Player _target = GameUtil.GetAreaTarget(gameObject.transform.position, m_owner, m_area, m_distance, false, true);
            if (_target == null)
                return;

            Vector3 _dir = (_target.transform.position - transform.position);

            Effect _bullet = EffectManager.instance.Play("MecaBullet", gameObject.transform.position, Quaternion.identity);
            _bullet.gameObject.SetActive(false);
            var bullet = _bullet.GetComponent<SkillBullet>();
            bullet.Init(m_skillData, _target, m_owner, gameObject.transform.position, _dir, 1, true);
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
                Player _target = GameUtil.GetAreaTarget(gameObject.transform.position, m_owner, m_area, m_distance, false, true);
                if (_target == null)
                    return;

                Vector2 randomPos = new Vector2(Random.Range(-m_distance, m_distance), Random.Range(-m_distance, m_distance));

                int random = UnityEngine.Random.Range(0, 2);
                Vector2 targetPos = random == 0 ? gameObject.transform.position : m_owner.transform.position;
                randomPos += targetPos;
                Vector2 bulletPos = new Vector2(randomPos.x, randomPos.y + 25);

                Effect _bullet = EffectManager.instance.Play("Nuclear", gameObject.transform.position, Quaternion.identity);
                _bullet.gameObject.SetActive(false);
                var bullet = _bullet.GetComponent<SkillBullet>();
                bullet.InitWithOutTarget(m_skillData, randomPos, bulletPos, m_owner, Vector3.down, _targetCount: int.MaxValue, false, true, false, 2);

                _bullet.gameObject.transform.rotation = Quaternion.Euler(0, 0, 180);
                nowNuclearCoolTime = 0;
            }
        }

        if (m_checkTime >= m_duration)
            Close();
    }
}