using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class LocalizeTexts : MonoBehaviour
{
    [Header("������ �ʱ�ȭ�� �Ϸ�ǰ� ���� ����")]
    public bool m_isDataLoad;
    public Text m_text;
    [Header("���� �ؽ�Ʈ Ű�� �����Ͽ� ����Ҷ� ����")]
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
