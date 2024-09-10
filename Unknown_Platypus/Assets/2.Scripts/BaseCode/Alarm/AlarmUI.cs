using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

namespace BH
{
    public class AlarmUI : UIBase
    {
        public bool isAlarm;
        public bool autoRegist;

        [SerializeField]
        private string _path;
        public string Path {
            get { return _path; }
        }

        public GameObject alarmGO;
        private GameObject _go;
        private bool _isRegisted;

        public void Awake()
        {
            _go = gameObject;
            alarmGO.SetActive(false);
        }
        public void OnEnable()
        {
            // 자동 등록 처리
            if (autoRegist)
            {
                if (string.IsNullOrEmpty(_path))
                {
#if DEBUG_LOG
                    UnityEngine.Debug.LogError("[MAlarmUI] Awake() path is null");
#endif
                    return;
                }

                SetData(_path);
            }
        }
        public void OnDisable()
        {
            alarmGO.SetActive(false);

            if (_isRegisted)
                AlarmControl.Unregist(this);
            _isRegisted = false;
        }


        /// <summary>
        /// path 에 해당하는 값으로 AlarmControl 에 Regist 한다
        /// path == null 일 경우 Unregist 한다
        /// </summary>
        /// <param name="path"></param>
        public void SetData(string path = null)
        {
            this._path = path;

            if (string.IsNullOrEmpty(path))
            {
                SetAlarm(false);
            }
            else
            {
                AlarmControl.Regist(this);
                _isRegisted = true;
            }
        }


        public void SetAlarm(bool isAlarm)
        {
#if DEBUG_LOG
            UnityEngine.Debug.Log("[MAlarmUI] SetAlarm() path : " + _path + ", isAlarm : " + isAlarm);
#endif

            this.isAlarm = isAlarm;

            // GameObject 가 비활성화 되어있을경우 무시
            if (_go.activeInHierarchy == false)
                return;

            
            if (this.isAlarm)
            {
                if(alarmGO.activeSelf == false)
                {
                    alarmGO.SetActive(true);
                }
            }
            else
            {
                if (alarmGO.activeSelf)
                {
                    alarmGO.SetActive(false);
                }
            }
        }
    }
}

