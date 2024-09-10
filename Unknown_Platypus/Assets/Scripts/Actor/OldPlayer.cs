using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.InputSystem;


public partial class OldPlayer : ActorBase
{
    private int level = 1;
    private Transform moveTr;    
    private bool isAttack = false;

    public Transform hpBar;
    public Transform AttackAngle;
    public Vector3 inputVec;
    
    public Melee _melee;
    public ShotGun _shotgun;    
    
    public float MaxExp { private set; get; }
    public float Exp { private set; get; }

    int curWeapon;
    Skill skillMelee;
    Skill skillShotgun;

    SkillBase skillAirsphere;
    SkillBase skillElemental;
    SkillBase skillPulsebeam;
    SkillBase skillPlanet;

    private void Awake()
    {
        rigid = GetComponent<Rigidbody2D>();
    }


    private void Start()
    {
        spriteRenderer = null;
        moveTr = transform;
        init(new DataManager.State());

    }

    public override void init(DataManager.State data)
    {
        state = data;

        //var info = TableManager.Instance.tableCharacter.dataList[0];

        //state.hp = info.hp;
        //state.atk = info.atk;
        //state.moveSpeed = info.moveSpeed;
        //state.attackSpeed = 2f;
        //state.def = info.def;
        //state.AttackType = WeaponStyle.Melee;
        MaxExp = state.hp;

        //attackSlider.fillAmount = 0;
        //hpSlider.fillAmount = 1f;

        HP = state.hp;
        animator = null;
        skeletonAnimation = transform.Find("Character").GetComponent<SkeletonAnimation>();        
        _melee.Init(this);
        _shotgun.Init(this);
        curWeapon = 0;
        //weapon = _melee;
        //weapon = state.AttackType == WeaponStyle.Melee ? new Melee() : new Arrow();
        //weapon.Init(this);
        actorType = ActorType.Player;


        SkillManager.instance.InitPlayer(this);

        SetEquipSkill();

        ChangeStatus(ActorStatus.Idle);
    }

    public void ChangeStatus(ActorStatus status)
    {
        base.status = status;

        switch (status)
        {
            case ActorStatus.Idle:
                skeletonAnimation.AnimationState.SetAnimation(0, "idle3", true);
                break;
            case ActorStatus.Move:
                skeletonAnimation.AnimationState.SetAnimation(0, "walk1", true);
                break;
            case ActorStatus.Die:
                break;
        }

    }

    private void SetEquipSkill()
    {
        string skillName = "Prefabs/Skill/ShotGunSkill";
        SkillBase skillBase = Instantiate(Resources.Load(skillName), AttackAngle).GetComponent<SkillBase>();
        skillBase.transform.localRotation = Quaternion.Euler(0, 0, 90);
        skillBase.Init();
        skillShotgun = SkillManager.instance.AddSkill(skillBase, true);
        //skillShotgun.skillSlotIndex = 0;
        //BattleUIManager.instance.SetSkill(0, skillShotgun);

        skillName = "Prefabs/Skill/ScratchbackSkill";
        skillBase = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
        skillBase.Init();
        skillMelee = SkillManager.instance.AddSkill(skillBase, true);
        //skillMelee.skillSlotIndex = 0;
        //BattleUIManager.instance.SetSkill(0, skillMelee);

        skillName = "Prefabs/Skill/PlasmaScarfSkill";
        skillBase = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
        skillBase.Init();
        Skill skill = SkillManager.instance.AddSkill(skillBase, false);
        skill.totalCoolTime = 5;
        skill.coolTime = skill.totalCoolTime;
        //BattleUIManager.instance.SetSkill(1, skill);

        skillName = "Prefabs/Skill/BlackHoleSkill";
        skillBase = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
        skillBase.Init();
        skill = SkillManager.instance.AddSkill(skillBase, true);
        skill.skillSlotIndex = 3;
        BattleUIManager.instance.SetSkill(3, skill);

    }

    private void FixedUpdate()
    {


        Move();

        //FSM();
    }

    private void LateUpdate()
    {

        if (inputVec.magnitude > 0)
        {
            if (skeletonAnimation.AnimationState.GetCurrent(0).Animation.Name.CompareTo("walk1") != 0)
            {
                skeletonAnimation.AnimationState.SetAnimation(0, "walk1", true);
            }
        }
        else
        {
            if (skeletonAnimation.AnimationState.GetCurrent(0).Animation.Name.CompareTo("idle3") != 0)
            {
                skeletonAnimation.AnimationState.SetAnimation(0, "idle3", true);
            }
        }        

        if (inputVec.x != 0)
        {
            skeletonAnimation.skeleton.FlipX = inputVec.x > 0;
        }
    }


