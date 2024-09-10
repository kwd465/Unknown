using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;


[RequireComponent(typeof(TextMeshProUGUI))]
public class LocalizationTMPText : MonoBehaviour
{
    public string key;
    TextMeshProUGUI textLabel;

    private void Awake()
    {
        textLabel = GetComponent<TextMeshProUGUI>();
    }

    private void OnEnable()
    {
        Localization.Singleton.AddTMPText(this);
        SetText();
    }

    private void OnDisable()
    {
        Localization.Singleton.ReoveTMPText(this);
    }

    public void SetText()
    {
        textLabel.text = Localization.getString(key);
    }
}
