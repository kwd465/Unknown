using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class BattleUIManager : Singleton<BattleUIManager>
{
    private Tweener expTweener;
    private int level = 1;
    [SerializeField] LevelUpUI levelUpPanel;
    private OldPlayer player;

    public Text timeText;
    public Text levelText;
    public Image expSlider;
    public RectTransform stageSlider;

    public UISkillButton[] skillButton;

    public GameObject[] completePoint;
    public GameObject[] nowPoint;


    private void Start()
    {
        Init();
    }
    private void Init()
    {   
        levelText.text = "1";
        level = 1;
        expSlider.fillAmount = 0;
        player = FindObjectOfType<OldPlayer>();

        for(int i=0; i<4; i++)
        {
            completePoint[i].SetActive(false);
            nowPoint[i].SetActive(false);
        }
        SetStage(0);

    }
    public void PlayerLevelUp()
    {
        //GameManager.instance.isPause = true;
        //if (levelUpPanel == null)
        //{
        //    levelUpPanel = Instantiate(Resources.Load<LevelUpUI>("Prefabs/UI/LevelUp"));
        //    levelUpPanel.gameObject.SetActive(false);
        //}
        levelUpPanel.SkillInit();
        //levelUpPanel.OnUI();
    }
    public void TimeSliderSet(float time)
    {
        stageSlider.sizeDelta = new Vector2(1500f * time / 600, 14);
        int minutes = (int)(time / 60f);
        int seconds = (int)(time % 60f);
        timeText.text = string.Format("{0} : {1:00}", minutes, seconds);
    }

    public void SetStage(int stage)
    {
        if( stage == 0 )
        {
            nowPoint[0].SetActive(true);
        }
        else if( stage == 1)
        {
            nowPoint[0].SetActive(false);
            completePoint[0].SetActive(true);
            nowPoint[1].SetActive(true);
        }
        else if( stage == 2)
        {
            nowPoint[1].SetActive(false);
            completePoint[1].SetActive(true);
            nowPoint[2].SetActive(true);
        }
        else
        {
            nowPoint[2].SetActive(false);
            completePoint[2].SetActive(true);
            completePoint[3].SetActive(true);
        }
    }

    public void ExpAndLevelSet(int _level, float exp)
    {
        if(level != _level)
        {
            level = _level;
            levelText.text = level.ToString();
            expSlider.fillAmount = exp;
            expTweener = expSlider.DOFillAmount(1, 0.1f).SetEase(Ease.InOutSine).OnComplete(() => {
                expSlider.fillAmount = 0;
                expSlider.DOFillAmount(exp, 0.1f).SetEase(Ease.InOutSine);
            });
        }
        else
        {
            if (expTweener != null && expTweener.IsPlaying())
                expTweener.Kill();

            expTweener = expSlider.DOFillAmount(exp, 0.1f).SetEase(Ease.InOutSine);
        }
    }
    public void BackBtn()
    {
        SceneChanger.instance.ChangeScene();
    }    

    public void ChangeWeapon()
    {
        //GameManager.instance.ChangeWeapon();
    }

    public void SetSkill(int slot, Skill skill)
    {
        skillButton[slot].SetSkill(skill);
        skillButton[slot].SetLock();
    }

    public void UpdateSkillButton(int slot, Skill skill)
    {
        if (skill.state == Skill.SkillState.cool) 
            skillButton[slot].UpdateCool(1f-(skill.coolTime/skill.totalCoolTime));
    }

    public void SetSkillButttonReady(int slot)
    {
        skillButton[slot].SetReady();
    }

    public void SetSkillButtonLock(int slot)
    {
        skillButton[slot].SetLock();
    }




}
