using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolUIBaseGroup : PoolObjectGroup<UIBase>
{
    public PoolUIBaseGroup(Transform _attach) : base(_attach)
    {
    }

    public override UIBase Get(string _path, AddComponentAction _addComponentAction = null)
    {
        PoolObject<UIBase> _pool = GetPoolObject(_path, _addComponentAction);
        if (_pool == null)
            return null;
        return _pool.model;
    }
}