    void OnMove(InputValue value)
    {
        inputVec = value.Get<Vector2>();        
    }


    protected override void FSM()
    {
        //if (GameManager.instance.isPause)
        //    return;

        switch (status)
        {
            case ActorStatus.Idle:
                Idle();
                break;
            case ActorStatus.Move:
                Move();
                break;
            case ActorStatus.Die:
                Die();
                break;
        }
    }
    protected override void Idle()
    {
    }
    protected override void Hit(System.Action callback)
    {
    }
    protected override void Move()
    {
        Vector2 nextVec = inputVec * state.moveSpeed * Time.fixedDeltaTime;
        rigid.MovePosition(rigid.position + nextVec);


        if(inputVec != Vector3.zero /*&& !isAttack*/)
        {
            float angle = Mathf.Atan2(inputVec.y, inputVec.x) * Mathf.Rad2Deg;
            AttackAngle.rotation = Quaternion.Euler(0,0,angle-90);            
        }
    }
    public void Attack()
    {
        isAttack = true;
  //      attackSlider.fillAmount = 0.0f;
        //weapon.Attack();
        //_weapon.Attack();
        //_shotgun.Attack();
        //AttackSpeed();
    }
    protected override void Die()
    {
        //animator.SetBool("Die",true);
        //GameManager.instance.isPause = true;
        
    }
    public void SetEXP(float value)
    {
        Exp += value;
        LevelUpCheck();
    }
    public override void SetHP(float damage)
    {
        HP -= damage;
        HP = Mathf.Max(HP - damage, 0);
//        HpSliding();
        if (HP == 0)
            status = ActorStatus.Die;
    }
    public void HpItemGet()
    {
        float value = state.hp * 0.2f;
        HP = Mathf.Clamp(HP += value, 0, state.hp);
//        HpSliding();
    }
    private void LevelUpCheck()
    {
        bool isLevelUp = false;
        if(Exp >= MaxExp)
        {
            float temp = Exp - MaxExp;
            Exp = temp;
            ++level;

            isLevelUp = true;            
        }
        float exp = Exp / MaxExp;
        BattleUIManager.instance.ExpAndLevelSet(level, exp);

        if(isLevelUp)
        {
            BattleUIManager.instance.PlayerLevelUp();
        }
    }

    public void ChangeWeapon()
    {
        if(curWeapon == 0 )
        {
            weapon = _shotgun;
            curWeapon = 1;
            BattleUIManager.instance.SetSkill(0, skillShotgun);
        }
        else
        {
            weapon = _melee;
            curWeapon = 0;
            BattleUIManager.instance.SetSkill(0, skillMelee);
        }
    }

    public void LeanSkill(SkillType skillType)
    {
        if (skillType == SkillType.Airsphere)
        {
            string skillName = "Prefabs/Skill/AirSphereSkill";
            if (skillAirsphere == null)
            {
                skillAirsphere = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
                skillAirsphere.Init();
                skillAirsphere.Actor = this;

                var skill = SkillManager.instance.AddSkill(skillAirsphere, false);
                skill.totalCoolTime = 2.5f;
                skill.coolTime = skill.totalCoolTime;
            }
        }
        else if (skillType == SkillType.Elemental)
        {
            string skillName = "Prefabs/Skill/ElementalSkill";
            if (skillElemental == null)
            {
                skillElemental = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
                skillElemental.Init();
                skillElemental.Actor = this;
                var skill = SkillManager.instance.AddSkill(skillElemental, false);
                skill.totalCoolTime = 1;
                skill.coolTime = 0.1f;
                skill.skillDuration = 0;
            }
        }
        else if (skillType == SkillType.Planet)
        {
            string skillName = "Prefabs/Skill/PlanetSkill";
            if (skillPlanet == null)
            {
                skillPlanet = Instantiate(Resources.Load(skillName), transform).GetComponent<SkillBase>();
                skillPlanet.Init();
                var skill = SkillManager.instance.AddSkill(skillPlanet, false);
                skill.totalCoolTime = 10;
                skill.coolTime = 0.1f;
            }
        }
        else if (skillType == SkillType.Pulsebeam)
        {
            string skillName = "Prefabs/Skill/PulseBeamSkill";
            if (skillPulsebeam == null)
            {
                skillPulsebeam = Instantiate(Resources.Load(skillName)).GetComponent<SkillBase>();
                skillPulsebeam.Init();
                var skill = SkillManager.instance.AddSkill(skillPulsebeam, false);
                skill.totalCoolTime = 7;
                skill.coolTime = 0.1f;
            }
        }
    }
}
