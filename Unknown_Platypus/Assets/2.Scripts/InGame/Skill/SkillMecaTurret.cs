using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;
using Spine.Unity;
using UnityEditor;
using UnityEngine;

public class SkillMecaTurret : SkillObject
{

    [SerializeField]
    private Transform m_trBullet;

    [SerializeField]
    private SpineAnimation m_spineTop;
    [SerializeField]
    private SpineAnimation m_spineBottom;

    private int m_state = 0;
    private float m_checkTime = 0f;
    private float m_attackDealy = 0;
    [SerializeField]
    private TargetObjectRandomMove m_randomMove;

    public override void Apply()
    {
        base.Apply();
        m_state = 0;
        m_checkTime = 0;
        m_attackDealy = 0;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;
        m_attackDealy += Time.fixedDeltaTime;
        m_randomMove.UpdateLogic();

        if (m_attackDealy >= 0.5f)
        {
            Player _target = GameUtil.GetAreaTarget(m_owner, m_area, m_distance, false, true);
            if (_target == null)
                return;

            Vector3 _dir = (_target.transform.position - transform.position);

            Effect _bullet = EffectManager.instance.Play("MecaBullet", gameObject.transform.position, Quaternion.FromToRotation(Vector3.right,_dir));
            var bullet = _bullet.GetComponent<SkillBullet>();
            bullet.Init(m_skillData, _target, m_owner, _dir);
            _bullet.gameObject.transform.rotation = Quaternion.FromToRotation(Vector3.right, _dir);
            Debug.Log(@$"hit meca turret {m_attackDealy}");
            //if (moveCoroutine is not null)
            //{
            //    StopCoroutine(moveCoroutine);
            //}

            //moveCoroutine = StartCoroutine(CoMoveToTarget(_bullet, _target, _dir));

            m_attackDealy = 0;
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