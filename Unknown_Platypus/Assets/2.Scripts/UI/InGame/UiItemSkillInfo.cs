using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiItemSkillInfo : UIBase
{
    [SerializeField] Image[] StarImageArr;
    [SerializeField] Image IconImage;

    SkillTableData currentData;
    Action<SkillTableData> DataAction = null;

    public void Open(SkillTableData _data, Action<SkillTableData> _callBack)
    {
        base.Open();

        currentData = _data;
        DataAction = _callBack;
        
        SetUi();
        Debug.Log("open");
    }

    public void SetUi()
    {
        for (int i = 0; i < StarImageArr.Length; i++)
        {
            SetImgActive(StarImageArr[i], i < currentData.skilllv ? true : false);
        }

        SetIcon(IconImage, currentData.skillicon);
    }

    public void OnClickSkillBtn()
    {
        DataAction?.Invoke(currentData);
    }
}
