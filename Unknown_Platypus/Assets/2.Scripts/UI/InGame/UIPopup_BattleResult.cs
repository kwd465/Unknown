using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using BH;

public class UIPopup_BattleResult : UIPopup
{

    [SerializeField]
    private GameObject m_goWin;
    [SerializeField]
    private GameObject m_goFail;
    [SerializeField]
    private Button m_btnExit;

    [SerializeField]
    private GameObject m_goWinIcon;
    [SerializeField]
    private GameObject m_goFailIcon;
    [SerializeField]
    private TextMeshProUGUI m_tfStageName;
    [SerializeField]
    private TextMeshProUGUI m_tfKillCount;

    [SerializeField]
    private List<UIItem_ItemInfo> m_itemList;


    protected override void Awake()
    {
        base.Awake();
        SetBtn(m_btnExit, OnClickExit);

        for (int i = 0; i < m_itemList.Count; i++)
        {
            m_itemList[i].Close();
        }
    }


    public override void Open() 
    {
        base.Open();

        SetImgActive(m_goWin, GameData.m_isWin);
        SetImgActive(m_goFail, !GameData.m_isWin);
        SetImgActive(m_goWinIcon, GameData.m_isWin);
        SetImgActive(m_goFailIcon, !GameData.m_isWin);

        SetText(m_tfKillCount, GameData.m_totalKill.ToGoldText());
        SetText(m_tfStageName, GameData.m_curStage.name.ToLocalize());

        List<(ItemTableData, int)> _rewardList = StagePlayLogic.instance.RewardList;

        for(int i = 0; i < _rewardList.Count; i++)
        {
            m_itemList[i].Open(_rewardList[i].Item1 , _rewardList[i].Item2);
        }

        for (int i = _rewardList.Count; i < m_itemList.Count; i++)
        {
            m_itemList[i].Close();
        }
    }

    public override void Close()
    {
        base.Close();
    }


    private void OnClickExit()
    {
        //로비로 보낸다
        Close();
        SceneChanger.instance.ChangeScene();
    }

}
   
