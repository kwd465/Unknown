using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UISkillButton : MonoBehaviour
{
    Button button;
    Image icon;

    Skill skill;



    private void Awake()
    {
        button = GetComponent<Button>();
        icon = transform.Find("icon").GetComponent<Image>();

        button.onClick.AddListener(OnClickButton);
    }

    void OnClickButton()
    {
        Debug.Log("OnClickButton");
        SkillManager.instance.UseSkill(skill);
    }

    public void SetSkill(Skill skill)
    {
        this.skill = skill;

        //icon.sprite = 

    }

    public void UpdateCool(float rate)
    {
        icon.fillAmount = rate;
    }

    public void SetReady()
    {
        button.interactable = true;
        icon.color = new Color(1, 1, 1);
    }

    public void SetLock()
    {
        button.interactable = false;
        icon.color = new Color(0.5f, 0.5f, 0.5f);
    }

}
