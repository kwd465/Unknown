using BH;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIItem_SkillInfo : UIBase
{
    [SerializeField]
    private GameObject m_goNew;
    [SerializeField]
    private GameObject m_goMaster;

    [SerializeField]
    private GameObject[] m_goStars;
    [SerializeField]
    private Button m_btnSelect;
    [SerializeField]
    private Image m_imgIcon;
    [SerializeField]
    private TextMeshProUGUI m_tfName;
    [SerializeField]
    private TextMeshProUGUI m_tfDesc;
    [SerializeField]
    private TextMeshProUGUI m_tfLevel;

    private Action<SkillTableData> m_action;
    private SkillTableData m_data;

    private void Awake()
    {
        SetBtn(m_btnSelect , OnSelect);
    }

    public virtual void Open(SkillTableData _data , Action<SkillTableData> _callBack)
    {
        base.Open();
        m_data = _data;
        m_action = _callBack;
        for(int i = 0; i < m_goStars.Length; i++)
        {
            SetImgActive(m_goStars[i], false);
        }
        ResetData();

    }

    public override void ResetData()
    {
        base.ResetData();

        SetImgActive(m_goNew, m_data.skilllv == 1);
        SetImgActive(m_goMaster, m_data.skilllv == 4);

        for (int i = 0; i < m_data.skilllv; i++)
        {
            SetImgActive(m_goStars[i], true);
        }

        SetIcon(m_imgIcon, m_data.skillicon);
        SetText(m_tfName, m_data.skillName.ToLocalize());
        SetText(m_tfDesc, m_data.skillDesc.ToLocalize());
        SetText(m_tfLevel, m_data.skillSubDesc.ToLocalize());
    }

    private void OnSelect()
    {
        m_action?.Invoke(m_data);
    }

}
