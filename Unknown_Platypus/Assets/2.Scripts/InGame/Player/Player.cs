using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.AI;
using Yoo;
using System;
using BH;
using Cysharp.Threading.Tasks;
using System.Threading;


public partial class Player : MonoBase
{
    protected StatusEffectController statusEffectCtrl = null;

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

    public Action<STATUS_EFFECT, float> StatusEffectActiveAction = null;
    public Action<STATUS_EFFECT, float> StatusEffectEndAction = null;

    [SerializeField]
    protected Player_CheckRooting m_Rooting;

    public Vector3 inputVec { get; private set; }

    public Vector3 m_inputVec;


    public bool IsMove => inputVec != Vector3.zero;

    protected EquipTableData m_EquipData;

    //�ڵ� ��ų
    protected List<SkillEffect> m_skillList = new List<SkillEffect>();
    protected Dictionary<int, SkillObject> skillObjDict = new();
    //��Ÿ�� ���� ��ų (���ӽ�ų ���ѽ�ų)
    //private List<SkillObject> m_NoCoolSkillList = new List<SkillObject>();

    protected SkillEffect m_baseSkill;

    public e_PlayerType PlayerType;

    protected bool isAttack = false;
    public bool IsAttack => isAttack;

    /// <summary>
    /// key == skill group index , value == skill option Index -Jun 24-11-01
    /// </summary>
    private Dictionary<int, List<int>> SelectSkillOptionDict = new();



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

        //List<SkillObject> _nocoolList = m_NoCoolSkillList.FindAll(item => item.SkillData.skillType == e_SkillType.InGameSkill);

        //if(_nocoolList != null && _nocoolList.Count >0)
        //{
        //    for(int i = 0; i < _nocoolList.Count; i++)
        //    {
        //        _temp.Add(_nocoolList[i].SkillData);
        //    }
        //}

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

        SelectSkillOptionDict.Clear();
        skillObjDict = new();

        statusEffectCtrl = new(this);

        StatusEffectActiveAction = null;
        StatusEffectEndAction = null;
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
    public void SetSkill(SkillTableData _skillData)
    {
        //��ų ȹ��
        if (_skillData.skillSubType == e_SkillSubType.Auto)
        {
            //if (_skillData.coolTime == 0)
            //{
            //    SkillObject _target = m_NoCoolSkillList.Find(item => item.SkillData.group == _skillData.group);
            //    if (_target == null)
            //        m_NoCoolSkillList.Add(MakeSkillEffect(new SkillEffect(_skillData, this)));
            //    else
            //        _target.Init(new SkillEffect(_skillData, this), GameUtil.GetTarget(_skillData, this, Ani.Dir, PlayerType == e_PlayerType.CHAR ? true : false), this, m_inputVec);
            //}
            //else
            //{
            //    SkillEffect _target = m_skillList.Find(item => item.m_skillTable.group == _skillData.group);
            //    if (_target != null)
            //        _target.SetUpdateData(_skillData);
            //    else
            //        m_skillList.Add(new SkillEffect(_skillData, this));
            //}

            SkillEffect _target = m_skillList.Find(item => item.m_skillTable.group == _skillData.group);
            if (_target != null)
                _target.SetUpdateData(_skillData);
            else
                m_skillList.Add(new SkillEffect(_skillData, this));
        }
    }

    public bool IsSkillGeted(int _groupIndex)
    {
        //존재
        if (m_skillList.Find(x => x.m_skillTable.group == _groupIndex) is not null)
        {
            return true;
        }

        // 비존재 -Jun  24-10-27
        return false;
    }

    public bool IsExistSkillOption(int _groupIndex, int _skillOptionIndex)
    {
        if (SelectSkillOptionDict.TryGetValue(_groupIndex, out var list) is false)
        {
            return false;
        }

        for (int i = 0; i < list.Count; i++)
        {
            if (list[i] == _skillOptionIndex)
            {
                return true;
            }
        }

        return false;
    }

    public void AddSkillOption(int _groupIndex , int _skillOptionIndex)
    {
        if (SelectSkillOptionDict.TryGetValue(_groupIndex, out var list) is false)
        {
            SelectSkillOptionDict.Add(_groupIndex, new());            
        }

        SelectSkillOptionDict[_groupIndex].Add(_skillOptionIndex);
    }

    public List<int> GetSkillOptionList(int _groupIndex)
    {
        if(SelectSkillOptionDict.TryGetValue(_groupIndex , out var list) is false)
        {
            SelectSkillOptionDict.Add(_groupIndex, new());
            return null;
        }

        return list;
    }

