using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Linq;
using UnityEditor;
using UnityEngine.InputSystem.Composites;
using UnityEngine.AI;
using Unity.VisualScripting;

public partial class UIPopup_SkillSelect : UIPopup
{
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
    [SerializeField] LockImage[] LockImageArr;

    private List<SkillTableData> m_haveSkillList = new List<SkillTableData>();
    private readonly int MaxSkillActivityBtnCount = 7;

    private int m_curCount =10;
    private int currentOptionIndex = -1;

    private SkillTableData selectData = null;

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

        ArrowUi.SetNormal();

        for (int i = 0; i < LockImageArr.Length; i++)
        {
            LockImageArr[i].SetActive(true);
        }

        ResetData();

        SetActiveEnterBtn(false);
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

        SetActiveEnterBtn(false);
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

    /// <summary>
    /// 스킬 버튼  클릭시 -Jun 24-10-26
    /// </summary>
    /// <param name="_data">skill data</param>
    private void OnSelect(SkillTableData _data)
    {
        //��ų ������ �˾� �ݴ´�
        //SkillTableData _target = m_haveSkillList.Find(item => item.group == _data.group);
        //int _index = 0;
        //if (_target != null)
        //    _index = _target.skilllv;

        //if (StagePlayLogic.instance.m_Player.IsSkillGeted(_data.group))
        //{
        //    selectData = TableControl.instance.m_skillTable.GetRecord(_data.index + 1);
        //}
        //else
        //{
        //    selectData = TableControl.instance.m_skillTable.GetRecord(_data.index);
        //}

        //selectData = TableControl.instance.m_skillTable.GetRecord(_data.index);
        selectData = _data;
        Debug.Log($@"level check {selectData.skilllv}");
        if (selectData.SelectSkillOptionList != null)
            Debug.Log($@"{selectData.SelectSkillOptionList.Count}");
        else
            Debug.Log($@"null");
        SetActiveEnterBtn(false);

        ArrowUi.Init(selectData);

        for (int i = 0; i < LockImageArr.Length; i++)
        {
            if (i >= selectData.skilllv)
            {
                LockImageArr[i].SetActive(true);
            }
            else
            {
                LockImageArr[i].SetActive(false);
            }
        }

        for (int i = 0; i < selectData.SelectSkillOptionList.Count; i++)
        {
            OnClickSkillActivityBtn(selectData.SelectSkillOptionList[i]);
        }

        //나중에 아이콘 나오면 -Jun 24-10-26
        //for (int i = 0; i < _data.SkillOptionList.Count; i++)
        //{
        //    var skillOption = TableControl.instance.m_skillOptionTable.GetSkillOptionData(nextSelectData.SkillOptionList[i]);

        //    BH.ResourceControl.instance.GetImage();
        //}

        //내가 오기전 옛날 코드 -Jun 24-10-19
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

    //스킬 선택하고 세부 내용 선택했을때 -Jun 24-10-26
    public void OnClickSkillActivityBtn(int _index)
    {
        ArrowUi.OnClickSkillActivityBtn(_index);

        currentOptionIndex = _index;

        SetActiveEnterBtn(true);
    }

    public void OnClickEnterBtn()
    {
        if (StagePlayLogic.instance.m_Player.IsSkillGeted(selectData.group))
        {
            //currentOptionIndex
            if (selectData.SelectSkillOptionList == null || selectData.SelectSkillOptionList.Count == 0)
            {
                selectData.SelectSkillOptionList = new();
            }

            //홀수 == 0 , 짝수 == 2 -Jun 24-10-29
            int caclIndex = currentOptionIndex % 2 == 1 ? 0 : 2;

            selectData.SelectSkillOptionList.Add(selectData.SkillOptionList[caclIndex]);
            //selectData.SelectSkillOptionList.Add(selectData.SkillOptionList[caclIndex]);
            //selectData.SelectSkillOptionList.Add(selectData.SkillOptionList[caclIndex + 1]);
        }

        StagePlayLogic.instance.m_Player.SetSkill(selectData);
        StagePlayLogic.instance.SetPause(false);
        Close();
    }

    public void SetActiveEnterBtn(bool _isActive)
    {
        EnterBtn.GetComponent<Image>().sprite = _isActive ? EnterBtnActiveSprite : EnterBtnInActiveSprite;
        EnterBtn.interactable = _isActive;
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

        SkillTableData selectData;

        //8개 -Jun 24-10-19
        int MaxSkillActivityBtnCount = 7;

        public void Init(SkillTableData _data)
        {
            SetNormal();

            selectData = _data;
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
            int caclOptionIndex = 0;

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
                        caclOptionIndex = 0;
                        break;
                    case 2:
                        SetBottom(0);
                        caclOptionIndex = 2;
                        break;
                    case 3:
                        SetTop(1);
                        caclOptionIndex = 0;
                        break;
                    case 4:
                        SetBottom(1);
                        caclOptionIndex = 2;
                        break;
                    case 5:
                        SetTop(2);
                        caclOptionIndex = 0;
                        break;
                    case 6:
                        SetBottom(2);
                        caclOptionIndex = 2;
                        break;
                }
            }

            SkillTableData getSkillData = TableControl.instance.m_skillTable.GetRecord(selectData.index);

            if (selectData.SkillOptionList == null || selectData.SkillOptionList.Count == 0)
            {
                ExplantionText.text = "";
            }
            else
            {
                ExplantionText.text = $@"{TableControl.instance.m_skillOptionTable.GetSkillOptionData(selectData.SkillOptionList[caclOptionIndex]).Comment}
{TableControl.instance.m_skillOptionTable.GetSkillOptionData(selectData.SkillOptionList[caclOptionIndex + 1]).Comment}";
            }
        }

        public void Close()
        {

        }
    }

    [System.Serializable]
    private class LockImage
    {
        [SerializeField] Button TopClickBtn;
        [SerializeField] Button BottomClickBtn;
        [SerializeField] Image TopBlackImage;
        [SerializeField] Image TopLockIconImage;
        [SerializeField] Image BottomBlackImage;
        [SerializeField] Image BottomLockIconImage;


        public void SetActive(bool _isActive)
        {
            TopLockIconImage.gameObject.SetActive(_isActive);
            TopBlackImage.gameObject.SetActive(_isActive);
            TopClickBtn.interactable = !_isActive;

            //last 한개여서 top 에만 넣어놨음 -Jun 24-10-26
            if (BottomBlackImage == null)
            {
                return;
            }

            BottomLockIconImage.gameObject.SetActive(_isActive);
            BottomBlackImage.gameObject.SetActive(_isActive);
            BottomClickBtn.interactable = !_isActive;
        }
    }
}