using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIPopup_SkillSelect : UIPopup
{

    [SerializeField]
    private Image[] m_leftSkillSlot;
    [SerializeField]
    private Image[] m_rightSkillSlot;

    [SerializeField]
    private TextMeshProUGUI m_tfBtn;

    [SerializeField]
    private Button m_btnReset;
    [SerializeField]
    private List<UIItem_SkillInfo> m_uiItemSkillInfo;

    private List<SkillTableData> m_haveSkillList = new List<SkillTableData>();

    private int m_curCount =10;

    protected override void Awake()
    {
        base.Awake();
        SetBtn(m_btnReset, OnClickReset);
    }

    public override void CompleteTweenOpen()
    {
        base.CompleteTweenOpen();
        StagePlayLogic.instance.SetPause(true);
    }

    public override void Open()
    {
        base.Open();
        m_curCount = 10;
        for (int i = 0; i < m_uiItemSkillInfo.Count; i++)
        {
            m_uiItemSkillInfo[i].Close();
        }

        //���� �����ߴ� ��ų�� ������ ������� �Ѵ�
        m_haveSkillList = StagePlayLogic.instance.m_Player.GetInGameSkill();

        for (int i = 0; i < m_haveSkillList.Count; i++)
        {
            if (i < m_leftSkillSlot.Length)
            {
                SetIcon(m_leftSkillSlot[i], m_haveSkillList[i].skillicon);
            }
        }

        for (int i = m_haveSkillList.Count; i < m_leftSkillSlot.Length; i++)
        {
            SetImgActive(m_leftSkillSlot[i], false);
        }

        ResetData();
    }

    public override void ResetData()
    {
        base.ResetData();

        //���� �����Ҽ� �ִ� ���ڸ�ŭ�� �����ְ� �������ش�
        List<SkillGroupData> _List =  TableControl.instance.m_skillTable.GetSkillGroupList(e_SkillType.InGameSkill);

        _List = _List.GetRandomList(4);

        for (int i = 0; i < _List.Count; i++)
        {
            if(i < m_uiItemSkillInfo.Count)
            {
                SkillTableData _haveSkill = m_haveSkillList.Find(item => item.group == _List[i].m_group);
                if (_haveSkill != null)
                {
                    //���߿� ��å���� ���׷��̵� �ؾߵȴ�
                    if (_haveSkill.skilllv == 4)
                        continue;

                    m_uiItemSkillInfo[i].Open(_List[i].m_skillList[_haveSkill.skilllv], OnSelect);
                }
                else
                {
                    m_uiItemSkillInfo[i].Open(_List[i].m_skillList[0], OnSelect);
                }
            }
        }

        for(int i = _List.Count; i < m_uiItemSkillInfo.Count; i++)
        {
            m_uiItemSkillInfo[i].Close();
        }

        SetText(m_tfBtn,string.Concat("x ",m_curCount));
    }

    private void OnClickReset()
    {
        if(m_curCount <= 0)
        {
            return;
        }
        //Ƚ��? ��ȭ ������ �������ش�
        m_curCount -= 1;
        ResetData();
    }

    private void OnSelect(SkillTableData _data)
    {
        //��ų ������ �˾� �ݴ´�
        SkillTableData _target = m_haveSkillList.Find(item => item.group == _data.group);
        int _index = 0;
        if (_target != null)
            _index = _target.skilllv;

        StagePlayLogic.instance.m_Player.SetSkill(_data);
        StagePlayLogic.instance.SetPause(false);
        Close();
    }




    private List<int> RandomSkillOption(SkillTableData _data)
    {
        List<int> _idxList = GetUniqueRandomIndexes(_data);
        List<int> _selectOptionList = new List<int>();
        for(int i = 0 ; i < _idxList.Count ; i++)
        {
            _selectOptionList.Add(_data.skillOptionLiist[_idxList[i]]);
        }
        return _selectOptionList;
    }




    /// <summary>
    /// Random 2 unique indexes from the skillOptionList
    /// </summary>
    /// <param name="_data"></param>
    /// <returns></returns>
    private List<int> GetUniqueRandomIndexes(SkillTableData _data)
    {
        if (_data.skillOptionLiist.Count > 2)
        {
            return new List<int>();
        }

        System.Random random = new System.Random();
        HashSet<int> uniqueIndexes = new HashSet<int>();

        while (uniqueIndexes.Count < 2)
        {
            int randomIndex = random.Next(_data.skillOptionLiist.Count);
            uniqueIndexes.Add(_data.skillOptionLiist[randomIndex]);
        }

        return new List<int>(uniqueIndexes);
    }

    
}
