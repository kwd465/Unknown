#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class AttackRangeTest : MonoBehaviour
{
    public Transform target;    // 부채꼴에 포함되는지 판별할 타겟
    public float angleRange = 30f;
    public float radius = 3f;

    Color _blue = new Color(0f, 0f, 1f, 0.2f);
    Color _red = new Color(1f, 0f, 0f, 0.2f);
    private LineRenderer lineRenderer;
    bool isCollision = false;

    List<Transform> targets = new List<Transform>();
    void Update()
    {
        SearchTarget();
        Vector3 interV = target.position - transform.position;

        // target과 나 사이의 거리가 radius 보다 작다면
        if (interV.magnitude <= radius)
        {
            // '타겟-나 벡터'와 '내 정면 벡터'를 내적
            float dot = Vector3.Dot(interV.normalized, transform.right);
            // 두 벡터 모두 단위 벡터이므로 내적 결과에 cos의 역을 취해서 theta를 구함
            float theta = Mathf.Acos(dot);
            // angleRange와 비교하기 위해 degree로 변환
            float degree = Mathf.Rad2Deg * theta;

            // 시야각 판별
            if (degree <= angleRange / 2f)
            {
                isCollision = true;
                
            }
            else
                isCollision = false;

        }
        else
            isCollision = false;

        
    }
    private void SearchTarget()
    {
        Vector3 forward = transform.right;
        
        Collider2D[] colliders = Physics2D.OverlapCircleAll(transform.position, radius, LayerMask.GetMask("Monster"));

        foreach(Collider2D i in colliders)
        {
            Vector3 toMonster = i.transform.position - transform.position;

            float angleMonster = Vector3.Angle(forward, toMonster);

            if (angleMonster <= angleRange / 2f && toMonster.magnitude <= radius)
            {
                if (!targets.Contains(i.transform))
                    targets.Add(i.transform);
            }
        }
    }
    // 유니티 에디터에 부채꼴을 그려줄 메소드
    private void OnDrawGizmos()
    {
        Handles.color = isCollision ? _red : _blue;
        // DrawSolidArc(시작점, 노멀벡터(법선벡터), 그려줄 방향 벡터, 각도, 반지름)
        Handles.DrawSolidArc(transform.position, Vector3.back, transform.right, angleRange / 2, radius);
        Handles.DrawSolidArc(transform.position, Vector3.back, transform.right, -angleRange / 2, radius);
    }

    //public float fanAngle = 90f; // 부채꼴 각도
    //public float fanRadius = 5f; // 부채꼴 반지름
    //public int lineSegmentCount = 50; // 선분 수

    //private LineRenderer lineRenderer;

    //void Start()
    //{
    //    lineRenderer = GetComponent<LineRenderer>();
    //    lineRenderer.positionCount = lineSegmentCount + 1;
    //    lineRenderer.useWorldSpace = false;
    //}

    //void Update()
    //{
    //    DrawFanShape();
    //}

    //void DrawFanShape()
    //{
    //    float angleStep = fanAngle / lineSegmentCount;
    //    float angle = -fanAngle / 2f;

    //    for (int i = 0; i <= lineSegmentCount; i++)
    //    {
    //        float x = Mathf.Sin(Mathf.Deg2Rad * angle) * fanRadius;
    //        float y = Mathf.Cos(Mathf.Deg2Rad * angle) * fanRadius;

    //        lineRenderer.SetPosition(i, new Vector3(x, y, 0f));
    //        angle += angleStep;
    //    }
    //}
}
#endif