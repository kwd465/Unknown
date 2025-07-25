using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using static UnityEngine.GraphicsBuffer;

public class TargetPlayer
{
    public Player m_target;
    public float m_checkTime;
    public float m_time;

    public TargetPlayer(Player _target , float _time)
    {
        m_target = _target;
        m_checkTime = 0;
        m_time =  _time;
    }

    public void UpdateLogic(float _deltaTime)
    {
        m_checkTime += _deltaTime;
     

    }

    public bool CheckTime()
    {
        return m_checkTime >= m_time;
    }

    public void Apply()
    {
        m_checkTime = 0;
    }

}



public class SkillObject : MonoBehaviour
{
    [Header("스킬 범위 표시 이미지 -Jun 25-01-30")]
    public SpriteRenderer SkillRangeImage;
    [Header("�ݸ��� üũ �������")]
    public bool isColliderCheck = false;
    [Header("Camera Shake")]
    public bool isShake = false;
    [Header("Effect Script")]
    public Effect m_effect;
    [Header("Ÿ�� ����Ʈ")]
    public string HitEffect;
    public string ImpactEffect;
    public bool isSetParentHit = false;

    protected SkillEffect m_skillData;
    protected Player m_owner;

    public Player Owner => m_owner;

    protected float m_curTime;
    protected float m_DamTick;

    protected int m_curCount;
    protected int m_skillCount;
    protected bool m_isSkillDie;

    [Header("스킬 공격 이펙트 오브젝트")]
    public GameObject LowLevelEffectObj;
    public GameObject MaxLevelEffectObj;
    private GameObject NowSelectEffectObj;

    protected List<Player> m_taretList = new List<Player>();

    public SkillEffect SkillEffect { get { return m_skillData; } }
    public SkillTableData SkillData { get { return m_skillData.m_skillTable; } }

    protected Vector3 m_dir;

    public int m_count { get; set; }
    public int HitCount { get; set; }
    public float m_distance { get; set; }
    public float m_duration { get; set; }
    public float m_area { get; set; }

    public System.Action SkillEndAction = null;

    protected Effect impactEffect = null;

    public virtual void RefreshSkill(SkillEffect _data)
    {
        m_skillData = _data;
        m_skillCount = SkillControl.instance.GetSkillHitCount(m_owner, m_skillData.m_skillTable);
    }


    public virtual void Init(SkillEffect _data, Player _target, Player _owner, Vector3 _dir)
    {
        m_dir = _dir;
        m_taretList.Clear();
        if (isColliderCheck == false)
            m_taretList.Add(_target);
        m_isSkillDie = false;
        m_skillData = _data;
        m_owner = _owner;
        m_curCount = 0;
        m_curTime = 0;
        m_DamTick = 0;
        m_skillCount = SkillControl.instance.GetSkillHitCount(_owner, m_skillData.m_skillTable);
        if (m_effect != null)
            m_DamTick = m_effect.ActiveTime / m_skillCount;

        MaxLevelEffectObj.gameObject.SetActive(false);
        LowLevelEffectObj.gameObject.SetActive(false);

        NowSelectEffectObj = _data.m_skillTable.skilllv >= 5 ? MaxLevelEffectObj : LowLevelEffectObj;
        NowSelectEffectObj.gameObject.SetActive(true);
        Apply();
        if (_target == null)
        {
            Apply();
            return;
        }
        //for (int i = 0; i < m_taretList.Count; i++)
        //    Apply(m_taretList[i]);

        SkillEndAction = null;

#if UNITY_EDITOR
        if (SkillRangeImage != null)
            SetRangeImage();
#else
        SetRangeImage();
#endif
    }

    public virtual void Init(SkillEffect _data, List<Player> _targets, Player _owner, Vector3 _dir)
    {
        m_dir = _dir;
        m_taretList.Clear();
        if(isColliderCheck == false)
            m_taretList = _targets;
        m_isSkillDie = false;
        m_skillData = _data;
        m_owner = _owner;
        m_curCount = 0;
        m_curTime = 0;
        m_DamTick = 0;
        m_skillCount = SkillControl.instance.GetSkillHitCount(_owner, m_skillData.m_skillTable);
        if (m_effect != null)
            m_DamTick = m_effect.ActiveTime / m_skillCount;

        
        if(_targets == null || _targets.Count == 0)
        {
            Apply();
            return;
        }

        for (int i = 0; i < m_taretList.Count; i++)
            Apply(m_taretList[i]);

        SkillEndAction = null;

#if UNITY_EDITOR
        if (SkillRangeImage != null)
            SetRangeImage();
#else
        SetRangeImage();
#endif
    }

