using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using DG.Tweening;
public class TargetObjectRandomMove : MonoBase
{
    public bool m_isDir = false;
       
    public float moveSpeed = 3f; // 이동 속도

    public Vector2 startPoint; // 시작점
    public Vector2 controlPoint; // 제어점
    public Vector2 endPoint; // 끝점

    private float t; // 베지어 곡선 위치 파라미터

    public Vector2 patrolAreaCenter; // 영역 중심
    public Vector2 patrolAreaSize = new Vector2(10f,10f); // 영역 크기


    public void SetMoveSpeed(float _speed)
    {
        moveSpeed = _speed;
    }

    public void OnEnable()
    {
        t = 0f; // 초기 위치 파라미터 설정
         // 랜덤한 점 설정
        startPoint = GetRandomPointInPatrolArea();
        controlPoint = GetRandomPointInPatrolArea();
        endPoint = GetRandomPointInPatrolArea();
    }


    override public void UpdateLogic()
    {
                    
        // 베지어 곡선 위치 계산
        Vector2 position = CalculateBezierPoint(t, startPoint, controlPoint, endPoint);
        
        Vector2 _dir = position - (Vector2)transform.position;


        // 따라다니기
        transform.position = Vector2.MoveTowards(transform.position, position, moveSpeed * Time.deltaTime);

        // 파라미터 t 증가
        t += Time.deltaTime;

        // 베지어 곡선을 모두 돌았을 때 t 초기화
        if (t > 1f)
        {
            t = 0f;
             // 새로운 랜덤 점 설정
            startPoint = endPoint;
            controlPoint = GetRandomPointInPatrolArea();
            endPoint = GetRandomPointInPatrolArea();
        }

        // 방향에 따라 이미지 뒤집기
        if(m_isDir)
        {
            transform.localScale = new Vector3((_dir.x<0)?1:-1 , 1,1);
        }
        
    }

    // 베지어 곡선에서 지정된 t에 해당하는 위치 계산
    Vector2 CalculateBezierPoint(float t, Vector2 p0, Vector2 p1, Vector2 p2)
    {
        float u = 1f - t;
        float tt = t * t;
        float uu = u * u;

        Vector2 point = uu * p0 + 2f * u * t * p1 + tt * p2;
        return point;
    }

  // 특정 영역 내에서 랜덤한 위치 계산
    Vector2 GetRandomPointInPatrolArea()
    {
        patrolAreaCenter = StagePlayLogic.instance.m_Player.transform.position;
        float minX = patrolAreaCenter.x - patrolAreaSize.x / 2f;
        float maxX = patrolAreaCenter.x + patrolAreaSize.x / 2f;
        float minY = patrolAreaCenter.y - patrolAreaSize.y / 2f;
        float maxY = patrolAreaCenter.y + patrolAreaSize.y / 2f;

        float randomX = Random.Range(minX, maxX);
        float randomY = Random.Range(minY, maxY);

        return new Vector2(randomX, randomY);
    }


}
