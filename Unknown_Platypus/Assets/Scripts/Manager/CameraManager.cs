using BH;
using DG.Tweening;
using UnityEngine;

public class CameraManager : BHSingleton<CameraManager>
{
    public bool isInfinity = true;
    [SerializeField]
    private Transform target;
    private float halfCameraHeight, halfCameraWidth;
    private SpriteRenderer mapSpriteRenderer;

    public Bounds mapSize;

    private void Start()
    {
        //���� ���Ѹ� �Ⱦ��� �׳� ���� �� ����� ������

        mapSpriteRenderer = GameObject.FindGameObjectWithTag("Map").GetComponent<SpriteRenderer>();
        mapSize = mapSpriteRenderer.bounds;
        halfCameraHeight = Camera.main.orthographicSize;
        halfCameraWidth = halfCameraHeight * Camera.main.aspect;
    }

    private void LateUpdate()
    {
        CameraMove();
    }

    private void CameraMove()
    {
        if(isInfinity)
        {
            transform.position = new Vector3(target.position.x, target.position.y, -10);
            return;
        }

        if(halfCameraHeight != Camera.main.orthographicSize)
        {
            halfCameraHeight = Camera.main.orthographicSize;
            halfCameraWidth = halfCameraHeight * Camera.main.aspect;
        }
        float clampedX = Mathf.Clamp(target.position.x, mapSize.min.x + halfCameraWidth, mapSize.max.x - halfCameraWidth);
        float clampedY = Mathf.Clamp(target.position.y, mapSize.min.y + halfCameraHeight, mapSize.max.y - halfCameraHeight);
        transform.position = new Vector3(clampedX, clampedY,-10);
    }

    public bool isOverMap(Vector3 pos)
    {
        if (pos.x < mapSize.min.x || pos.x > mapSize.max.x || pos.y < mapSize.min.y || pos.y > mapSize.max.y)
            return true;
        return false;
    }

    public bool IsOverCamera(Vector3 pos)
    {
        if (pos.x < transform.position.x - halfCameraWidth || pos.x > transform.position.x + halfCameraWidth || pos.y < transform.position.y - halfCameraHeight || pos.y > transform.position.y + halfCameraHeight)
            return true;
        return false;
    }


}
