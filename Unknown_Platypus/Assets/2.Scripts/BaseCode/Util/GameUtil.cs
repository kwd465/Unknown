using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;
using System.Linq;
using static UnityEngine.RuleTile.TilingRuleOutput;


public static class GameUtil
{

    public static bool IsMovePos(Vector2 _checkSize, Vector3 _position, float _height, float _width)
    {
        float lx = _checkSize.x * 0.5f - _width;
        float ly = _checkSize.y * 0.5f - _height;

        if (_position.x < 0 - lx || _position.x > 0 + lx)
            return false;

        if (_position.y > 0 + ly || _position.y < 0 - ly)
            return false;

        return true;
    }

    /// <summary>
    /// �̵���ġ�� CheckSize X���� ���� ���� �ʵ��� ���ִ� �Լ�
    /// </summary>
    /// <param name="_checkSize">��������</param>
    /// <param name="_position">������ �ϴ� ��ġ</param>
    /// <param name="_height">�̵��ϴ� ����� ����</param>
    /// <param name="_width">�̵��ϴ� ����� �ʺ�</param>
    /// <returns></returns>
    public static Vector3 MovePosX(Vector2 _checkSize, Vector3 _position, float _height, float _width)
    {
        float lx = _checkSize.x * 0.5f - _width;
        float clampX = Mathf.Clamp(_position.x, 0 - lx, 0 + lx);

        return new Vector3(clampX, _position.y, _position.z);
    }

    
    /// <summary>
    /// ����� �ٶ󺸴� ����
    /// </summary>
    /// <param name="_owner">���ذ�</param>
    /// <param name="_target">���</param>
    /// <param name="_ratioAngle">������ (���ش���� �⺻ ������ ���� �������� �־���ߵ�)</param>
    /// <returns></returns>
    public static Quaternion Rotation(Vector3 _owner , Vector3 _target , float _ratioAngle = 0) 
    {
        Vector2 direction = _target - _owner;
        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        Quaternion angleAxis = Quaternion.AngleAxis(angle - _ratioAngle, Vector3.forward);
        return angleAxis;
    }

    public static Quaternion Rotation(Vector3 _dir, float _ratioAngle = 0)
    {
        float angle = Mathf.Atan2(_dir.y, _dir.x) * Mathf.Rad2Deg;
        Quaternion angleAxis = Quaternion.AngleAxis(angle - _ratioAngle, Vector3.forward);
        return angleAxis;
    }


  

    /// <summary>
    /// ������ ���� �����Ҽ� �ִ� ����� �ִ��� üũ
    /// </summary>
    /// <param name="_cam">���� ī�޶�</param>
    /// <param name="_pos">������ ��ġ</param>
    /// <param name="_offsetX"></param>
    /// <param name="_offsetY"></param>
    /// <returns></returns>
    public static bool IsTargetVisible(Camera _cam , Vector3 _pos , float _offsetX = 0 , float _offsetY = 0)
    {
        var planes = GeometryUtility.CalculateFrustumPlanes(_cam);
        var checkPos = _pos;
        checkPos.x += _offsetX;
        checkPos.y += _offsetY;
        
        foreach (var plane in planes)
        {
            if (plane.GetDistanceToPoint(checkPos) < 0)
                return false;
        }

        checkPos = _pos;
        checkPos.x -= _offsetX;
        checkPos.y -= _offsetY;

        foreach (var plane in planes)
        {
            if (plane.GetDistanceToPoint(checkPos) < 0)
                return false;
        }

        return true;
    }


    

    /// <summary>
    /// Ư�� ���� �ȿ� Ÿ���� �ִ��� üũ
    /// </summary>
    /// <param name="_owner"></param>
    /// <param name="checkDir"></param>
    /// <param name="_area"></param>
    /// <param name="_dis"></param>
    /// <returns></returns>
    public static Player GetAreaTarget(Player _owner, float _area, float _dis, bool checkDir = true , bool _isRandom = false)
    {
        List<Player> _targets = new List<Player>();
        List<Player> _result = new List<Player>();

        if (_owner.PlayerType == e_PlayerType.CHAR)
            _targets = StagePlayLogic.instance.m_SpawnLogic.m_monList;
        else
            _targets.Add(StagePlayLogic.instance.m_Player);

    
        for(int i = 0; i < _targets.Count; i++)
        {
            //��Ÿ� üũ
            float _distance = Vector2.Distance(_targets[i].transform.position , _owner.transform.position);
            if (_dis < _distance)
                continue;

            //�ٶ󺸴� ���⿡ ����
            if (checkDir)
            {
                if (_owner.Ani.Dir == Vector3.left &&
                    _owner.transform.position.x < _targets[i].transform.position.x)
                    continue;
                else if (_owner.Ani.Dir == Vector3.right &&
                    _owner.transform.position.x > _targets[i].transform.position.x)
                    continue;
            }

            
            _result.Add(_targets[i]);
            
        }

        if (_result.Count == 0)
            return null;
        if(_isRandom == false)
            return _result[0];
        else
            return _result[Random.Range(0, _result.Count)];
    }

