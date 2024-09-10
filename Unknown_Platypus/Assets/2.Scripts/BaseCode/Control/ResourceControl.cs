using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEngine.AddressableAssets;
using UnityEngine.U2D;

namespace BH
{
    public class ResourceControl : BHSingleton<ResourceControl>
    {
        //스프라이트 파일들 미리 로드 해놔도 될듯?

        Dictionary<string, Sprite> m_dicSprite = new Dictionary<string, Sprite>();

        //번들 받은 파일을 미리 로드 해서 가지고 있다가 추후에 삭제 하자
        public Dictionary<string, Object> m_dicData = new Dictionary<string, Object>();

        public void AddDicData(string _name , Object _obj)
        {
            if(m_dicData.ContainsKey(_name))
            {
#if DEBUG_LOG
                Debug.LogWarning("[ResourceControl] Already AddDicData :" + _name);
#endif
                return;
            }
#if DEBUG_LOG
            Debug.Log("[ResourceControl] AddDicData :" + _name);
#endif
            m_dicData.Add(_name, _obj);
        }


        public override void Init()
        {
            isDonDestroy = true;
            base.Init();
            SpriteAtlas[] atlas = Resources.LoadAll<SpriteAtlas>("Sprite");
            foreach(SpriteAtlas sprite in atlas)
            {
                Sprite[] sprites = new Sprite[sprite.spriteCount];
                sprite.GetSprites(sprites);

                foreach(Sprite var in sprites)
                {
                    string spriteName = var.name.Substring(0, var.name.Length - 7);

                    if (m_dicSprite.ContainsKey(spriteName) == false)
                        m_dicSprite.Add(spriteName, var);
                    else
                    {
#if DEBUG_LOG
                        Debug.Log("Already Key:" + spriteName);
#endif
                    }
                }
            }
        }

        public Sprite GetImage(string name)
        {
            if (m_dicSprite.ContainsKey(name) == false)
                return null;
            
            return m_dicSprite[name];
        }


        public T Load<T>(string path) where T : Object
        {
            if (null == path || 0 >= path.Length)
            {
#if DEBUG_LOG
                Debug.LogError("ResourceControl ::Load() [ null == _path ] : ");
#endif
                return null;
            }

            T data = null;

            if (m_dicData.ContainsKey(path))
            {
                m_dicData.TryGetValue(path, out Object _obj);
                
                if(_obj !=null)
                {
#if DEBUG_LOG
                    Debug.Log("[ResourceControl] Load PatchFile:" + path);
#endif
                    data = _obj as T;
                    return data;
                }
            }

            data = Resources.Load<T>(path);

            if(null == data)
            {
#if DEBUG_LOG
                Debug.LogWarning("[ResourceControl] LoadFail :" + path);
#endif
                return null;
            }
            return data;
        }

        public GameObject Create(string _path, Transform parent = null)
        {
            GameObject _res = Load<GameObject>(_path);
            if (null == _res)
                return null;

            GameObject _obj = Instantiate<GameObject>(_res);
            _obj.name = _obj.name.Replace("(clone)", "");
            SetAttach(_obj.transform, parent);

            return _obj;
        }

        public T Create<T>(string path , Transform parent = null) where T : Component
        {
            GameObject _res = Load<GameObject>(path);
            if (_res == null)
                return null;

            GameObject _obj = Instantiate<GameObject>(_res);
            SetAttach(_obj.transform, parent);
            T _comp = _obj.GetComponent<T>();
            return _comp;
        }

        public GameObject CreateStretch(string _path, Transform _parent, bool _isStretch)
        {
            GameObject _obj = Create(_path, _parent);
            if (null == _obj)
                return null;

            if (true == _isStretch)
                _obj.GetComponent<RectTransform>().sizeDelta = Vector2.zero;

            return _obj;
        }

        public T CreateUI<T>(string _path, Transform _parent, bool _isStretch = false) where T : Component
        {
            GameObject _obj = Create(_path, _parent);
            if (null == _obj)
                return null;

            if (true == _isStretch)
                _obj.GetComponent<RectTransform>().sizeDelta = Vector2.zero;

            T _classType = _obj.GetComponent<T>();
            if (null == _classType)
            {
                Debug.LogError("error GetComponent() : " + typeof(T).ToString() + " : Path : " + _path);
                
                Destroy(_obj);
                return null;
            }

            return _classType;
        }

        public void SetAttach(Transform _self, Transform _parent)
        {
            if (null == _parent)
                return;

            _self.transform.SetParent(_parent);
            _self.transform.localPosition = Vector3.zero;
            _self.transform.localRotation = Quaternion.identity;
            _self.transform.localScale = Vector3.one;
        }

        public void SetLayer(Transform _trn, int _layer)
        {
            _trn.gameObject.layer = _layer;

            for (int i = 0; i < _trn.childCount; ++i)
            {
                SetLayer(_trn.GetChild(i), _layer);
            }
        }
        public Transform FindName(Transform _trn, string _name)
        {
            if (_trn.name == _name)
                return _trn;

            for (int i = 0; i < _trn.childCount; ++i)
            {
                Transform child = FindName(_trn.GetChild(i), _name);

                if (child != null)
                    return child;
            }

            return null;
        }

        public T Load_Editor<T>(string _path) where T : Object
        {
            if (null == _path || 0 >= _path.Length)
            {
                Debug.LogError("ResUtil::Load() [ null == _path ] : ");
                return null;
            }

            T temp = Resources.Load<T>(_path);
            if (null == temp)
            {
                Debug.LogError("ResUtil::Load() [load failed] :" + _path);
                return null;
            }

            return temp;
        }
    }
}
