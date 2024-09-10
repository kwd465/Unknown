using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using BH;

public class TitleUIManager : Singleton<TitleUIManager>
{
    public Text touch;
    //public Text title;
    public Button touchBtn;

    private bool isTableData = false;
    private Scene scene = Scene.Title;


    protected override void Awake()
    {
        base.Awake();
        touchBtn.interactable = false;
        touch.gameObject.SetActive(false);
    }

    private void Start()
    {
        Invoke("Init", 0.5f);
    }

    private void Init()
    {
        Sequence seq = DOTween.Sequence();
        seq.Play().OnComplete(() => { });
        //title.DOText(titleName, titleName.Length * 0.1f).SetEase(Ease.Linear);

        TableDataComplete();
    }

    private void Update()
    {
        
    }

    public void TableDataComplete()
    {
        //var tableManager = TableManager.Instance;

        InitControl.instance.Init();

        isTableData = true;
        touchBtn.interactable = true;
        touch.gameObject.SetActive(true);
        touch.DOFade(0, 2).SetEase(Ease.InOutSine).SetLoops(-1, LoopType.Yoyo);
    }

    public void TouchSceneChange()
    {
        if (!isTableData)
            return;

        SceneChanger.instance.ChangeScene();
    }
}
