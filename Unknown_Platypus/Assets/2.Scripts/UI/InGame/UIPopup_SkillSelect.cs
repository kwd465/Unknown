using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Linq;
using UnityEditor;

public partial class UIPopup_SkillSelect : UIPopup
{
    [SerializeField] Sprite[] ArrowSpriteArr;
    [SerializeField] Sprite EnterBtnActiveSprite;
    [SerializeField] Sprite EnterBtnInActiveSprite;


    [SerializeField] Image[] m_leftSkillSlot;
    [SerializeField] Image[] m_rightSkillSlot;

    [SerializeField] TextMeshProUGUI m_tfBtn;

    [SerializeField] Button m_btnReset;
    [SerializeField] Button EnterBtn;

    [SerializeField] List<UIItem_SkillInfo> m_uiItemSkillInfo;

    [SerializeField] List<UiItemSkillInfo> SkillInfoList;
    [SerializeField] Arrow ArrowUi;

    private List<SkillTableData> m_haveSkillList = new List<SkillTableData>();
    private readonly int MaxSkillActivityBtnCount = 7;

    private int m_curCount =10;

    private SkillTableData currentData = null;

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

        for(int i=0;i< SkillInfoList.Count;i++)
        {
            SkillInfoList[i].Close();
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

        EnterBtn.GetComponent<Image>().sprite = EnterBtnInActiveSprite;
        EnterBtn.interactable = false;
    }

    public override void ResetData()
    {
        base.ResetData();

        //���� �����Ҽ� �ִ� ���ڸ�ŭ�� �����ְ� �������ش�
        //스킬 받아오는 듯 -Jun 24-10-17
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
                    //이거 아무래도 스킬 맥스 레벨 표시 한것 같은데 ? -Jun 24-10-05
                    if (_haveSkill.skilllv == ConstData.SkillMaxLevel)
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

        for (int i = 0; i < _List.Count; i++)
        {
            if (i < SkillInfoList.Count)
            {
                SkillTableData skill = m_haveSkillList.Find(x => x.group == _List[i].m_group);

                if (skill is not null)
                {
                    if(skill.skilllv == ConstData.SkillMaxLevel)
                    {
                        continue;
                    }

                    SkillInfoList[i].Open(_List[i].m_skillList[skill.skilllv], OnSelect);
                }
                else
                {
                    SkillInfoList[i].Open(_List[i].m_skillList[0], OnSelect);
                }
            }
        }

        for (int i = _List.Count; i < SkillInfoList.Count; i++)
        {
            SkillInfoList[i].Close();
        }

        SetText(m_tfBtn,string.Concat("x ",m_curCount));

        EnterBtn.GetComponent<Image>().sprite = EnterBtnInActiveSprite;
        EnterBtn.interactable = false;
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
        currentData = _data;
        //��ų ������ �˾� �ݴ´�
        //SkillTableData _target = m_haveSkillList.Find(item => item.group == _data.group);
        //int _index = 0;
        //if (_target != null)
        //    _index = _target.skilllv;
        //Debug.Log($@"{_target is null} 이거 레벨 +  1 해줘야 겠는데");
        SkillTableData nextSelectData = null;
        if (_data.skilllv == 1)
        {
            nextSelectData = TableControl.instance.m_skillTable.GetRecord(_data.index + 1);
        }
        else if(_data.skilllv == ConstData.SkillMaxLevel)
        {

        }

        ArrowUi.Init(nextSelectData);

        for (int i = 0; i < _data.SkillOptionList.Count; i++)
        {
            var skillOption = TableControl.instance.m_skillOptionTable.GetSkillOptionData(nextSelectData.SkillOptionList[i]);
            //BH.ResourceControl.instance.GetImage();
        }

        EnterBtn.GetComponent<Image>().sprite = EnterBtnActiveSprite;
        EnterBtn.interactable = true;

        //선택 된거면 이제 초록색으로 바꿔줘야함 -Jun 24-10-19
        //StagePlayLogic.instance.m_Player.SetSkill(_data);
        //StagePlayLogic.instance.SetPause(false);
        //Close();
    }

