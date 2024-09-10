#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class AttackRangeTest : MonoBehaviour
{
    public Transform target;    // ��ä�ÿ� ���ԵǴ��� �Ǻ��� Ÿ��
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

        // target�� �� ������ �Ÿ��� radius ���� �۴ٸ�
        if (interV.magnitude <= radius)
        {
            // 'Ÿ��-�� ����'�� '�� ���� ����'�� ����
            float dot = Vector3.Dot(interV.normalized, transform.right);
            // �� ���� ��� ���� �����̹Ƿ� ���� ����� cos�� ���� ���ؼ� theta�� ����
            float theta = Mathf.Acos(dot);
            // angleRange�� ���ϱ� ���� degree�� ��ȯ
            float degree = Mathf.Rad2Deg * theta;

            // �þ߰� �Ǻ�
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
    // ����Ƽ �����Ϳ� ��ä���� �׷��� �޼ҵ�
    private void OnDrawGizmos()
    {
        Handles.color = isCollision ? _red : _blue;
        // DrawSolidArc(������, ��ֺ���(��������), �׷��� ���� ����, ����, ������)
        Handles.DrawSolidArc(transform.position, Vector3.back, transform.right, angleRange / 2, radius);
        Handles.DrawSolidArc(transform.position, Vector3.back, transform.right, -angleRange / 2, radius);
    }

    //public float fanAngle = 90f; // ��ä�� ����
    //public float fanRadius = 5f; // ��ä�� ������
    //public int lineSegmentCount = 50; // ���� ��

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