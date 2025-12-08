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
using System.Net.Sockets;
using Coffee.UIExtensions;

public partial class UIPopup_SkillSelect : UIPopup
{
    [Header("Sprite")]
    [SerializeField] Sprite EnterBtnActiveSprite;
    [SerializeField] Sprite EnterBtnInActiveSprite;
    [SerializeField] Sprite ActiveSkillBorderSprite;
    [SerializeField] Sprite PassiveSkillBorderSprite;
    [SerializeField] Sprite BtnCanClickSprite;
    [SerializeField] Sprite BtnCanNotClickSprite;

    [Header("Image")]
    [SerializeField] Image InfoSelectImage; 
    [SerializeField] Image[] m_leftSkillSlot;
    [SerializeField] Image[] m_rightSkillSlot;

    [SerializeField] TextMeshProUGUI m_tfBtn;

    [SerializeField] Button m_btnReset;
    [SerializeField] Button EnterBtn;
    [SerializeField] Button[] InfoBtnArr;

    //[SerializeField] List<UIItem_SkillInfo> m_uiItemSkillInfo; // 현재 미사용 -Jun 24-11-09

    [SerializeField] List<UiItemSkillInfo> SkillInfoList;
    [Header("Arrow UI")]
    [SerializeField] Arrow ArrowUi;
    [SerializeField] LockImage[] LockImageArr;

    [Header("Effect")]
    [SerializeField] UIParticle[] SkillInfoBlinkEffectArr; // 0 위 1 아래 1개만 있으면 0 -Jun 24-12-10
    [SerializeField] UIParticle SkillInfoSelectEffect;
    [SerializeField] UIParticle SkillInfoSelectEnterEffect;
    [SerializeField] UIParticle LastEffectBack;
    [SerializeField] UIParticle LastEffectFront;
    [SerializeField] UIParticle LevelUpEffect;

    [SerializeField] float CloseTime = 1;

    private List<SkillTableData> m_haveSkillList = new List<SkillTableData>();
    private readonly int MaxSkillActivityBtnCount = 7;

    private int m_curCount =10;
    private int currentOptionIndex = -1;

    private SkillTableData selectData = null;
    UiItemSkillInfo selectSkillInfo = null;

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
#if UNITY_EDITOR
        m_curCount = 50;
#else
        m_curCount = 10;
#endif
        m_btnReset.interactable = true;
        m_btnReset.image.sprite = BtnCanClickSprite;

