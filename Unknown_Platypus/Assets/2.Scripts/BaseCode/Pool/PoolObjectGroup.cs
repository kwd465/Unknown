using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PoolObjectGroup<T> where T : MonoBase
{
    public delegate T AddComponentAction(GameObject _obj);
    protected List<PoolObject<T>> m_activeList = new List<PoolObject<T>>();
    protected List<PoolObject<T>> m_hideList = new List<PoolObject<T>>();
    protected Transform m_attach;
    protected int m_maxCount = 50;


    public PoolObjectGroup( Transform _attach )
    {      
        m_attach = _attach;
    }

    public void SetMaxCount( int _count)
    {
        m_maxCount = _count;
    }

	public List<PoolObject<T>> getActiveList
    {
		get
        {
			return m_activeList;
		}
	}

    public List<PoolObject<T>> getHideList
    {
        get
        {
            return m_hideList;
        }
    }


    public void Clear()
    {
        for( int i=0;i< m_attach.childCount; ++i )
        {
            Transform _trs = m_attach.GetChild(i);
            _trs.DOKill();
            GameObject.Destroy(_trs.gameObject);
        }

        m_hideList.Clear();
        m_activeList.Clear();
    }

    public void Close()
    {
        for( int i=0; i< m_activeList.Count; ++i )
        {
            m_activeList[i].model.Close();
            m_hideList.Add(m_activeList[i]);
        }
        m_activeList.Clear();
    }

    public PoolObject<T> GetPoolObject(string _path, AddComponentAction _addComponentAction)
    {
        int _resKey = _path.GetHashCode();
        PoolObject<T> _pool = m_hideList.Find(delegate (PoolObject<T> _poolObject)
        {
            return _poolObject.resKey == _resKey;
        });

        if (null == _pool)
        {
            GameObject _obj = BH.ResourceControl.instance.Create(_path, m_attach);
            if (null == _obj)
                return null;

            T _content = _obj.GetComponent<T>();
            if (null == _content)
            {
                if (null != _addComponentAction)
                {
                    _content = _addComponentAction(_obj);
                }
                else
                {
                    _content = _obj.AddComponent<T>();
                }
            }

            _pool = new PoolObject<T>(_resKey, _content);
            m_activeList.Add(_pool);
        }
        else
        {
            m_hideList.Remove(_pool);
            m_activeList.Add(_pool);
        }

        return _pool;
    }

    public virtual T Get(string _path, AddComponentAction _addComponentAction = null)
    {
        PoolObject<T> _pool = GetPoolObject(_path, _addComponentAction );
        if (null == _pool)
            return null;

        _pool.model.Open();
        return _pool.model;
    }

    public void UpdateLogic()
    {
        int _index = 0;
        while( m_activeList.Count > _index )
        {
            PoolObject<T> _pool = m_activeList[_index];
            if( null == _pool.model )
            {
                m_activeList.Remove(_pool);
                continue;
            }
            
            if (_pool.model.isOpen == false)
            {
                m_activeList.Remove(_pool);                
                if ( m_maxCount <= m_hideList.Count )
                {
                    GameObject.Destroy(_pool.model.gameObject);
                    _pool = null;
                }
                else
                {
                    _pool.model.transform.SetParent(m_attach);
                    m_hideList.Add(_pool);
                }          
                continue;
            }

            _pool.model.UpdateLogic();
            ++_index;
        }
    }
}
