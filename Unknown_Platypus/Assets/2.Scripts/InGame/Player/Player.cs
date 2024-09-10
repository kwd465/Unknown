using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.AI;
using Yoo;


public class Player : MonoBase
{
    protected PoolObjectGroup<DamageEffect> m_damageList;
    public Image m_imgHp;
    public Image m_imgAttack;
    public Transform m_trAttackAngle;
    public Transform m_trDamage;
    public FollowObject m_followShadow;

    protected PlayerAni m_PlayerAni;
    public PlayerAni Ani => m_PlayerAni;

    protected PlayerFsm m_fsm;
    public PlayerFsm Fsm =>m_fsm;

    protected PlayerData m_Data;

    public PlayerData getData => m_Data;

    [SerializeField]
    private Rigidbody2D m_rig;
    public Rigidbody2D Rig=>m_rig;

    [SerializeField]
    protected NavMeshAgent m_navMeshAgent;

    public NavMeshAgent NavMeshAgent => m_navMeshAgent;


    [SerializeField]
    protected Player_CheckRooting m_Rooting;

    public Vector3 inputVec { get; private set; }

    public Vector3 m_inputVec;


    public bool IsMove => inputVec != Vector3.zero;

    protected EquipTableData m_EquipData;

    //�ڵ� ��ų
    protected List<SkillEffect> m_skillList = new List<SkillEffect>();
    //��Ÿ�� ���� ��ų (���ӽ�ų ���ѽ�ų)
    private List<SkillObject> m_NoCoolSkillList = new List<SkillObject>();

    protected SkillEffect m_baseSkill;

    public e_PlayerType PlayerType;

    protected bool isAttack = false;
    public bool IsAttack => isAttack;

    public List<SkillTableData> GetInGameSkill()
    {
        List<SkillTableData> _temp = new List<SkillTableData>();

        List<SkillEffect> _targets = m_skillList.FindAll(item => item.m_skillTable.skillType == e_SkillType.InGameSkill);

        if(_targets != null && _targets.Count > 0)
        {
            for(int i = 0; i < _targets.Count; i++)
            {
                _temp.Add(_targets[i].m_skillTable);
            }
        }

        List<SkillObject> _nocoolList = m_NoCoolSkillList.FindAll(item => item.SkillData.skillType == e_SkillType.InGameSkill);

        if(_nocoolList != null && _nocoolList.Count >0)
        {
            for(int i = 0; i < _nocoolList.Count; i++)
            {
                _temp.Add(_nocoolList[i].SkillData);
            }
        }

        return _temp;
    }

    public virtual void Init(e_PlayerType _type ,PlayerData _data , PlayerFsmFactory _fsm , Vector3 _pos)
    {
        if (m_damageList != null)
            m_damageList.Clear();

        PlayerType = _type;
        transform.position = _pos;
      

        


        m_skillList.Clear();
        m_damageList = new PoolObjectGroup<DamageEffect>(m_trDamage);
        m_EquipData = TableControl.instance.m_equipTable.GetRecord(10001);

        //��� ��ų ����
        for (int i = 0; i < m_EquipData.equipSkills.Count; i++) 
        {
            SkillTableData _skillData = TableControl.instance.m_skillTable.GetRecord(m_EquipData.equipSkills[i]);
            if (_skillData == null)
                continue;

            if(_skillData.skillSubType == e_SkillSubType.Auto)
            {
                m_baseSkill = new SkillEffect(_skillData, this , true);
                m_baseSkill.m_updateCallBack = (skill) => { 
                    m_imgAttack.fillAmount = skill.CoolTimeNormalized; 
                };
            }
        }
        
        m_Data = _data;
        m_fsm = _fsm.Create(this);
        m_PlayerAni = new PlayerAni_Spine(transform.GetComponentInChildren<SkeletonAnimation>());
        m_fsm.SetState(ePLAYER_STATE.idle);
        m_imgHp.fillAmount = 1f;
        m_imgAttack.fillAmount = 0f;
        m_Rooting?.SetArea(0.5f);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
        m_fsm.Update();
        m_damageList.UpdateLogic();
        ApplySkill();
        
        m_followShadow?.UpdateLogic(transform);
        m_baseSkill?.UpdateSkill();

        for(int i = 0; i < m_skillList.Count; i++)
        {
            m_skillList[i].UpdateSkill();
        }

        if (PlayerType == e_PlayerType.CHAR)
        {
            Rig.velocity = Vector2.zero;
            Rig.angularVelocity = 0;
        }
    }

