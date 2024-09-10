using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class LobbyUIManager : MonoBehaviour
{
    [SerializeField]
    private Image[] bgStar;
    [SerializeField]
    private RectTransform shootingStar;
    [SerializeField]
    private RectTransform endV;
    [SerializeField]
    private RectTransform bgRectTransform;

    public UIBase testUI;

    private Vector2 start;
    private float starDuration = 2f;
    private float shootingDuration = 4f;
    private float moveSpeed = 2f;
    private float clampedX, clampedY;
    private int index = 0;
    private float bgMoveSpeed = 3f;

    private void Awake()
    {
        SoundControl.PlayBGM("Lobby");
        UIBase[] uiPop = GetComponentsInChildren<UIBase>();
        StarFade();
        Invoke("ShootingStar", shootingDuration);
        ShootingStar();
        //foreach (UIBase i in uiPop)
        //    i.Init();

        start = shootingStar.anchoredPosition;
        Vector2 temp = bgRectTransform.GetComponentInParent<CanvasScaler>().referenceResolution;
        Vector2 bgSize = bgRectTransform.rect.size;
        clampedX = Mathf.Abs((temp.x - bgSize.x) * 0.5f);
        clampedY = Mathf.Abs((temp.y - bgSize.y) * 0.5f);
        BgMove();
    }
    private void BgMove()
    {
        Vector2 temp = bgRectTransform.localPosition;
        switch(index)
        {
            case 0:
                temp.x = clampedX;
                //temp += Vector2.right * bgMoveSpeed * Time.deltaTime;
                break;
            case 1:
                temp.y = -clampedY;
                //temp += Vector2.down * bgMoveSpeed * Time.deltaTime;
                break;
            case 2:
                temp.x = -clampedX;
                //temp += Vector2.left * bgMoveSpeed * Time.deltaTime;
                break;
            case 3:
                temp.y = clampedY;
                //temp += Vector2.up * bgMoveSpeed * Time.deltaTime;
                break;
        }
        //temp.x = Mathf.Clamp(temp.x, -clampedX, clampedX);
        //temp.y = Mathf.Clamp(temp.y, -clampedY, clampedY);
        //bgRectTransform.anchoredPosition = temp;

        Tweener tweener = bgRectTransform.DOAnchorPos(temp, bgMoveSpeed).SetEase(Ease.Linear);

        tweener.OnComplete(() =>
        {
            index = index < 3 ? ++index : 0;
            BgMove();
        });
    }
    public void ESC()
    {
        //UIManager.instance.ESC();
    }
    public void MenuOn(int id)
    {
        
        switch((LobbyMenuBtn)id)
        {
            case LobbyMenuBtn.Charactor:
                //testUI.OnUI();
                break;
            case LobbyMenuBtn.Equip:
                break;
            case LobbyMenuBtn.Ship:
                break;
            case LobbyMenuBtn.BlackHall:
                break;
        }
    }
    public void GameStart()
    {
        GameData.m_curStage = TableControl.instance.m_stageTable.GetRecord(100001);
        GameData.m_totalKill = 0;
        SceneChanger.instance.ChangeScene();
    }
    private void StarFade()
    {
        bgStar[0].DOFade(0, starDuration).SetLoops(-1, LoopType.Yoyo);
        bgStar[1].DOFade(1, starDuration).SetLoops(-1, LoopType.Yoyo);
        bgStar[2].DOFade(0, starDuration).SetLoops(-1, LoopType.Yoyo).SetDelay(starDuration);
        bgStar[3].DOFade(1, starDuration).SetLoops(-1, LoopType.Yoyo).SetDelay(starDuration);
    }
    private void ShootingStar()
    {
        Tweener tweener = shootingStar.DOAnchorPos(endV.anchoredPosition, moveSpeed).SetEase(Ease.InOutSine);

        tweener.OnComplete(() => {
            shootingStar.DOAnchorPos(start, 0);
            Invoke("ShootingStar", shootingDuration);
        });
    }
}
