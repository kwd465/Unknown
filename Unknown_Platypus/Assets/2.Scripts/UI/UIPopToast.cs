using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIPopToast : UIPopup
{
    public Text tf_Desc;

    public virtual void Open(string _desc)
    {
        base.Open();
        SetText(tf_Desc, _desc);
    }




}