        for (int i = 0; i < SkillInfoList.Count; i++)
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
            if (i == 0)
            {
                LockImageArr[i].SetActive(true);
            }
            else
            {
                LockImageArr[i].SetActive(true);
            }
        }

        ResetData();

        SetActiveEnterBtn(false);

        EffectInit();
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
            if (i < SkillInfoList.Count)
            {
                SkillTableData skill = m_haveSkillList.Find(x => x.group == _List[i].m_group);

                if (skill is not null)
                {
                    if (skill.skilllv == ConstData.SkillMaxLevel)
                    {
                        continue;
                    }

                    SkillInfoList[i].Open(_List[i].m_skillList[skill.skilllv], OnSelect, SelectStar, _List[i].m_skillList[skill.skilllv].skillSubType == e_SkillSubType.Passive ? PassiveSkillBorderSprite : ActiveSkillBorderSprite);
                }
                else
                {
                    SkillInfoList[i].Open(_List[i].m_skillList[0], OnSelect, SelectStar, _List[i].m_skillList[0].skillSubType == e_SkillSubType.Passive ? PassiveSkillBorderSprite : ActiveSkillBorderSprite);
                }
            }
        }

        for (int i = _List.Count; i < SkillInfoList.Count; i++)
        {
            SkillInfoList[i].Close();
        }

        for (int i = 0; i < LockImageArr.Length; i++)
        {
            LockImageArr[i].SetActive(true);
        }

        selectSkillInfo = null;

        SetText(m_tfBtn,string.Concat("x ",m_curCount));

        InfoSelectImage.gameObject.SetActive(false);
        SetActiveEnterBtn(false);

        EffectInit();
    }

    private void OnClickReset()
    {
        if(m_curCount <= 0)
        {
            return;
        }

        m_btnReset.interactable = true;
        m_btnReset.image.sprite = BtnCanClickSprite;
        //Ƚ��? ��ȭ ������ �������ش�
        m_curCount -= 1;
        ResetData();

        if(m_curCount == 0)
        {
            m_btnReset.interactable = false;
            m_btnReset.image.sprite = BtnCanNotClickSprite;
        }
    }

    /// <summary>
    /// 스킬 버튼  클릭시 -Jun 24-10-26
    /// </summary>
    /// <param name="_data">skill data</param>
    private void OnSelect(SkillTableData _data , UiItemSkillInfo _info , RectTransform _backIconRect)
    {
        /*
        //��ų ������ �˾� �ݴ´�
        //SkillTableData _target = m_haveSkillList.Find(item => item.group == _data.group);
        //int _index = 0;
        //if (_target != null)
        //    _index = _target.skilllv;
        */

        selectSkillInfo= _info;
        InitData(_data);
        ArrowUi.ExplantionTextSetNormal();

        InfoSelectImage.gameObject.SetActive(true);
        InfoSelectImage.rectTransform.SetParent(_backIconRect);
        InfoSelectImage.rectTransform.localPosition = Vector3.zero;
        
        //내가 오기전 옛날 코드 -Jun 24-10-19
        //StagePlayLogic.instance.m_Player.SetSkill(_data);
        //StagePlayLogic.instance.SetPause(false);
        //Close();
    }

    private void SelectStar(RectTransform _starRect)
    {
        LevelUpEffect.transform.SetParent(_starRect);
        LevelUpEffect.rectTransform.SetAsLastSibling();
        LevelUpEffect.rectTransform.localPosition = Vector2.zero;
        LevelUpEffect.gameObject.SetActive(false);
    }

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

    private void EffectInit()
    {
        SkillInfoBlinkEffectArr[0].gameObject.SetActive(false);
        SkillInfoBlinkEffectArr[1].gameObject.SetActive(false);
        SkillInfoSelectEffect.gameObject.SetActive(false);
        SkillInfoSelectEnterEffect.gameObject.SetActive(false);
        LastEffectBack.gameObject.gameObject.SetActive(true);
        LastEffectBack.Play();
        LastEffectFront.gameObject.SetActive(true);
        LastEffectFront.Play();
        LevelUpEffect.gameObject.SetActive(false);
    }

    //스킬 선택하고 세부 내용 선택했을때 -Jun 24-10-26
    public void OnClickSkillActivityBtn(int _index)
    {
        ArrowUi.OnClickSkillActivityBtn(_index);

        if (StagePlayLogic.instance.m_Player.IsExistSkillOption(selectData.group, _index))
        {
            return;
        }

        currentOptionIndex = _index;

        if(selectData.skilllv != ConstData.SkillMaxLevel)
        {
            SkillInfoSelectEffect.gameObject.SetActive(true);
            SkillInfoSelectEffect.Play();
            SkillInfoSelectEffect.GetComponent<RectTransform>().position = InfoBtnArr[_index].GetComponent<RectTransform>().position;
        }

        SkillInfoBlinkEffectArr[0].gameObject.SetActive(false);
        SkillInfoBlinkEffectArr[0].Stop();
        SkillInfoBlinkEffectArr[1].gameObject.SetActive(false);
        SkillInfoBlinkEffectArr[1].Stop();

        SkillInfoSelectEnterEffect.GetComponent<RectTransform>().position = InfoBtnArr[_index].GetComponent<RectTransform>().position;

        SetActiveEnterBtn(true);
    }

    public void OnClickEnterBtn()
    {
        StartCoroutine(CoClose());
    }

    private IEnumerator CoClose()
    {
        LevelUpEffect.gameObject.SetActive(true);
        SkillInfoSelectEnterEffect.gameObject.SetActive(true);
        selectSkillInfo.SetStarLevelUp();
        SetActiveEnterBtn(false);

        yield return new WaitForSecondsRealtime(CloseTime);

        StagePlayLogic.instance.m_Player.SetSkill(selectData);
        StagePlayLogic.instance.m_Player.AddSkillOption(selectData.group, currentOptionIndex);
        StagePlayLogic.instance.SetPause(false);

        Close();
    }

    public void SetActiveEnterBtn(bool _isActive)
    {
        EnterBtn.GetComponent<Image>().sprite = _isActive ? EnterBtnActiveSprite : EnterBtnInActiveSprite;
        EnterBtn.interactable = _isActive;
    }

    private void InitData(SkillTableData _data)
    {
        selectData = _data;
        
        SetActiveEnterBtn(false);

        ArrowUi.Init(selectData);
        EffectInit();

        //첫번쨰 꺼는 스킬 아이콘 그대로 -Jun 24-11-09
        LockImageArr[0].OnlyFirst(BH.ResourceControl.instance.GetImage(selectData.skillicon)); //.SelectOne(true, BH.ResourceControl.instance.GetImage(selectData.skillicon), null);
        LockImageArr[LockImageArr.Length - 1].OnlyLastInit();

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

        if (selectData.skilllv == 1)
        {
            SkillInfoBlinkEffectArr[0].gameObject.SetActive(true);
            SkillInfoBlinkEffectArr[0].Play();
            SkillInfoBlinkEffectArr[0].GetComponent<RectTransform>().position = InfoBtnArr[0].GetComponent<RectTransform>().position;

            SkillInfoBlinkEffectArr[1].gameObject.SetActive(false);
        }
        else if (selectData.skilllv != ConstData.SkillMaxLevel)
        {
            int index = 0;
            switch (_data.skilllv)
            {
                case 2:
                    index = 1;
                    break;
                case 3:
                    index = 3;
                    break;
                case 4:
                    index = 5;
                    break;
            }

            SkillInfoBlinkEffectArr[0].gameObject.SetActive(true);
            SkillInfoBlinkEffectArr[0].Play();
            SkillInfoBlinkEffectArr[0].GetComponent<RectTransform>().position = InfoBtnArr[index].GetComponent<RectTransform>().position;

            SkillInfoBlinkEffectArr[1].gameObject.SetActive(true);
            SkillInfoBlinkEffectArr[1].Play();
            SkillInfoBlinkEffectArr[1].GetComponent<RectTransform>().position = InfoBtnArr[index + 1].GetComponent<RectTransform>().position;
        }

        var skillOptionIndexList = StagePlayLogic.instance.m_Player.GetSkillOptionList(selectData.group);

        if (skillOptionIndexList == null || skillOptionIndexList.Count == 0)
        {
            return;
        }

        //현재 선택 데이터는 내 스킬의 현 선택된 최대 레벨보다 +1 데이터 이고 그 이전 데이터를 선택하려 하므로 -2 -Jun 24-11-01
        for (int i = 0; i < selectData.skilllv - 1; i++)
        {
            LockImageArr[i].SelectOne(skillOptionIndexList[i] % 2 == 0, null, null);

            //ArrowUi.SetTop();
        }

        for (int i = 0; i < skillOptionIndexList.Count; i++)
        {
            OnClickSkillActivityBtn(skillOptionIndexList[i]);
        }

        //SkillInfoSelectEffect.gameObject.SetActive(false);
    }
}

