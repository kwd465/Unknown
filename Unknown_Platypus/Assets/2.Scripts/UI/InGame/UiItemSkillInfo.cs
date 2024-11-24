using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiItemSkillInfo : UIBase
{
    [SerializeField] Image[] StarImageArr;
    [SerializeField] Image IconImage;
    [SerializeField] Image BorderImage;
    [SerializeField] Image IconBackImage;

    SkillTableData currentData;
    Action<SkillTableData, RectTransform> DataAction = null;

    public void Open(SkillTableData _data, Action<SkillTableData , RectTransform> _callBack , Sprite _borderSprite)
    {
        base.Open();

        currentData = _data;
        DataAction = _callBack;
        IconBackImage.sprite = _borderSprite;

        SetUi();
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
        DataAction?.Invoke(currentData , IconBackImage.GetComponent<RectTransform>());
    }
}
