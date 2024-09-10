using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillSlot : MonoBehaviour
{
    public Sprite skillSprite;
    public Text skillText;
    public Sprite[] skillClass;

    LevelUpUI panel;

    SkillType skillType;

    private void Awake()
    {
        var button = GetComponent<Button>();
        button.onClick.AddListener(OnClick);
    }

    public void Init(LevelUpUI panel, SkillType skillType) 
    {
        this.panel = panel;

        skillText.text = skillType.ToString();
        this.skillType = skillType;
    }


    void OnClick()
    {
        //GameManager.instance.LeanSkill(skillType);
        //GameManager.instance.isPause = false;
        //panel.OffUI();
    }



}
