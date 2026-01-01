using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class SkillSatelliteDrawn : MonoBase
{
    SkillObject useSkillSkillObj;
    Player useUnit;
    Player target;

    readonly float attackDelay = 0.5f;
    float nowAttackDelay = 0;
    
    public float moveSpeed = 5f;
    public float turnSpeed = 180f;
    public float minDistance = 1.5f;
    public float maxDistance = 4f;
    public float randomOffsetRange = 0.5f;

    private Vector2 moveDir;
    private Vector2 targetOffset; // 타겟 기준 오프셋

    public void Init(SkillObject _skillObj , Player _useUnit)
    {
        useSkillSkillObj = _skillObj;
        useUnit = _useUnit;
        nowAttackDelay = 0;

        gameObject.SetActive(true);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if (target == null || target.getData.HP == 0)
        {
            target = GameUtil.GetAreaTarget(gameObject.transform.position, useUnit, useSkillSkillObj.m_area, useSkillSkillObj.m_distance, false, true);
        }

        if (target == null)
        {
            return;
        }

        // 타겟이 움직이면, 목표 위치를 항상 타겟 위치 기준으로 보정
        Vector2 targetPos = (Vector2)target.transform.position + targetOffset;

        // 타겟 위치 기준으로 오프셋이 너무 멀어지면 새로 갱신
        float distToOffset = Vector2.Distance(transform.position, targetPos);
        if (distToOffset < 0.5f || distToOffset > maxDistance * 1.5f)
        {
            targetOffset = GetRandomOffset();
        }

        // 이동 방향 보정
        Vector2 dirToTarget = (targetPos - (Vector2)transform.position).normalized;
        moveDir = Vector2.Lerp(moveDir, dirToTarget, Time.deltaTime * (turnSpeed / 100f));

        // 이동
        transform.position += (Vector3)(moveDir * moveSpeed * Time.deltaTime);

        // 회전 (2D 스프라이트 기준)
        float angle = Mathf.Atan2(moveDir.y, moveDir.x) * Mathf.Rad2Deg;
        transform.rotation = Quaternion.Euler(0, 0, angle - 90);

        nowAttackDelay += Time.deltaTime;

        if(nowAttackDelay >= attackDelay)
        {
            if (target == null || target.getData.HP <= 0 )
                return;

            Vector3 _dir = (target.transform.position - transform.position);

            Effect _bullet = EffectManager.instance.Play("SatelliteBullet02", gameObject.transform.position, Quaternion.identity);
            _bullet.gameObject.SetActive(false);
            var bullet = _bullet.GetComponent<SkillBullet>();
            bullet.Init(useSkillSkillObj.SkillEffect, target, useUnit, gameObject.transform.position, _dir, 1, true);
            _bullet.gameObject.transform.rotation = Quaternion.FromToRotation(Vector3.right, _dir);

            nowAttackDelay = 0;
        }
    }

    public void SetTarget(Player _target)
    {
        target = _target;
    }


    // 목표 주변 랜덤 포인트 생성
    Vector2 GetRandomOffset()
    {
        float distance = Random.Range(minDistance, maxDistance);
        float angle = Random.Range(0f, 360f) * Mathf.Deg2Rad;
        Vector2 baseOffset = new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * distance;
        Vector2 randomOffset = Random.insideUnitCircle * randomOffsetRange;
        return baseOffset + randomOffset;
    }
}