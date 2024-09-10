using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

public class EffectManager : BHSingleton<EffectManager>
{
    PoolObjectGroup<Effect> m_pool;
    private string m_path = "Prefabs/Effect/";


    private void Awake()
    {
        m_pool = new PoolObjectGroup<Effect>(transform);
    }

    public Effect Play(string _path, Vector3 _pos, Quaternion _rot, float _size = 1f, bool _loop = false)
    {
        Effect _find = m_pool.Get(m_path+_path);
        if (null == _find)
            return null;

        _find.Play(_pos, _rot, _size);
        return _find;
    }

    public Effect Play(string _path, Transform _parent, float _size = 1f, bool _loop = false)
    {
        Effect _find = m_pool.Get(m_path+_path);
        if (null == _find)
        {
            Debug.LogError("Not Found Effect: " + _path);
            return null;
        }
        _find.Play(_parent, _size);
        return _find;
    }

    public void Clear()
    {
        if (null != m_pool)
        {
            m_pool.Close();
            m_pool.Clear();
        }
    }

    public override void UpdateLogic()
    {
        if (null != m_pool)
            m_pool.UpdateLogic();
    }    

    public void SetSpeed(float _speed)
    {
        for (int i = 0; i < m_pool.getActiveList.Count; ++i)
        {
            var _var = m_pool.getActiveList[i];
            if (null == _var.model)
                continue;

            _var.model.SetSpeed(_speed);
        }
    }
}
