using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class LocalizeTexts : MonoBehaviour
{
    [Header("데이터 초기화가 완료되고 셋팅 여부")]
    public bool m_isDataLoad;
    public Text m_text;
    [Header("여러 텍스트 키를 조합하여 사용할때 쓴다")]
    public List<int> m_TextKeys;


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
        StringBuilder _builder = new StringBuilder();

        for(int i = 0; i < m_TextKeys.Count; i++)
        {
            _builder.Append(TableControl.instance.GetText(m_TextKeys[i]));
        }
        m_text.text = _builder.ToString();
    }
}
