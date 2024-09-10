using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolUIGroup : PoolObjectGroup<UIPopup>
{
    public PoolUIGroup(Transform _attach) : base(_attach)
    {
    }

    public override UIPopup Get(string _path, AddComponentAction _addComponentAction = null)
    {
        PoolObject<UIPopup> _pool = GetPoolObject(_path, _addComponentAction);
        if (_pool == null)
            return null;
        return _pool.model;
    }
}
