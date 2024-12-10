using Coffee.UIExtensions;
using DG.Tweening;
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

    Image nowActiveLevelStar;

    SkillTableData currentData;
    Action<SkillTableData, UiItemSkillInfo, RectTransform> DataAction = null;
    Action<RectTransform> StarCallBack = null;

    Coroutine starCoroutine = null;

    public void Open(SkillTableData _data, Action<SkillTableData , UiItemSkillInfo, RectTransform> _callBack , Action<RectTransform> _starCallBack , Sprite _borderSprite)
    {
        base.Open();

        currentData = _data;
        DataAction = _callBack;
        StarCallBack = _starCallBack;
        IconBackImage.sprite = _borderSprite;

        SetUi();
    }

    public void SetUi()
    {
        if (starCoroutine != null)
        {
            StopCoroutine(starCoroutine);
        }
        starCoroutine = null;

        for (int i = 0; i < StarImageArr.Length; i++)
        {
            SetImgActive(StarImageArr[i], i < currentData.skilllv ? true : false);
            StarImageArr[i].color = new Color(1,1,1,1);
        }

        SetIcon(IconImage, currentData.skillicon);

        starCoroutine = StartCoroutine(CoStarFade());
    }

    public void SetStarLevelUp()
    {
        if (starCoroutine != null)
        {
            StopCoroutine(starCoroutine);
        }
        starCoroutine = null;

        for (int i = 0; i < StarImageArr.Length; i++)
        {
            nowActiveLevelStar.gameObject.SetActive(true);
            nowActiveLevelStar.color= new Color(1, 1, 1, 1);
        }
    }

    public void OnClickSkillBtn()
    {
        DataAction?.Invoke(currentData,this , IconBackImage.GetComponent<RectTransform>());
        StarCallBack?.Invoke(nowActiveLevelStar.rectTransform);
    }

    private IEnumerator CoStarFade()
    {
        yield return null;
        nowActiveLevelStar = StarImageArr[currentData.skilllv - 1];
        
        bool isFadeIn = true;

        while (gameObject.activeInHierarchy)
        {
            yield return null;
            
            if (nowActiveLevelStar.color.a <= 0.9f && isFadeIn)
            {
                nowActiveLevelStar.color = new Color(1, 1, 1, nowActiveLevelStar.color.a + 0.02f);
            }
            else
            {
                nowActiveLevelStar.color = new Color(1, 1, 1, nowActiveLevelStar.color.a - 0.02f);
            }

            if(nowActiveLevelStar.color.a <= 0)
            {
                isFadeIn = true;
            }
            else if(nowActiveLevelStar.color.a >= 0.9f)
            {
                isFadeIn = false;
            }
        }
    }
}