    private void MakeSkillEffect(SkillEffect _skillData, bool _isParent = false)
    {
        Effect _skill = null;
        SkillObject _skillObject = null;

        bool isExist = false;

        //if(skillObjDict.TryGetValue(_skillData.m_skillTable.group , out var obj) is false)
        //{
        //    if (_isParent)
        //        _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, m_trAttackAngle);
        //    else
        //        _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, transform.position, Quaternion.identity);
        //    _skillData.UseSkill();
        //    _skillObject = _skill.GetComponent<SkillObject>();
        //    skillObjDict.Add(_skillData.m_skillTable.group, _skillObject);
        //    Debug.Log("create");
        //}
        //else
        //{
        //    Debug.Log("use");
        //    _skillData.UseSkill();
        //    _skillObject = obj;
        //    _skillObject.Close();

        //    _skill = _skillObject.GetComponent<Effect>();

        //    if (_isParent)
        //        _skill.Play(m_trAttackAngle, 1);
        //    else
        //        _skill.Play(transform.position, Quaternion.identity, 1);
        //    _skillObject.RefreshSkill(_skillData);
        //}
        //switch (_skillData.m_skillTable.Skill_Active_Type)
        //{
        //    case SKILL_ACTIVE_TYPE.CONTINIUS:

        //        break;
        //    case SKILL_ACTIVE_TYPE.TIMED:

        //        break;
        //}

        //if (_skillData.m_skillTable.skillType != e_SkillType.InGameSkill)
        //    _skillObject.Init(_skillData, GameUtil.GetTarget(_skillData.m_skillTable, this, Ani.Dir, PlayerType == e_PlayerType.CHAR ? true : false), this, m_inputVec);
        //else
        //    _skillObject.Init(_skillData, _target: null, this, m_inputVec);
        //_skillObject.SkillEndAction = _skillData.EndSkill;

        //return;

        if (skillObjDict.TryGetValue(_skillData.m_skillTable.skillName, out var skillObj) is false)
        {
            skillObj = null;
            skillObjDict.Add(_skillData.m_skillTable.skillName, null);
        }

        if(skillObj is null || _skillData.m_skillTable.Skill_Active_Type == SKILL_ACTIVE_TYPE.TIMED)
        {
            if (_isParent)
                _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, m_trAttackAngle);
            else
                _skill = EffectManager.instance.Play(_skillData.m_skillTable.effectPath, transform.position, Quaternion.identity);
        }
        else
        {
            _skill = skillObj.GetComponent<Effect>();
        }

        _skillData.UseSkill();
        _skillObject = _skill.GetComponent<SkillObject>();
        if (_skillData.m_skillTable.skillType != e_SkillType.InGameSkill)
            _skillObject.Init(_skillData, GameUtil.GetTarget(_skillData.m_skillTable, this, Ani.Dir, PlayerType == e_PlayerType.CHAR ? true : false), this, m_inputVec);
        else
            _skillObject.Init(_skillData, _target: null, this, m_inputVec);
        _skillObject.SkillEndAction = _skillData.EndSkill;

        skillObjDict[_skillData.m_skillTable.skillName] = _skillObject;
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
        {
            m_fsm.SetState(ePLAYER_STATE.death);
            statusEffectCtrl.RemoveAllStatusEffect();
        }
#else
        if(m_Data.IsDead())
            m_fsm.SetState(ePLAYER_STATE.death);
#endif
    }

    public virtual void Death()
    {
        
    }
}


public partial class Player : MonoBase
{

    public void SetStatusEffect(STATUS_EFFECT _type, float _time, long _value)
    {
        statusEffectCtrl.SetStatusEffect(_type, _time, _value);
    }

    public void EndStatusEffect(int _endCount)
    {
        statusEffectCtrl.EndStatusEffect(_endCount);
    }

    public void EndStatusEffect(STATUS_EFFECT _effect, int _endCount)
    {
        statusEffectCtrl.EndStatusEffect(_effect, _endCount);
    }


    protected class StatusEffectController
    {
        public STATUS_EFFECT Now_Status_Effect { get; protected set; }

        /// <summary>
        /// key == effect type, key == time , value == task queue -Jun 24-10-23
        /// </summary>
        private Dictionary<STATUS_EFFECT, Dictionary<float, Queue<UniTask>>> effectDict;
        private Dictionary<STATUS_EFFECT, Dictionary<float, Queue<CancellationTokenSource>>> cancelTokenDict;
        private Dictionary<STATUS_EFFECT, Dictionary<float, Queue<Effect>>> effectEffectDict;

        private Player thisUnit;

        public StatusEffectController(Player _unit)
        {
            effectDict = new();
            cancelTokenDict = new();
            effectEffectDict = new();
            Now_Status_Effect = STATUS_EFFECT.NONE;

            Debug.Log("넌 또 왜 안나와 시발");
            thisUnit = _unit;
        }

        public bool IsExistStatusEffect(STATUS_EFFECT _effect)
        {
            return Now_Status_Effect.HasFlag(_effect) ? true : false;
        }

        public long GetEffectValue(STATUS_EFFECT _effect)
        {
            if (Now_Status_Effect.HasFlag(_effect) is false)
            {
                return 0;
            }

            return 0;
        }