    /// <summary>
    /// ĳ���� ��ó�� �ٸ� ���� �������� �����˻�
    /// </summary>
    /// <param name="_owner"></param>
    /// <param name="checkDir"></param>
    /// <param name="_area"></param>
    /// <returns></returns>
    public static List<Player> GetTarget(SkillTableData _skillTable, Player _owner , Vector3 _dir, bool _isUser = false)
    {
        List<Player> _targetList = new List<Player>();

        switch(_skillTable.skillAreaType)
        {
            case e_SkillAreaType.SemiCircle:
                _targetList = GetSemiCircleTarget(_owner, _dir, _skillTable.skillTargetCount, _skillTable.skillDistance, _isUser);
                break;

            case e_SkillAreaType.Circle:
            case e_SkillAreaType.Drop:
                _targetList = GetCircleTarget(_owner, _dir, _skillTable.skillTargetCount, _skillTable.skillDistance, _isUser);
                break;

            case e_SkillAreaType.Box:
                _targetList = GetBoxTarget(_owner, _dir, _skillTable.skillTargetCount, _skillTable.skillDistance, _skillTable.skillArea, _isUser);
                break;

            case e_SkillAreaType.Projectile:
                //Ÿ���� �ʿ� ����
                break;

            case e_SkillAreaType.Sector:
                _targetList = GetSectorTarget(_owner, _dir, _skillTable.skillTargetCount, _skillTable.skillDistance, _skillTable.skillArea, _isUser);
                break;
        }

        return _targetList;
    }

    public static List<Player> GetBoxTarget(Player _owner, Vector2 _dir, int _targetCount, float _distance,float _area, bool _isUser = false)
    {
        int targetMask = _isUser ? LayerMask.NameToLayer("Player") : LayerMask.NameToLayer("Monster");
        Vector2 center = _owner.transform.position;
        Vector2 rightVector = new Vector2(-_dir.y, _dir.x).normalized;
        // �簢�� ���� ��� ������Ʈ�� �����ɴϴ�.
        // �簢���� �������� ����մϴ�.
        Vector2 topLeft = center - (rightVector * _distance / 2f) + (_dir * _area / 2f);
        Vector2 topRight = center + (rightVector * _distance / 2f) + (_dir * _area / 2f);
        Vector2 bottomLeft = center - (rightVector * _distance / 2f) - (_dir * _area / 2f);
        Vector2 bottomRight = center + (rightVector * _distance / 2f) - (_dir * _area / 2f);

#if DEBUG_LOG
        Debug.DrawLine(topLeft, topRight, Color.yellow);
        Debug.DrawLine(topRight, bottomRight, Color.yellow);
        Debug.DrawLine(bottomRight, bottomLeft, Color.yellow);
        Debug.DrawLine(bottomLeft, topLeft, Color.yellow);
#endif

        Collider2D[] colliders = Physics2D.OverlapAreaAll(topLeft, bottomRight, targetMask);
        List<Player> _targetList = new List<Player>();
        // ã�� ������Ʈ�� ����Ʈ�� �߰��մϴ�.
        foreach (Collider2D collider in colliders)
        {
            _targetList.Add(collider.GetComponent<Player>());
        }

        return _targetList;
    }


    public static List<Player> GetCircleTarget(Player _owner, Vector3 _dir, int _targetCount, float _distance, bool _isUser = false)
    {
        int targetMask = _isUser ? LayerMask.NameToLayer("Player") : LayerMask.NameToLayer("Monster");
        Collider2D[] targetsInViewRadius = Physics2D.OverlapCircleAll(_owner.transform.position, _distance , targetMask);
        List<Player> _targetList = new List<Player>();
        foreach (Collider2D targetCollider in targetsInViewRadius)
        {
            _targetList.Add(targetCollider.GetComponent<Player>());

            if (_targetList.Count >= _targetCount)
            {
                break;
            }
        }
        return _targetList;
    }

    public static List<Player> GetCircleTarget(Vector3 _owner, int _targetCount, float _distance, bool _isUser = false)
    {
        int targetMask = _isUser ? LayerMask.NameToLayer("Player") : LayerMask.NameToLayer("Monster");
        Collider2D[] targetsInViewRadius = Physics2D.OverlapCircleAll(_owner, _distance, targetMask);
        List<Player> _targetList = new List<Player>();
        foreach (Collider2D targetCollider in targetsInViewRadius)
        {
            _targetList.Add(targetCollider.GetComponent<Player>());

            if (_targetList.Count >= _targetCount)
            {
                break;
            }
        }
        return _targetList;
    }




