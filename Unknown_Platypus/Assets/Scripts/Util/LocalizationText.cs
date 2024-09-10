using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


[RequireComponent(typeof(Text))]
public class LocalizationText : MonoBehaviour
{
    public string key;

    Text txtLabel;    

    private void Awake()
    {
        txtLabel = GetComponent<Text>();        
    }

    private void OnEnable()
    {
        txtLabel.text = Localization.getString(key);
    }

}
