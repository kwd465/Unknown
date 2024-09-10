using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LocalizeText : MonoBehaviour
{
    [Header("데이터 초기화가 완료되고 셋팅 여부")]
    public bool m_isDataLoad;
    public Text m_text;
    public int m_TextKey;


    private void Awake()
    {
        if (GetComponent<Text>() != null)
            m_text = GetComponent<Text>();

        if (m_isDataLoad)
            TableControl.instance._endLoadEvent += Refresh;
    }

    private void OnEnable()
    {
        Refresh();
    }

    public void Refresh()
    {
        if (m_TextKey == 0 || m_text == null)
            return;
            
        m_text.text = TableControl.instance.GetText(m_TextKey);
    }

}