    /*
     *         //��ų ������ �˾� �ݴ´�
        SkillTableData _target = m_haveSkillList.Find(item => item.group == _data.group);
        int _index = 0;
        if (_target != null)
            _index = _target.skilllv;

        StagePlayLogic.instance.m_Player.SetSkill(_data);
        StagePlayLogic.instance.SetPause(false);
        Close();
     */

    private List<int> RandomSkillOption(SkillTableData _data)
    {
        List<int> _idxList = GetUniqueRandomIndexes(_data);
        List<int> _selectOptionList = new List<int>();
        for(int i = 0 ; i < _idxList.Count ; i++)
        {
            _selectOptionList.Add(_data.SkillOptionList[_idxList[i]]);
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
        if (_data.SkillOptionList.Count > 2)
        {
            return new List<int>();
        }

        System.Random random = new System.Random();
        HashSet<int> uniqueIndexes = new HashSet<int>();

        while (uniqueIndexes.Count < 2)
        {
            int randomIndex = random.Next(_data.SkillOptionList.Count);
            uniqueIndexes.Add(_data.SkillOptionList[randomIndex]);
        }

        return new List<int>(uniqueIndexes);
    }

    public void OnClickSkillActivityBtn(int _index)
    {
        ArrowUi.OnClickSkillActivityBtn(_index);
    }

    public void OnClickEnterBtn()
    {
        StagePlayLogic.instance.m_Player.SetSkill(currentData);
        StagePlayLogic.instance.SetPause(false);
        Close();
    }
}

public partial class UIPopup_SkillSelect : UIPopup
{
    [System.Serializable]
    private class Arrow
    {
        [SerializeField] Sprite AllLineSprite;
        [SerializeField] Sprite SelectSprite;
        [SerializeField] Sprite LastArrowSprite;
        [SerializeField] Image[] ArrowImageArr;
        [SerializeField] TMP_Text ExplantionText;

        SkillTableData currentData;

        //8개 -Jun 24-10-19
        int MaxSkillActivityBtnCount = 7;

        public void Init(SkillTableData _data)
        {
            SetNormal();            

            currentData = _data;
        }

        public void SetNormal()
        {
            for (int i = 0; i < ArrowImageArr.Length; i++)
            {
                ArrowImageArr[i].sprite = AllLineSprite;
            }

            ArrowImageArr[ArrowImageArr.Length - 1].sprite = LastArrowSprite;
            ExplantionText.text = "";
        }

        public void SetTop(int _groupIndex)
        {
            ArrowImageArr[_groupIndex].sprite = SelectSprite;
            ArrowImageArr[_groupIndex].rectTransform.rotation = Quaternion.Euler(0, 0, 0);
        }

        public void SetBottom(int _groupIndex)
        {
            ArrowImageArr[_groupIndex].sprite = SelectSprite;
            ArrowImageArr[_groupIndex].rectTransform.rotation = Quaternion.Euler(180, 0, 0);
        }

        public void OnClickSkillActivityBtn(int _index)
        {
            //ArrowUi.SetBottom();

            if (_index == MaxSkillActivityBtnCount)
            {

            }
            else if (_index == 0)
            {
                SetNormal();
            }
            else
            {
                switch (_index)
                {
                    case 1:
                        SetTop(0);
                        break;
                    case 2:
                        SetBottom(0);
                        break;
                    case 3:
                        SetTop(1);
                        break;
                    case 4:
                        SetBottom(1);
                        break;
                    case 5:
                        SetTop(2);
                        break;
                    case 6:
                        SetBottom(2);
                        break;
                }
            }

            ExplantionText.text = $@"{TableControl.instance.m_skillOptionTable.GetSkillOptionData(currentData.SkillOptionList[_index]).Comment}
{TableControl.instance.m_skillOptionTable.GetSkillOptionData(currentData.SkillOptionList[_index + 1]).Comment}";
        }

        public void Close()
        {

        }
    }
}