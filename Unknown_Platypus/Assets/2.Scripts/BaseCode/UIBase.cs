using BH;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIBase : MonoBase
{
    private RectTransform rt = null;

    public void SetBtn(Button _btn, UnityEngine.Events.UnityAction _click, bool _isSound = true)
    {
        if (null == _btn)
            return;

        _btn.onClick.AddListener(_click);
        if (_isSound == true)
            _btn.onClick.AddListener(()=>SoundControl.Play("click"));
    }

    public void SetBtnEnable( Button _btn, bool _enable)
    {
        if (null == _btn)
            return;

        _btn.interactable = _enable;
    }

    public void SetToggle( Toggle _toggle, UnityEngine.Events.UnityAction<bool> _change)
    {
        if (null == _toggle)
            return;

        _toggle.onValueChanged.AddListener(_change);       
    }

    public void SetText(Text _text, string _dest)
    {
        if (null == _text)
            return;

        if ( string.IsNullOrEmpty(_dest) == true)
        {
            _text.gameObject.SetActive(false);
            return;
        }

        _text.gameObject.SetActive(true);
        _text.text = _dest;
    }

    public void SetText(TextMeshProUGUI _text, string _dest)
    {
        if (null == _text)
            return;

        if (string.IsNullOrEmpty(_dest) == true)
        {
            _text.gameObject.SetActive(false);
            return;
        }

        _text.gameObject.SetActive(true);
        _text.text = _dest;
    }



    public void SetIcon(SpriteRenderer _icon , string _path)
    {
        if (null == _icon)
            return;

        if (_path == null || _path.Length <= 0)
        {
            _icon.gameObject.SetActive(false);
            return;
        }

        _icon.gameObject.SetActive(true);
        _icon.sprite = BH.ResourceControl.instance.GetImage(_path);
    }


    public void SetIcon(Image _icon, string _path)
    {
        if (null == _icon)
            return;

        if (_path == null || _path.Length <= 0)
        {
            _icon.gameObject.SetActive(false);
            return;
        }

        _icon.gameObject.SetActive(true);
        _icon.sprite = BH.ResourceControl.instance.GetImage(_path);
    }

    public void SetFillAmount( Image _img, float _amount)
    {
        if (null == _img)
            return;

        _img.gameObject.SetActive(true);
        _img.fillAmount = _amount;
    }

    public void SetColor(MaskableGraphic _img, Color _color )
    {
        if (null == _img)
            return;

        _img.color = _color;
    }

    public void SetColor(Button _btn, Color _color)
    {
        if (null == _btn)
            return;

        _btn.image.color = _color;
    }

    public void SetImgActive( GameObject _img, bool _isActive )
    {
        if (null == _img)
            return;

        _img.SetActive(_isActive);
    }

    public void SetImgActive(GameObject[] _img, bool _isActive)
    {
        if (null == _img)
            return;

        for (int i = 0; i < _img.Length; ++i)
        {
            SetImgActive(_img[i], _isActive);
        }
    }

    public void SetImgActive(Toggle _toggle, bool _isActive)
    {
        if (null == _toggle)
            return;

        _toggle.gameObject.SetActive(_isActive);
    }

    public void SetImgActive(Image _img, bool _isActive)
    {
        if (null == _img)
            return;

        _img.gameObject.SetActive(_isActive);
    }

    public void SetImgActive(Text _text, bool _isActive)
    {
        if (null == _text)
            return;

        _text.gameObject.SetActive(_isActive);
    }

    public void SetImgActive(Button _btn, bool _isActive)
    {
        if (null == _btn)
            return;

        _btn.gameObject.SetActive(_isActive);
    }


    public virtual void ResetData()
    {

    }

    public virtual void Hide()
    {
        transform.position = new Vector3(-2000f, 0, 0);
    }

    public virtual void Show()
    {
        transform.position = Vector3.zero;
    }


    //CSF 버그이슈
    public void RefeshRectTransform(RectTransform _tr)
    {
        LayoutRebuilder.ForceRebuildLayoutImmediate(_tr);
    }

    //노치 해상도 대응 함수
    public void SetNotchScreen()
    {

        if (rt == null)
            rt = transform.GetComponent<RectTransform>();

        RectTransform rootRt = transform.root.GetComponent<RectTransform>();
        float _scale = rootRt.rect.width / Screen.width;
        float fixSize = Screen.safeArea.xMin * _scale;
        if (Screen.orientation == ScreenOrientation.LandscapeRight)
        {
            rt.offsetMin = Vector2.zero;
            rt.offsetMax = new Vector2(-fixSize, 0);
        }
        else if (Screen.orientation == ScreenOrientation.LandscapeLeft)
        {
            rt.offsetMax = Vector2.zero;
            rt.offsetMin = new Vector2(fixSize, 0);
        }
    }


    //스크롤 센터 정렬
    public void CentorScrollItem(ScrollRect _rect, int _index, float _height, float _top = 0, float bottom = 0, float _spcing = 0)
    {
        float _totalH = (_top + (_index * _height) + (_index * _spcing) + bottom);
        Vector2 _pos = _rect.content.anchoredPosition;
        _pos.y = _totalH;
        _rect.content.anchoredPosition = _pos;
    }
}
