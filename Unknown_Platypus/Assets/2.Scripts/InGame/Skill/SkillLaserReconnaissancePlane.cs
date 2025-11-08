using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;
using static UnityEngine.GraphicsBuffer;
using Unity.VisualScripting;
using UnityEngine.UIElements;

public class SkillLaserReconnaissancePlane : SkillObject
{
    [SerializeField] Transform[] m_trLaser;
    [SerializeField] Transform[] m_trLaserHit;
    [SerializeField] ParticleSystem laserParticle;
    [SerializeField]BoxCollider2D laserCollider;

    ParticleSystem.MainModule particleMain;
    List<SkillCollisionChild> laserColliserList = new();

    //[SerializeField]
    //private Transform m_trPlane;

    private int m_curState = 0;     //0 : 대기, 1 : 공격
    private float m_waitTime = 0;
    private float m_attackTime = 0;
    int randomDirection = 0;
    float angleZ = 0;

    float Speed = 60;

    private readonly float m_attackDealy = 1; //공격 타임? 데미지 들어가는 시간?

    readonly float maxLevelPlaneSize = 7;

    #region  폭탄 
    Vector3 shadowStartPos;

    private int _bombCount = 0;
    private const int MaxBombs = 10;
    private const float _bombInterval = maxSkillMaxTime / MaxBombs; // 0.25초 구간 동안 10개 뿌릴 거니까
    private const float maxSkillMaxTime = 0.75f;
    private float _lastBombTime = 1f;
    #endregion

    public float AttackDelay
    {
        get
        {
            if (SkillData.skillEffectDataList[1] != null && SkillData.skillEffectDataList[1].skillEffectValue != null)
            {
                return SkillData.skillEffectDataList[1].skillEffectValue[0];
            }

            return 1.5f;
        }
    }

    private List<TargetPlayer> m_targetList = new List<TargetPlayer>();

    private void Awake()
    {
        laserColliserList = new();

        for (int i = 0; i < m_trLaser.Length; i++)
        {
            m_trLaser[i].gameObject.SetActive(false);
            m_trLaserHit[i].gameObject.SetActive(false);
            var collision = m_trLaser[i].GetComponent<SkillCollisionChild>();

            if(collision == null)
            {
                Debug.LogError("not exist");
                continue;
            }

            collision.SetParent(this);
            collision.SetColliderActive(true);

            particleMain = laserParticle.main;
            laserColliserList.Add(collision);
        }
    }

    public override void Apply()
    {
        base.Apply();

        transform.SetParent(m_owner.transform);
        transform.rotation = Quaternion.identity;
        transform.localPosition = Vector3.zero;

        if(m_skillData.m_skillTable.skilllv != ConstData.SkillMaxLevel)
        {
            laserCollider.offset = new Vector2(m_distance / 2, 0);
            laserCollider.size = new Vector2(m_distance, laserCollider.size.y);
        }
        else
        {
            randomDirection = Random.Range(0, 4);

            switch (randomDirection)
            {
                case 0:
                    angleZ = 0;
                    MaxLevelEffectObj.transform.position = new Vector3(0, -20);
                    break;
                case 1:
                    angleZ = 90;
                    MaxLevelEffectObj.transform.position = new Vector3(20, 0);
                    break;
                case 2:
                    angleZ = 180;
                    MaxLevelEffectObj.transform.position = new Vector3(0, 20);
                    break;
                case 3:
                    angleZ = 270;
                    MaxLevelEffectObj.transform.position = new Vector3(-20, 0);
                    break;
            }

            shadowStartPos = MaxLevelEffectObj.transform.position;
            
            float rad = (angleZ + 90) * Mathf.Deg2Rad;
            direction = new Vector2(Mathf.Cos(rad), Mathf.Sin(rad));
            _bombCount = 0;
            _lastBombTime = 0f;
            MaxLevelEffectObj.gameObject.transform.rotation = Quaternion.Euler(0, 0, angleZ);

            MaxLevelEffectObj.gameObject.SetActive(true);
        }

        m_attackTime = 0;
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        LowLevel();
        MaxLevel();
    }

