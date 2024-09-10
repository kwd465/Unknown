using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using BH;

public class UIItem_ItemInfo : UIBase
{
    [SerializeField]
    private Image m_icon;
    [SerializeField]
    private TextMeshProUGUI m_tfCount;

    public virtual void Open(ItemTableData _data , int _count)
    {
        base.Open();

        SetIcon(m_icon, _data.icon);
        SetText(m_tfCount, "x"+_count.ToGoldText());
    }

}