        public void SetStatusEffect(STATUS_EFFECT _effect, float _time, long _value)
        {
            if (Now_Status_Effect.HasFlag(_effect) is false)
            {
                Now_Status_Effect |= _effect;
            }

            if (effectDict.TryGetValue(_effect, out var dict) is false)
            {
                effectDict.Add(_effect, new());
                cancelTokenDict.Add(_effect, new());
                effectEffectDict.Add(_effect, new());
            }

            if (effectDict[_effect].TryGetValue(_time, out var queue) is false)
            {
                effectDict[_effect].Add(_time, new());
                cancelTokenDict[_effect].Add(_time, new());
                effectEffectDict[_effect].Add(_time, new());
            }

            var newCancelToken = new CancellationTokenSource();
            Effect effect = null;

            switch (_effect)
            {
                case STATUS_EFFECT.FROZEN:
                    effect = EffectManager.instance.Play("Ice_Debuff" , thisUnit.transform.position , Quaternion.identity , 1 , true);                   
                    break;
                default:
                    Debug.LogError($@"status effect check {_effect}");
                    break;
            }

            effectEffectDict[_effect][_time].Enqueue(effect);
            cancelTokenDict[_effect][_time].Enqueue(newCancelToken);
            effectDict[_effect][_time].Enqueue(CaclEffectTime(_effect, _time, _value, newCancelToken));

            thisUnit.StatusEffectActiveAction?.Invoke(_effect, _time);
        }

        private async UniTask CaclEffectTime(STATUS_EFFECT _effect, float _time, long _value, CancellationTokenSource _token)
        {
            float timeCheck = 0;

            while (timeCheck < _time)
            {
                await UniTask.WaitForSeconds(1, cancellationToken: _token.Token);
                timeCheck += 1;

                //if (_effect == STATUS_EFFECT.BURN || _effect == STATUS_EFFECT.CURSED)
                //{
                //    thisUnit.FixedDamageHit(_value);
                //}
                switch (_effect)
                {
                    case STATUS_EFFECT.FROZEN:
                        thisUnit.SetDamage(_value);
                        break;
                    default:
                        Debug.LogError($@"status effect check {_effect}");
                        break;
                }
            }

            //if (_effect == STATUS_EFFECT.ATTACK_UP)
            //{
            //    thisUnit.AddStat(UNIT_STAT_TYPE.ATTACK_POWER, -_value);
            //}

            EndStatusEffect(_effect, _time);
        }

        public void EndStatusEffect(STATUS_EFFECT _effect, float _time)
        {
            if(effectDict.TryGetValue(_effect , out var timeDict) is false || timeDict == null)
            {
                return;
            }

            if(timeDict.TryGetValue(_time , out var queue) is false || queue == null)
            {
                return;
            }

            if (effectDict[_effect][_time].Count == 0 || cancelTokenDict[_effect][_time].Count == 0)
            {
                return;
            }

            thisUnit.StatusEffectEndAction?.Invoke(_effect, _time);

            effectDict[_effect][_time].Dequeue();
            cancelTokenDict[_effect][_time].Dequeue();
            var effect = effectEffectDict[_effect][_time].Dequeue();
            effect.Close();

            if (cancelTokenDict[_effect][_time].Count == 0)
            {
                Now_Status_Effect &= ~_effect;
            }
        }

        /// <summary>
        /// 딱히 effect type 굽분 없이 존재하는 갯수 만약에 한개의 상태이상의 갯수보다 많으면 다음 상태이상으로 넘어감 -Jun 24-12-19
        /// </summary>
        /// <param name="_endCount"></param>
        public void EndStatusEffect(int _endCount)
        {
            foreach (var leftEffectDict in effectDict)
            {
                if (_endCount == 0)
                {
                    break;
                }

                if (leftEffectDict.Value.Count == 0)
                {
                    continue;
                }

                foreach (var queueDict in leftEffectDict.Value)
                {
                    if (queueDict.Value.Count == 0)
                    {
                        continue;
                    }

                    if (_endCount <= 0)
                    {
                        break;
                    }

                    EndStatusEffect(leftEffectDict.Key, queueDict.Key);
                    _endCount--;
                }
            }
        }

        /// <summary>
        /// 하나의 상태이상만 end 상태이상 갯수보다 많으면 넘어가지 않고 그대로 끝 -Jun 24-12-19
        /// </summary>
        /// <param name="_effect"></param>
        /// <param name="_endCount"></param>
        public void EndStatusEffect(STATUS_EFFECT _effect, int _endCount)
        {
            foreach (var leftEffectDict in effectDict)
            {
                if (_endCount == 0)
                {
                    return;
                }

                if (leftEffectDict.Value.Count == 0)
                {
                    return;
                }

                foreach (var queueDict in leftEffectDict.Value)
                {
                    if (queueDict.Value.Count == 0)
                    {
                        continue;
                    }

                    if (_endCount <= 0)
                    {
                        break;
                    }

                    EndStatusEffect(leftEffectDict.Key, queueDict.Key);
                    _endCount--;
                }
            }
        }
        public void RemoveAllStatusEffect()
        {
            foreach (var tokenDict in cancelTokenDict.Values)
            {
                foreach (var tokenQueue in tokenDict.Values)
                {
                    tokenQueue.TryDequeue(out var token);

                    if (token != null)
                    {
                        token.Cancel();
                        token.Dispose();
                        //Util.UniTaskUtil.UniTaskStop(ref token);
                    }
                }
            }

            cancelTokenDict.Clear();
            effectDict.Clear();
            Now_Status_Effect = STATUS_EFFECT.NONE;
        }
    }

}