public partial class UIPopup_SkillSelect : UIPopup
{
    [System.Serializable]
    private class Arrow
    {
        [SerializeField] Sprite AllLineSprite;
        [SerializeField] Sprite SelectSprite;
        [SerializeField] Sprite LastArrowInActiveSprite;
        [SerializeField] Sprite LastArrowSprite;
        [SerializeField] Image[] ArrowImageArr;
        [SerializeField] TMP_Text ExplantionText;

        SkillTableData selectData;

        //8개 -Jun 24-10-19
        int MaxSkillActivityBtnCount = 7;

        public void ExplantionTextSetNormal()
        {
            ExplantionText.text = "";
        }

        public void Init(SkillTableData _data)
        {
            selectData = _data;
            SetNormal();
        }

        public void SetNormal()
        {
            for (int i = 0; i < ArrowImageArr.Length; i++)
            {
                ArrowImageArr[i].sprite = AllLineSprite;
            }

            if (selectData is not null)
            {
                ArrowImageArr[ArrowImageArr.Length - 1].sprite = selectData.skilllv >= ConstData.SkillMaxLevel ? LastArrowSprite : LastArrowInActiveSprite;
            }
            else
            {
                ArrowImageArr[ArrowImageArr.Length - 1].sprite = LastArrowInActiveSprite;
            }

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
        [SerializeField] Image TopIconImage;
        [SerializeField] Image BottomIconImage;

        public void SetActive(bool _isActive)
        {
            TopLockIconImage.gameObject.SetActive(_isActive);
            TopBlackImage.gameObject.SetActive(_isActive);
            TopClickBtn.interactable = !_isActive;
            TopIconImage.gameObject.SetActive(!_isActive);
            
            //last 한개여서 top 에만 넣어놨음 -Jun 24-10-26
            if (BottomBlackImage == null)
            {
                return;
            }

            BottomLockIconImage.gameObject.SetActive(_isActive);
            BottomBlackImage.gameObject.SetActive(_isActive);
            BottomIconImage.gameObject.SetActive(!_isActive);
            BottomClickBtn.interactable = !_isActive;
        }

        public void OnlyFirst(Sprite _icon)
        {
            TopIconImage.sprite = _icon == null ? TopIconImage.sprite : _icon;
        }

        public void OnlyLastInit()
        {
            TopClickBtn.interactable = false;
            TopLockIconImage.gameObject.SetActive(true);
            TopBlackImage.gameObject.SetActive(true);
            TopIconImage.gameObject.SetActive(true);
        }

        public void SelectOne(bool _isTop, Sprite _topIconImage, Sprite _bottomIconImage)
        {
            //첫번째와 , 마지막 한개여서 top 에만 넣어놨음 -Jun 24-10-26
            //첫번쨰 마지막은 선택 가능하게
            if (BottomBlackImage == null)
            {
                TopClickBtn.interactable = false;
                TopLockIconImage.gameObject.SetActive(false);
                TopBlackImage.gameObject.SetActive(false);
                return;
            }

            TopLockIconImage.gameObject.SetActive(false);
            TopIconImage.gameObject.SetActive(true);
            TopBlackImage.gameObject.SetActive(_isTop);
            TopIconImage.sprite = _topIconImage == null ? TopIconImage.sprite : _topIconImage;
            TopClickBtn.interactable = false;

            BottomLockIconImage.gameObject.SetActive(false);
            BottomIconImage.gameObject.SetActive(true);
            BottomBlackImage.gameObject.SetActive(_isTop is false);
            BottomIconImage.sprite = _topIconImage == null ? BottomIconImage.sprite : _topIconImage;
            BottomClickBtn.interactable = false;
        }
    }
}