    public static List<Player> GetSemiCircleTarget(Player _owner, Vector2 _dir, int _targetCount,float _distance, bool _isUser = false)
    {
        List<Player> _targetList = new List<Player>();
        float visionAngle = 180f;
        Vector2 centor = _owner.transform.position;
        // �þ� ������ �������� ��ȯ�մϴ�.
        float halfAngle = visionAngle / 2f;
#if DEBUG_LOG
        float radians = halfAngle * Mathf.Deg2Rad;

        // �ٶ󺸴� ���⿡�� ���ʰ� ������ �� ���͸� ����մϴ�.
        Vector2 leftVector = Quaternion.AngleAxis(-halfAngle, Vector3.forward) * _dir;
        Vector2 rightVector = Quaternion.AngleAxis(halfAngle, Vector3.forward) * _dir;

        // ��ȣ�� �������� ������ ����մϴ�.
        Vector2 startVector = centor + _dir * _distance;
        Vector2 endVector = centor + leftVector * _distance;

        // �ݿ� ������ �ش��ϴ� ��ȣ�� �׸��ϴ� (����� �뵵).
        Debug.DrawLine(centor, startVector, Color.yellow);
        Debug.DrawLine(centor, endVector, Color.yellow);
        Debug.DrawRay(centor, rightVector * _distance, Color.yellow);
        Debug.DrawRay(centor, leftVector * _distance, Color.yellow);
#endif
        // ��ȣ ���� �ִ� ������Ʈ�� ã���ϴ�.
        Collider2D[] colliders = Physics2D.OverlapCircleAll(centor, _distance);

        // ã�� ������Ʈ�� ����Ʈ�� �߰��մϴ�.
        foreach (Collider2D collider in colliders)
        {
            if (collider.tag != "Player" &&
              collider.tag != "Monster")
                continue;

            if (collider.tag == "Player" && _isUser == true)
            {
                continue;
            }

            if (collider.tag == "Monster" && _isUser == false)
            {
                continue;
            }


            Vector2 objPosition = collider.gameObject.transform.position;
            Vector2 dirToObj = objPosition - centor;
            float angleToObj = Vector2.SignedAngle(_dir, dirToObj);

            // ������Ʈ�� �þ� ���� ���� �ִ��� Ȯ���մϴ�.
            if (angleToObj <= halfAngle && angleToObj >= -halfAngle)
            {
                _targetList.Add(collider.GetComponent<Player>());

                if (_targetList.Count >= _targetCount)
                {
                    break;
                }
            }
        }

        return _targetList;
    }


    public static List<Player> GetSectorTarget(Player _owner, Vector3 _dir, int _targetCount, float _distance, float _angle, bool _isUser = false)
    {
        int targetMask = _isUser ? LayerMask.NameToLayer("Player") : LayerMask.NameToLayer("Monster");
        Collider2D[] targetsInViewRadius = Physics2D.OverlapCircleAll(_owner.transform.position, _distance, targetMask);
        List<Player> _targetList = new List<Player>();
        foreach (Collider2D targetCollider in targetsInViewRadius)
        {
            // �þ� �ݰ� ���� ��� ��� ���� �þ� ���� ���� �ִ��� Ȯ���մϴ�.
            Vector3 directionToTarget = (targetCollider.transform.position - _owner.transform.position).normalized;
            if (Vector3.Angle(_dir, directionToTarget) < _angle / 2f)
            {
                // �þ� ���� ���� ������ ����ĳ��Ʈ�� �̿��Ͽ� ���ü��� Ȯ���մϴ�.
                RaycastHit hit;
                if (Physics.Raycast(_owner.transform.position, directionToTarget, out hit, _distance, targetMask))
                {
                    // �̰��� ����� �߰����� ���� ������ �߰��� �� �ֽ��ϴ�.
                    // ���� ���, �߰ߵ� ����� ����Ʈ�� �߰��ϰų� Ư�� ������ ������ �� �ֽ��ϴ�.
                    _targetList.Add(targetCollider.GetComponent<Player>());

                    if (_targetList.Count >= _targetCount)
                    {
                        break;
                    }
                }
            }
        }

        return _targetList;
    }

    /// <summary>
    /// List �ȿ� ���� ����� ���� üũ
    /// </summary>
    /// <param name="_List"></param>
    /// <param name="_owner"></param>
    /// <returns></returns>
    public static Player GetNearestTarget(List<Player> _List , Player _owner)
    {
        if (_List.Count > 0)
        {
            float _distance = 9999f;
            Player _target = null;

            foreach (var _p in _List)
            {
                float _dis = Vector2.Distance(_owner.transform.position, _p.transform.position);
                if (_dis < _distance)
                {
                    _target = _p;
                    _distance = _dis;
                }
            }

            if (_target != null)
            {
                return _target;
            }
        }

        return null;
    }

    public static Player GetNearestTarget(List<Player> _List, Vector3 _startPos , float _distance)
    {
        if (_List.Count > 0)
        {
            
            Player _target = null;

            foreach (var _p in _List)
            {
                float _dis = Vector2.Distance(_startPos, _p.transform.position);
                if (_dis < _distance)
                {
                    _target = _p;
                    _distance = _dis;
                }
            }

            if (_target != null)
            {
                return _target;
            }
        }

        return null;
    }


   

}