    public void ApplySkill()
    {
        List<SkillEffect> _selectSkill = m_skillList.FindAll(item => item.m_isReady && item.m_skillTable.skillSubType == e_SkillSubType.Auto );
        if (_selectSkill != null && _selectSkill.Count > 0)
        {
            foreach (var skill in _selectSkill)
            {
                MakeSkillEffect(skill);
            }
        }

        if(m_baseSkill != null && m_baseSkill.m_isReady)
        {
            if (m_fsm.curState == ePLAYER_STATE.idle)
                m_fsm.SetState(ePLAYER_STATE.idle_Attack);
            else if (m_fsm.curState == ePLAYER_STATE.move)
                m_fsm.SetState(ePLAYER_STATE.move_Attack);

            MakeSkillEffect(m_baseSkill , true);
        }
    }

    //��ų�� ȹ�������� ȣ��Ǵ� �Լ�
    public void SetSkill(SkillTableData _skillData )
    {
        //��ų ȹ��
        if(_skillData.skillSubType == e_SkillSubType.Auto )
        {
            if(_skillData.coolTime == 0)
            {
                SkillObject _target = m_NoCoolSkillList.Find(item => item.SkillData.group == _skillData.group);
                if(_target == null)
                    m_NoCoolSkillList.Add(MakeSkillEffect(new SkillEffect(_skillData, this)));
                else 
                    _target.Init(new SkillEffect(_skillData, this), GameUtil.GetTarget(_skillData, this, Ani.Dir, PlayerType == e_PlayerType.CHAR ? true : false), this , m_inputVec);
            }
            else
            {
                SkillEffect _target= m_skillList.Find(item => item.m_skillTable.group == _skillData.group);
                if (_target != null)
                    _target.SetUpdateData(_skillData);
                else
                    m_skillList.Add(new SkillEffect(_skillData, this));
            }
        }
    }

    private SkillObject MakeSkillEffect(SkillEffect _skillData, bool _isParent = false)
    {
        Effect _skill = null;
        if(_isParent)
            _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, m_trAttackAngle);
        else
            _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, transform.position, Quaternion.identity);
        _skillData.UseSkill();
        SkillObject _skillObject = _skill.GetComponent<SkillObject>();
        if(_skillData.m_skillTable.skillType != e_SkillType.InGameSkill)
            _skillObject.Init(_skillData, GameUtil.GetTarget(_skillData.m_skillTable, this, Ani.Dir, PlayerType == e_PlayerType.CHAR ? true : false), this,m_inputVec);
        else
            _skillObject.Init(_skillData, _target:null, this,m_inputVec);
        return _skillObject;
    }



    #region ���� ĳ���͸� ����
    public void Move(Vector2 _input)
    {
        inputVec = _input;
        m_inputVec = _input;
        float angle = Mathf.Atan2(inputVec.y, inputVec.x) * Mathf.Rad2Deg;
        m_trAttackAngle.rotation = Quaternion.Euler(0, 0, angle - 90);


        if (m_fsm.curState != ePLAYER_STATE.move &&
            m_fsm.curState != ePLAYER_STATE.move_Attack) 
            m_fsm.SetState(ePLAYER_STATE.move);
    }

    public void Stop()
    {
        inputVec = Vector3.zero;
        if (m_fsm.curState != ePLAYER_STATE.idle)
            m_fsm.SetState(ePLAYER_STATE.idle);
    }
    #endregion


    public void SetDamage(double _damage , bool _isCri = false)
    {
        m_Data.SetDamage(_damage);
        if(m_imgHp != null)
            m_imgHp.fillAmount = (float)(m_Data.HP / m_Data.MaxHP);
        if(PlayerType == e_PlayerType.CHAR)
            m_damageList.Get("Prefabs/DamageEffect").Open(_damage , true , _isCri);
        else
            m_damageList.Get("Prefabs/DamageEffect").Open(_damage,  false , _isCri);

        if(PlayerType == e_PlayerType.CHAR)
        {
            StagePlayLogic.instance.BattleUI.OnChangeHp((float)(m_Data.HP / m_Data.MaxHP));
        }

#if NO_DIE 
        if (PlayerType != e_PlayerType.CHAR && m_Data.IsDead())
            m_fsm.SetState(ePLAYER_STATE.death);
#else
        if(m_Data.IsDead())
            m_fsm.SetState(ePLAYER_STATE.death);
#endif
    }

    public virtual void Death()
    {
        
    }


}