    private void LowLevel()
    {
        if (ConstData.SkillMaxLevel == m_skillData.m_skillTable.skilllv)
        {
            return;
        }

        Vector3 dir = Vector3.zero;

        if (Owner.IsMove)
        {
            dir = Owner.inputVec.normalized;
            //transform.rotation = Quaternion.AngleAxis(Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg, Vector3.forward);
            transform.rotation = Quaternion.FromToRotation(Vector2.right, dir);
        }
        else
        {

        }

        for (int i = 0; i < m_targetList.Count; i++)
        {
            m_targetList[i].UpdateLogic(Time.fixedDeltaTime);
            if (m_targetList[i].CheckTime() && m_targetList[i].m_target != null &&
            m_targetList[i].m_target.getData.IsDead() == false)
            {
                BattleControl.instance.ApplySkill(m_skillData, m_owner, m_targetList[i].m_target);
                m_targetList[i].Apply();
            }
        }

        //m_trPlane.rotation = Quaternion.AngleAxis(Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg, Vector3.forward);

        if (m_curState == 0)
        {
            m_waitTime += Time.fixedDeltaTime;
            if (m_waitTime >= AttackDelay)
            {
                m_curState = 1;
                m_waitTime = 0;
            }
            for (int i = 0; i < m_trLaser.Length; i++)
            {
                m_trLaser[i].gameObject.SetActive(false);
                m_trLaserHit[i].gameObject.SetActive(false);
                laserColliserList[i].SetColliderActive(false);
            }
        }
        else if (m_curState == 1)
        {
            if (m_attackTime >= m_duration)
            {
                m_curState = 0;
                m_attackTime = 0;
                //for(int i = 0; i < m_trLaser.Length; i++)
                //{
                //    m_trLaser[i].gameObject.SetActive(false);
                //    m_trLaserHit[i].gameObject.SetActive(false);
                //}

                return;
            }

            particleMain.startSizeXMultiplier = m_distance;
            particleMain.startSizeYMultiplier = 1;
            particleMain.startSizeZMultiplier = 1;

            for (int i = 0; i < m_trLaser.Length; i++)
            {
                m_trLaser[i].gameObject.SetActive(true);
                //m_trLaser[i].localScale = new Vector3(m_distance, 1, 1);

                laserCollider.offset = new Vector2(m_distance / 2, 0);
                laserCollider.size = new Vector2(m_distance, laserCollider.size.y);

                m_trLaserHit[i].gameObject.SetActive(true);
                m_trLaserHit[i].localPosition = new Vector3(0, m_distance, 0);

                laserColliserList[i].SetColliderActive(true);
            }

            for (int i = 0; i < m_targetList.Count; i++)
            {
                if (m_targetList[i].CheckTime() && m_targetList[i].m_target != null &&
                m_targetList[i].m_target.getData.IsDead() == false)
                {
                    BattleControl.instance.ApplySkill(m_skillData, m_owner, m_targetList[i].m_target);
                    m_targetList[i].Apply();
                }
            }

            m_attackTime += Time.fixedDeltaTime;
        }
    }
    Vector2 direction;
    float rad;
    private void MaxLevel()
    {
        if(ConstData.SkillMaxLevel != m_skillData.m_skillTable.skilllv)
        {
            return;
        }

        m_attackTime += Time.deltaTime;

        if(m_attackTime < maxSkillMaxTime)
        {
            MaxLevelEffectObj.transform.position += (Vector3)direction * Speed * Time.deltaTime;

            if (m_attackTime - _lastBombTime >= _bombInterval && _bombCount < MaxBombs)
            {
                DropBomb(_bombCount);
                _bombCount++;
                _lastBombTime = m_attackTime;
            }
        }
        else
        {
            Close();
        }
    }

    private void DropBomb(int index)
    {
        float t = (float)index / (MaxBombs - 1);
        Vector3 start = shadowStartPos; // 그림자 시작 위치 저장해둬야 함
        Vector3 end = MaxLevelEffectObj.transform.position;
        Vector3 spawnPos = Vector3.Lerp(start, end, t);       

        Effect bulletObj = EffectManager.instance.Play("Missile", gameObject.transform.position, Quaternion.identity);
        bulletObj.gameObject.SetActive(false);
        var bullet = bulletObj.GetComponent<SkillBullet>();
        bullet.InitWithOutTarget(m_skillData, spawnPos, new Vector2(spawnPos.x, spawnPos.y + 3), m_owner, Vector3.down, _targetCount: int.MaxValue, false, true, false, 2);
    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        Player _player = collision.GetComponent<Player>();

        if (_player == null)
        {
            return;
        }

        BattleControl.instance.ApplySkill(m_skillData, m_owner, _player);

        m_targetList.Add(new TargetPlayer(_player, m_attackDealy));
    }

    public override void OnTriggerExitChild(Collider2D collision)
    {
        Player _player = collision.GetComponent<Player>();
        TargetPlayer _targetPlayer = m_targetList.Find(item=>item.m_target == _player);

        if(_targetPlayer != null)
            m_targetList.Remove(_targetPlayer);           
    }
}
