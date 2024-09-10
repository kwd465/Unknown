using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using DG.Tweening;

public class LobbyToggle : MonoBehaviour, ISelectHandler, IDeselectHandler
{
    private Image image;
    private bool isScale;
    private void Awake()
    {
        image = transform.GetChild(0).GetComponent<Image>();
        isScale = transform.localScale.x > 0 ? true : false;
    }
    public void OnDeselect(BaseEventData eventData)
    {
        float scale = isScale ? 1f : -1f;
        image.transform.DOScale(new Vector3(scale, 1f, 1f), 0.5f);
        image.rectTransform.DOAnchorPos(Vector2.zero, 0.5f).SetEase(Ease.Linear);
    }

    public void OnSelect(BaseEventData eventData)
    {
        float scale = isScale ? 1.1f : -1.1f;
        image.transform.DOScale(new Vector3(scale, 1.1f, 1f), 0.5f);
        image.rectTransform.DOAnchorPos(Vector2.up * 10, 0.5f).SetEase(Ease.Linear);
    }
}