    public virtual void Apply(Player _target)
    {
        if (_target == null)
            return;

        if (_target.getData.HP <= 0)
            return;

        m_curCount++;

        //if (m_owner.PlayerType == e_PlayerType.CHAR && isShake)
        //    StagePlayLogic.instance.m_CamControl.OnShake();
        Vector3 _pos = _target.transform.position;
        _pos.y += Random.Range(0.2f, 0.5f);
        _pos.x += Random.Range(-0.2f, 0.2f);

        if (HitEffect != null && HitEffect != "")
        {
            Effect _effect = EffectManager.instance.Play(HitEffect, _pos, Quaternion.identity);
            if (isSetParentHit)
                _effect.transform.SetParent(_target.transform);
        }

        BattleControl.instance.ApplySkill(m_skillData, m_owner, _target);
    }

    public virtual void Apply()
    {
        m_count = (int)SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.count);
        HitCount = (int)SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.skillHitCount);
        m_distance = SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.distance);
        m_duration = SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.duration);
        m_area = SkillEffect.GetBaseAddValue(SKILLOPTION_TYPE.area);
    }

    public virtual void Close()
    {
        gameObject.SetActive(false);
        SkillEndAction?.Invoke();
#if UNITY_EDITOR
        if (NowSelectEffectObj == null)
        {
            Debug.LogWarning($@"{gameObject.name} skill effect 확인 필요 -Jun 24-10-12");
        }
#endif

        NowSelectEffectObj?.gameObject.SetActive(false);
    }

    public virtual void UpdateLogic()
    {
        if (m_skillData != null && m_skillCount > 1 && m_DamTick > 0)
        {
            if (m_curCount == m_skillCount)
            {
                m_effect.Close();
                return;
            }

            if (m_curTime >= m_DamTick)
            {
                for(int i = 0; i < m_taretList.Count; i++)
                {
                    Apply(m_taretList[i]);
                }
                m_curTime = 0;
            }

            m_curTime += Time.deltaTime;
        }
    }

    public void SetRangeImage()
    {
        if(m_skillData == null)
        {
            Debug.LogError($@"{gameObject.name} skill data check");
            return;
        }

        if(SkillRangeImage == null)
        {
            Debug.LogWarning($@"{gameObject.name} 스킬 범위 표시 안하는 스킬인지 확인 필요");
            return;
        }

        Debug.Log($@"{m_skillData.m_skillTable.skillArea} skill rnage");
        SkillRangeImage.transform.localScale = new Vector3(m_skillData.m_skillTable.skillArea, m_skillData.m_skillTable.skillArea, 1);
    }

    public virtual void OnTriggerEnterChild(Collider2D collision)
    {
    }

    public virtual void OnTriggerExitChild(Collider2D collision)
    {
    }


    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (isColliderCheck == false)
            return;

        if (m_owner.tag.Equals(collision.tag))
            return;

        if(collision.tag.Equals(Define.TAG_PLAYER) || 
            collision.tag.Equals(Define.TAG_MONSTER))
        {
            Player _player = collision.GetComponent<Player>();
            if (_player == null)
                return;

            if (m_taretList.Contains(_player))
                return;
            
            m_taretList.Add(_player);
            Apply(_player);
        }


    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (isColliderCheck == false)
            return;
        if (m_owner.tag.Equals(collision.tag))
            return;

        if (collision.tag.Equals(Define.TAG_PLAYER) ||
           collision.tag.Equals(Define.TAG_MONSTER))
        {
            Player _player = collision.GetComponent<Player>();
            if (_player == null)
                return;

            m_taretList.Remove(_player);
        }


    }

    protected void SetRotation(){
        // 이동 방향의 각도를 구합니다.
        float angle = Mathf.Atan2(m_dir.y, m_dir.x) * Mathf.Rad2Deg;
        // 오브젝트의 회전 각도를 설정합니다.
        transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
    }

    protected void HitEffectPlay(Vector3 _pos)
    {
        if(string.IsNullOrEmpty(HitEffect))
            return;

        Effect _effect = EffectManager.instance.Play(HitEffect, _pos, Quaternion.identity, 1, false);
        if (isSetParentHit)
            _effect.transform.SetParent(m_owner.transform);
    }

    protected void ImpactEffectPlay(Vector3 _pos)
    {
        if (string.IsNullOrEmpty(ImpactEffect))
            return;

        Effect _effect = EffectManager.instance.Play(ImpactEffect, _pos, Quaternion.identity);

        if(_effect == null)
        {
            impactEffect = null;

            return;
        }

        impactEffect = _effect;

        if (isSetParentHit)
            _effect.transform.SetParent(m_owner.transform);        
    }
}
