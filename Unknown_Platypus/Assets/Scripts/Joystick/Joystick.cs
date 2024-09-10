using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Joystick : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IDragHandler
{
    public RectTransform backGround;
    public RectTransform handler;
    public Transform infoPanel;

    public Player player;
    private Vector3 input;
    private Vector3 position;
    private Vector3 move;
    private Vector2 originPos;

    private void Awake()
    {
        //backGround.gameObject.SetActive(false);
        originPos = backGround.position;
    }

    void IDragHandler.OnDrag(PointerEventData eventData)
    {
        if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
        handler, eventData.position, eventData.enterEventCamera, out Vector2 localPoint))
        {
            localPoint.x = localPoint.x  / backGround.sizeDelta.x;
            localPoint.y = localPoint.y / backGround.sizeDelta.y;

            input.x = localPoint.x;
            input.y = localPoint.y;

            input = (input.magnitude > 1.0f) ? input.normalized : input;

            position.x = input.x * (backGround.sizeDelta.x / 2f);
            position.y = input.y * (backGround.sizeDelta.y / 2f);

            handler.anchoredPosition = position;

            move.x = position.x;
            move.y = position.y;

            player.Move(move.normalized);
        }
    }

    void IPointerDownHandler.OnPointerDown(PointerEventData eventData)
    {
        backGround.position = eventData.position;
        handler.localPosition = Vector2.zero;
        backGround.gameObject.SetActive(true);
    }

    void IPointerUpHandler.OnPointerUp(PointerEventData eventData)
    {
        backGround.position = originPos;
        handler.localPosition = Vector2.zero;
        player.Stop();
        move = Vector3.zero;
    }
}
