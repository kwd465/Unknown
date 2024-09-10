using BH;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MonoBase : MonoBehaviour
{
    public virtual bool isOpen
    {
        get
        {
            if (gameObject == null)
                return false;

            return gameObject.activeSelf;
        }
    }

    public virtual void Open()
    {
        gameObject.SetActive(true);
    }

    public virtual void Close()
    {
        gameObject.SetActive(false);
        
    }

    public virtual void UpdateLogic()
    {
    }
}
