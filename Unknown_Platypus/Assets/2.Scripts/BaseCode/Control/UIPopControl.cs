using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BH
{
    public class UIPopControl : BHSingleton<UIPopControl>
    {
        Transform tr_NoticeAttach;
        Transform tr_CommonAttach;
        Transform tr_BattleAttach;

        RectTransform tr_battle;
        Canvas can_battle;

        private PoolUIGroup m_uiNoticePool;
        private PoolUIGroup m_uiCommonPool;
        private PoolUIBaseGroup m_uiBattlePool;
       
        private UIPopToast m_toast;

        public Transform TrNotice => tr_NoticeAttach;
        public Transform TrCommon => tr_CommonAttach;
        public Transform TrBattle => tr_BattleAttach;

        public override void Init()
        {
            isDonDestroy = false;
            base.Init();
            if (tr_NoticeAttach == null)
                tr_NoticeAttach = ResourceControl.instance.Create(UIDefine.CanvasNoticePath, this.transform).transform;
            if (tr_CommonAttach == null)
                tr_CommonAttach = ResourceControl.instance.Create(UIDefine.CanvasUICommonPath, this.transform).transform;
            if (tr_BattleAttach == null)
                tr_BattleAttach = ResourceControl.instance.Create(UIDefine.CanvasUIBattlePath, this.transform).transform;



            if (tr_battle == null)
                tr_battle = tr_BattleAttach.GetComponent<RectTransform>();
            if (can_battle == null)
                can_battle = tr_BattleAttach.GetComponent<Canvas>();

            m_uiNoticePool = new PoolUIGroup(tr_NoticeAttach);
            m_uiCommonPool = new PoolUIGroup(tr_CommonAttach);
            m_uiBattlePool = new PoolUIBaseGroup(tr_BattleAttach);
        }

        public override void UpdateLogic()
        {
            m_uiNoticePool.UpdateLogic();
            m_uiCommonPool.UpdateLogic();
            m_uiBattlePool.UpdateLogic();
        }

        public Vector2 ParseScreenPos(Vector3 _target)
        {
            var screenPos = Camera.main.WorldToScreenPoint(_target);
            return screenPos;
        }

        public Vector2 ParseScreenPosRndX(Vector3 _target)
        {
            var screenPos = Camera.main.WorldToScreenPoint(_target);
            return screenPos;
        }


        public UIBase GetOpenBUI(string _path)
        {
            int _resKey = _path.GetHashCode();
            if (m_uiBattlePool == null)
                Init();

            for (int i = 0; i < m_uiBattlePool.getActiveList.Count; i++)
            {
                if (m_uiBattlePool.getActiveList[i].resKey == _resKey)
                    return m_uiBattlePool.getActiveList[i].model;
            }

            return null;
        }

        public T GetOpenBUI<T>() where T : UIBase
        {
            System.Type _key = typeof(T);
            if (m_uiBattlePool == null)
                Init();

            for (int i = 0; i < m_uiBattlePool.getActiveList.Count; ++i)
            {
                if (m_uiBattlePool.getActiveList[i].model.GetType() == _key)
                    return m_uiBattlePool.getActiveList[i].model as T;
            }
            return null;
        }

        public void PoolingBUI(string _path , int _count)
        {
            for(int i = 0; i < _count; i++)
            {
                m_uiBattlePool.Get(_path).Close();
            }
        }


        public UIBase OpenBUI(string _path)
        {
            if (string.IsNullOrEmpty(_path))
                return null;
            if (m_uiBattlePool == null)
                Init();

            UIBase _popup = m_uiBattlePool.Get(_path);
            if (null == _popup)
                return null;

            _popup.Open();
            return _popup;
        }

        public UIPopup GetOpen(string _path)
        {
            int _resKey = _path.GetHashCode();
            if (m_uiCommonPool == null)
                Init();

            for (int i = 0; i <m_uiCommonPool.getActiveList.Count; i++)
            {
                if (m_uiCommonPool.getActiveList[i].resKey == _resKey)
                    return m_uiCommonPool.getActiveList[i].model;
            }

            return null;
        }

        public T GetOpenDlg<T>() where T : UIPopup
        {
            System.Type _key = typeof(T);
            if (m_uiCommonPool == null)
                Init();

            for (int i = 0; i < m_uiCommonPool.getActiveList.Count; ++i)
            {
                if (m_uiCommonPool.getActiveList[i].model.GetType() == _key)
                    return m_uiCommonPool.getActiveList[i].model as T;
            }

            return null;
        }

        public T Open<T>(string _path) where T : UIPopup
        {
            if (string.IsNullOrEmpty(_path))
                return null;
            if (m_uiCommonPool == null)
                Init();

            UIPopup _popup = m_uiCommonPool.Get(_path);
            if (null == _popup)
                return null;

            _popup.Open();
            return _popup as T;
        }

        public T NoneOpen<T>(string _path) where T : UIPopup
        {
            if (string.IsNullOrEmpty(_path))
                return null;
            if (m_uiCommonPool == null)
                Init();

            UIPopup _popup = m_uiCommonPool.Get(_path);
            if (null == _popup)
                return null;
            
            return _popup as T;
        }



        public UIPopup Open(string _path)
        {
            if (string.IsNullOrEmpty(_path))
                return null;
            if (m_uiCommonPool == null)
                Init();

            UIPopup _popup = m_uiCommonPool.Get(_path);
            if (null == _popup)
                return null;

            _popup.Open();
            return _popup;
        }


        public UIPopup GetNoticeOpen(string _path)
        {
            int _resKey = _path.GetHashCode();
            if (m_uiNoticePool == null)
                Init();

            for (int i = 0; i < m_uiNoticePool.getActiveList.Count; i++)
            {
                if (m_uiNoticePool.getActiveList[i].resKey == _resKey)
                    return m_uiNoticePool.getActiveList[i].model;
            }

            return null;
        }

        public T GetNoticeOpenDlg<T>() where T : UIPopup
        {
            if (m_uiNoticePool == null)
                Init();

            System.Type _key = typeof(T);
            for (int i = 0; i < m_uiNoticePool.getActiveList.Count; ++i)
            {
                if (m_uiNoticePool.getActiveList[i].model.GetType() == _key)
                    return m_uiNoticePool.getActiveList[i].model as T;
            }
            return null;
        }

        public UIPopup NoticeOpen(string _path)
        {
            if (string.IsNullOrEmpty(_path))
                return null;

            if (m_uiNoticePool == null)
                Init();

            UIPopup _popup = m_uiNoticePool.Get(_path);
            if (null == _popup)
            {
                Debug.LogError("[UIPopManager] m_uiNoticePool Null popup:" + _path);
                return null;
            }
            
            _popup.Open();
            return _popup;
        }


        public void AllClose()
        {
            for (int i = 0; i < m_uiCommonPool.getActiveList.Count; i++)
            {
                m_uiCommonPool.getActiveList[i].model.Close();
            }
            for (int i = 0; i < m_uiNoticePool.getActiveList.Count; i++)
            {
                m_uiNoticePool.getActiveList[i].model.Close();
            }
            for (int i = 0; i < m_uiBattlePool.getActiveList.Count; i++)
            {
                m_uiBattlePool.getActiveList[i].model.Close();
            }
        
        }

        
        public void ShowToast(string _desc)
        {
            //if(m_toast == null)
            //    m_toast = NoticeOpen(UIDefine.UIPopToast) as UIPopToast;
            
            //if(m_toast.gameObject.activeInHierarchy)
            //    m_toast.Close();

            UIPopToast _toast = NoticeOpen(UIDefine.UIPopToast) as UIPopToast;
            _toast.Open(_desc);
        }
 
        public void Update()
        {
            EscapeUpdate();
        }

        public void EscapeUpdate()
        {
            if (Input.GetKeyDown(KeyCode.Escape) == false)
                return;

            if(m_uiNoticePool != null && m_uiNoticePool.getActiveList.Count > 0)
            {
                m_uiNoticePool.getActiveList[m_uiNoticePool.getActiveList.Count - 1].model.OnClick_Close();
                return;
            }

            if(m_uiCommonPool != null && m_uiCommonPool.getActiveList.Count>0)
            {
                m_uiCommonPool.getActiveList[m_uiCommonPool.getActiveList.Count - 1].model.OnClick_Close();
            }    
        }

        public void ClearBattleUI()
        {
            m_uiBattlePool.Clear();
        }
    }
}