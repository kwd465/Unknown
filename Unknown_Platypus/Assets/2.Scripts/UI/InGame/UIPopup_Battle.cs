using BH;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class UIPopup_Battle : UIPopup
{
    [SerializeField]
    private Text m_tfTime;

    [SerializeField]
    private Image m_icon;
    [SerializeField]
    private Text m_tfName;
    [SerializeField]
    private Text m_tfLv;

    [SerializeField]
    private Image m_imgHp;
    [SerializeField]
    private Text m_tfHp;
    [SerializeField]
    private Image m_imgExp;

    [SerializeField]
    private Text m_tfStageName;
    [SerializeField]
    private Text m_tfGold;
    [SerializeField]
    private Text m_tfMonKill;


    [SerializeField]
    private Button m_btnBack;
    [SerializeField]
    private Button m_btnBlackHole;
    [SerializeField]
    private Image m_imgBlackHole;


    [SerializeField]
    private Joystick m_joyStick;

    private float m_fBlackHoleTime = 0f;
    private float m_fBlackHoleTimeMAx = 30f;
    private Vector3 m_vecHp = Vector3.one;
    private Vector3 m_vecExp = Vector3.one;
    protected override void Awake()
    {
        base.Awake();
        m_joyStick.player = StagePlayLogic.instance.m_Player;
        SetBtn(m_btnBack, OnClickBack);
        SetBtn(m_btnBlackHole, OnClickBackhole);
    }


    public override void Open()
    {
        base.Open();
        m_vecHp = m_vecHp = Vector3.one;
        m_vecExp = Vector3.one;

        m_vecExp.x = 0f;

        m_imgHp.transform.localScale = m_vecHp;
        m_imgExp.transform.localScale = m_vecExp;   

        SetText(m_tfLv, "1");
        SetText(m_tfHp, "100%");
        SetText(m_tfStageName, GameData.m_curStage.name.ToLocalize());
        ResetData();
    }

    public override void ResetData()
    {
        base.ResetData(); 
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if(m_fBlackHoleTime < m_fBlackHoleTimeMAx)
        {
            m_fBlackHoleTime += Time.deltaTime;
            m_imgBlackHole.fillAmount = m_fBlackHoleTime / m_fBlackHoleTimeMAx;
        }
    }

    public void OnChangeHp(float _amount)
    {
        if (m_imgHp == null)
            return;

        if (_amount < 0)
            _amount = 0;

        SetText(m_tfHp, _amount.ToPercent());
        m_vecHp.x = _amount;
        DOTween.Kill(m_imgHp.transform);
        m_imgHp.transform.DOScale(m_vecHp, 0.1f);
    }

    public void AddGold(int _curCount)
    {
        SetText(m_tfGold, _curCount.ToComma());
    }

    public void AddExp()
    {
         float _amount = (float)StagePlayLogic.instance.m_Player.getData.Exp / StagePlayLogic.instance.m_Player.getData.MaxExp;

        if(_amount > 1)
            _amount = 1f;

        m_vecExp.x = _amount;
        DOTween.Kill(m_imgExp.transform);
        m_imgExp.transform.DOScale(m_vecExp, 0.1f);
    }

    public void AddKill()
    {
        SetText(m_tfMonKill, GameData.m_totalKill.ToGoldText());
    }

    public void LevelUp(int _lv)
    {
        SetText(m_tfLv, _lv.ToString());
    }

    private void OnClickBack()
    {
        //나중에 진짜 나갈껀지 물어보는 팝업 필요할듯
        SceneChanger.instance.ChangeScene();
    }

    private void OnClickBackhole()
    {

    }
}
