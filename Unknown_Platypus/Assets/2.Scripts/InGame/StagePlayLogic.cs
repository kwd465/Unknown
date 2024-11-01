using BH;
using DG.Tweening;
using Newtonsoft.Json.Bson;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using static UnityEditor.Progress;

public class StagePlayLogic : BHSingleton<StagePlayLogic>
{
    public KeyBoardController m_KeyBoardController;
    public Player m_Player;
    public SpawnLogic m_SpawnLogic;
    public StageFsm m_stageFsm;

    private List<SpriteAni> m_SpriteAniList = new List<SpriteAni>();
    private bool m_isPause = false;

    private UIPopup_Battle m_BattleUI;
    public UIPopup_Battle BattleUI => m_BattleUI;
    private int m_getGold;

    public Bounds mapSize;

    private List<(ItemTableData , int)> m_rewardList = new List<(ItemTableData, int)>();

    public List<(ItemTableData, int)> RewardList => m_rewardList;

    public bool IsPause
    {
        get { return m_isPause; }
        set { m_isPause = value; }
    }
   
    public void AddKil()
    {
        GameData.m_totalKill++;
        m_BattleUI.AddKill();
    }


    public void AddItem(ItemTableData _data , int _count)
    {
        if (_data.itemSubType == ItemSubType.EXP)
            AddExp(_count);
        else if (_data.itemSubType == ItemSubType.GOLD)
            AddGold(_count);

        if(_data.itemSubType != ItemSubType.EXP)
        {

            var _findItem = m_rewardList.Find(x => x.Item1 == _data);
            if(_findItem.Item1 == null)
            {
                m_rewardList.Add((_data, _count));
            }
            else
            {
                m_rewardList.Remove(_findItem);
                m_rewardList.Add((_data, _count + _findItem.Item2));
            }
        }
    }


    public void AddGold(int _gold)
    {
        m_getGold = _gold;
        //UI�� ���߿� �ݿ��ؾߵȴ�
        BattleUI.AddGold(m_getGold);
    }
    public void AddExp(int _exp)
    {
        //UI�� ���߿� �ݿ��ؾߵȴ�
        m_Player.getData.AddExp(_exp , IsLevelUp);
        BattleUI.AddExp();
    }

  
    private void IsLevelUp(bool _isLevelUp)
    {
        if (_isLevelUp == true)
        {
            UIPopControl.instance.Open(UIDefine.UIpopSkillSelect);
            BattleUI.LevelUp(m_Player.getData.Lv);
        }
    }

    public override void Init()
    {
        base.Init();
        m_rewardList.Clear();
        SoundControl.PlayBGM("StageBGM");
        mapSize = GameObject.FindGameObjectWithTag("Map").GetComponent<SpriteRenderer>().bounds;

        //����� �⺻ĳ������ ���������� ���Ŀ� �ٲ��� �ȴ�
        PlayerData _pData = new PlayerData(e_PlayerType.CHAR, TableControl.instance.m_characterTable.GetRecord(100001));
        m_Player.Init(e_PlayerType.CHAR ,_pData, new PlayerFsm_User() , Vector2.zero);
        //���߿� �������� Ÿ�Կ� ���� ���¸ӽŸ� �ٲ� ��� �ֵ��� �Ѵ�
        m_stageFsm = new StageFsm();
        m_stageFsm.AddFsm(new StageState_Start());
        m_stageFsm.AddFsm(new StageState_Play());
        m_stageFsm.AddFsm(new StageState_Finish());
        m_stageFsm.AddFsm(new StageState_Boss());
        m_stageFsm.AddFsm(new StageState_BossFInish());
        m_stageFsm.AddFsm(new StageState_BossStart());
        m_stageFsm.AddFsm(new StageState_FAIL());
        m_stageFsm.SetState(eSTAGE_STATE.START);
        UIPopControl.instance.Init();
        m_BattleUI = UIPopControl.instance.Open<UIPopup_Battle>(UIDefine.UIpopBattle);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
        
        UIPopControl.instance.UpdateLogic();

        if(m_isPause)
            return;

        m_stageFsm.Update();
        m_KeyBoardController?.UpdateLogic();
        EffectManager.instance.UpdateLogic();
        //��������Ʈ �ִϸ��̼� ������Ʈ
        for (int i = 0; i < m_SpriteAniList.Count; i++)
        {
            m_SpriteAniList[i].UpdateLogic();
        }
    }

    public void AddSpriteAni(SpriteAni _ani)
    {
        if(m_SpriteAniList.Contains(_ani))
            return;
        m_SpriteAniList.Add(_ani);
    }

    public void SetPause(bool _isPause)
    {
        m_isPause = _isPause;
        
        m_Player.Ani.SetPause(_isPause);
        m_SpawnLogic.SetPause(_isPause);
        if (m_isPause == false)
        {
            DOTween.PlayAll();
            Time.timeScale = 1f;
        }
        else
        {
            Time.timeScale = 0.001f;
            DOTween.PauseAll();
        }
    }
}
