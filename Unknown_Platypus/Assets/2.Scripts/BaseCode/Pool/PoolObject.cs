using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolObject<T> where T : MonoBase
{    
    public int resKey;    
    public T model;  

    public PoolObject(int _resKey, T _model)
    {
        resKey = _resKey;
        model = _model;     
    }
    public void Open()
    {
        if (null == model)
        {
            Debug.LogError("PoolObject::Open()[null == model]");
            return;
        }
        model.Open();
    }
}
