using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using BH;
using DG.Tweening;

[DisallowMultipleComponent]
public class UIPopup : UIBase
{
    [Header("==���򸻼���â==")]
    public Button m_btnInfoOn;
    public Button m_btnInfoOff;
    public GameObject m_GOInfo;
    [Space]
    public string m_alramPath;
    public bool OnTween = true;
    public GameObject GOOnTween;
    [Header("Tween �ʱⰪ ����")]
    public Vector3 m_tweenVector = Vector3.zero;
    public Button[] btnClose;
    public System.Action m_callBack;

    protected bool m_isClose = false;

    protected void DelectAllChild(Transform tr)
    {
        var Allchild = tr.GetComponentsInChildren<Transform>(true);
        for (int i = 1; i < Allchild.Length; i++)
        {
            Destroy(Allchild[i].gameObject);
        }
    }

    protected virtual void Awake()
    {
        for (int i = 0; i < btnClose.Length; ++i)
        {
            SetBtn(btnClose[i], OnClick_Close);
        }

        SetBtn(m_btnInfoOn, OnClickInfo);
        SetBtn(m_btnInfoOff, OnClickInfoSelf);
    }

    private void OnClickInfo()
    {
        SetImgActive(m_GOInfo, true);
    }

    private void OnClickInfoSelf()
    {
        SetImgActive(m_GOInfo, false);
    }


    public override void Open()
    {
        base.Open();
        SetImgActive(m_GOInfo, false);

        if (OnTween)
        {
            if (GOOnTween == null)
            {
                transform.DOKill();
                transform.localScale = m_tweenVector;
                transform.DOScale(Vector3.one, 0.35f).SetEase(Ease.InOutBack).OnComplete(() => { CompleteTweenOpen(); });
            }
            else
            {
                GOOnTween.transform.DOKill();
                GOOnTween.transform.localScale = m_tweenVector;
                GOOnTween.transform.DOScale(Vector3.one, 0.35f).SetEase(Ease.InOutBack).OnComplete(() => { CompleteTweenOpen(); });
            }
        }
        else
            transform.localScale = Vector3.one;

        m_isClose = false;

        SetSortLast();
        SetStretch();
    }

    public virtual void CompleteTweenOpen()
    {

    }

    public virtual void CompleteTweenClose()
    {

    }


    public void SetSortLast()
    {
        transform.SetAsLastSibling();
    }

    public void SetStretch()
    {
        RectTransform _rect = gameObject.GetComponent<RectTransform>();
        _rect.sizeDelta = Vector2.zero;
    }
  
    public virtual void OnClick_Close()
    {
        Close();
    }

    

    public override void Close()
    {
        if (string.IsNullOrEmpty(m_alramPath) == false)
            AlarmControl.RemoveAlarm(m_alramPath);

        if (OnTween)
        {
            if(GOOnTween == null){
                gameObject.transform.DOKill();
                gameObject.transform.DOScale( m_tweenVector, 0.15f).OnComplete(()=> { base.Close(); CompleteTweenClose(); });
            }
            else{
                GOOnTween.transform.DOKill();
                GOOnTween.transform.DOScale(m_tweenVector, 0.15f).OnComplete(() => { base.Close(); CompleteTweenClose();});
            }
        }
        else
        {
            base.Close();
        }


        if (m_isClose == false)
        {
            m_callBack?.Invoke();
            m_callBack = null;
        }
        m_isClose = true;
    }

}
