using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BH
{
    public static class AlarmControl
    {

        public static char SEPERATOR = '/';

        public class AlarmData
        {
            public int count;
            public long time;
            public bool IsAlarm
            {
                get { return count != 0; }
            }

            public AlarmUI alarmUI;
        }

        private static Dictionary<string, AlarmData> _alarmDataDic = new Dictionary<string, AlarmData>();

        public static void Init()
        {
            CheckAlaram();
        }

        private static void CheckAlaram()
        {

        }

        public static void Dispose()
        {
            _alarmDataDic.Clear();
        }

        public static AlarmData GetAlarmData(string path)
        {
            _alarmDataDic.TryGetValue(path, out AlarmData alarmData);
            return alarmData;
        }
        public static bool IsAlarm(string path)
        {
            _alarmDataDic.TryGetValue(path, out AlarmData alarmData);
            if (alarmData == null)
                return false;

            return alarmData.IsAlarm;
        }


        /// <summary>
        /// path 에 해당하는 알람데이터의 정보를 전달된 값으로 설정한다. (기존 데이터 없을경우 생성)
        /// (기존 데이터가 있을경우 기존 count 와의 차이만큼 적용)
        /// </summary>
        /// <param name="path"></param>
        /// <param name="time"></param>
        /// <param name="count"></param>
        public static void SetAlarm(string path, long time, int count)
        {
            if (string.IsNullOrEmpty(path))
                return;

            // 이미 등록된 알람이 있을경우 count 증감 설정
            int deltaCount;
            _alarmDataDic.TryGetValue(path, out AlarmData fullPathAlarmData);
            if (fullPathAlarmData != null) {
                deltaCount = count - fullPathAlarmData.count;
            }
            else
            {
                deltaCount = count;
            } 

            string[] splitArray = path.Split(SEPERATOR);
            string currentPath = "";
            foreach (string splitPath in splitArray)
            {
                currentPath += splitPath;

                if (_alarmDataDic.TryGetValue(currentPath, out AlarmData alarmData) == false)
                {
                    alarmData = new AlarmData();
                    _alarmDataDic.Add(currentPath, alarmData);
                }

                alarmData.count += deltaCount;
                alarmData.time = time;
                alarmData.alarmUI?.SetAlarm(true);

                currentPath += "/";
            }
        }

        /// <summary>
        /// path 에 맞는 알람을 새로 등록한다 (이미 등록된 똑같은 path 는 무시된다)
        /// path 에 '/' 로 중간 단계의 알람을 등록 할 수 있다
        /// ex) "submenu/collection/RABBIT"
        /// 이 경우 submenu, submenu/collection, submenu/collection/RABBIT 총 3개의 알람이 등록된다
        /// </summary>
        /// <param name="path"></param>
        /// <param name="isPersistance">기본값은 true 이며 설정 시 해당 알람이 로컬 저장소에 저장되어 재 실행 시 자동 등록된다</param>
        public static void AddAlarm(string path, bool isPersistance = true)
        {
            if (string.IsNullOrEmpty(path))
                return;

            // 이전에 등록된 알람이 있고 count 가 0 이상인경우 무시
            if (_alarmDataDic.TryGetValue(path, out AlarmData registedAlarmData))
            {
                if (registedAlarmData.count > 0)
                    return;
            }

            //if (isPersistance)
            //    alarmProperty.setProperty(path, 0);

            string[] splitArray = path.Split(SEPERATOR);

            string currentPath = "";
            foreach (string splitPath in splitArray)
            {
                currentPath += splitPath;

                if (_alarmDataDic.TryGetValue(currentPath, out AlarmData alarmData) == false)
                {
                    alarmData = new AlarmData();
                    _alarmDataDic.Add(currentPath, alarmData);
                }

                alarmData.count++;
                alarmData.alarmUI?.SetAlarm(true);

                currentPath += "/";
            }
        }

        /// <summary>
        /// AddAlarm(string path) 함수와 동일하지만 time 값을 설정한다
        /// 타임값이 설정된 알람은 이전 타임과 비교하여 값이 더 크지 않을 경우 무시된다 (시간이 같아도 무시)
        /// </summary>
        /// <param name="path"></param>
        /// <param name="time"></param>
        public static void AddAlarm(string path, long time, bool isPersistance = false)
        {
            if (string.IsNullOrEmpty(path))
                return;

            _alarmDataDic.TryGetValue(path, out AlarmData fullPathAlarmData);
            if (fullPathAlarmData != null)
            {
                // 등록된 알람이 이미 알람상태인 경우 무시
                if (fullPathAlarmData.count > 0)
                    return;

                // 등록된 시간값이 같거나 과거 시간일 경우 무시
                if (fullPathAlarmData.time >= time)
                    return;
            }

            //if (isPersistance)
            //    alarmProperty.setProperty(path, time);

            string[] splitArray = path.Split(SEPERATOR);
            string currentPath = "";
            foreach(string splitPath in splitArray)
            {
                currentPath += splitPath;

                if (_alarmDataDic.TryGetValue(currentPath, out AlarmData alarmData) == false)
                {
                    alarmData = new AlarmData();
                    _alarmDataDic.Add(currentPath, alarmData);
                }

                // 무조건 증가되도록 수정 [상위에서 이미 켜진 알람은 무시하도록 적용]
                // 해당 path 로 처음 등록되는 경우에만 count 증가
                //if(fullPathAlarmData == null)
                //    alarmData.count++;

                alarmData.count++;
                alarmData.time = time;
                alarmData.alarmUI?.SetAlarm(true);

                currentPath += "/";
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="path"></param>
        /// <param name="time"></param>
        public static void ReadAlarm(string path, long time, bool isPersistance = false)
        {
            _alarmDataDic.TryGetValue(path, out AlarmData fullPathAlarmData);
            // 설정된 알람이 없거나, 시간값이 저장된 값보다 작을경우(시간이 같을경우는 통과), 또는 알람이 꺼져있는 경우 무시 
            if (fullPathAlarmData == null || fullPathAlarmData.time > time || fullPathAlarmData.count == 0)
                return;
            
            if (isPersistance)
            {
                // path 의 count 가 1 이하인 경우 지워질 알람이므로 alarmProperty 에 Remove() 적용
                //if (fullPathAlarmData.count <= 1)
                //    alarmProperty.Remove(path);
            }
                

            string[] splitArray = path.Split(SEPERATOR);
            string currentPath = "";
            foreach (string splitPath in splitArray)
            {
                currentPath += splitPath;
                if (_alarmDataDic.TryGetValue(currentPath, out AlarmData alarmData) == false)
                {
                    alarmData = new AlarmData();
                    _alarmDataDic.Add(currentPath, alarmData);
                }

#if DEBUG_LOG
                UnityEngine.Debug.Log("[AlarmControl] ReadAlarm() currentPath : " + currentPath + ", saved count : " + alarmData.count);
#endif

                alarmData.time = time;

                if (alarmData.count > 0)
                    alarmData.count--;

                if (alarmData.count == 0)
                    alarmData.alarmUI?.SetAlarm(false);

                currentPath += "/";
            }
        }

        public static void RemoveChildAlarm(string path)
        {
            string[] _checkArray = path.Split(SEPERATOR);

            foreach (var _data in _alarmDataDic)
            {
                if(_data.Key.Contains(path))
                {
                    RemoveAlarmInternal(_data.Key);
                }
            }

            RemoveAlarmInternal(path);
        }

        public static void RemoveAlarm(string path, bool isPersistance = false)
        {
            _alarmDataDic.TryGetValue(path, out AlarmData fullPathAlarmData);

            // 설정된 알람이 없거나 알람이 꺼져있는 경우 무시
            if (fullPathAlarmData == null || fullPathAlarmData.count == 0)
                return;

            //if(isPersistance)
            //    alarmProperty.Remove(path);

            string[] splitArray = path.Split(SEPERATOR);
            string currentPath = "";
            foreach (string splitPath in splitArray)
            {
                currentPath += splitPath;
                RemoveAlarmInternal(currentPath);

                currentPath += "/";
            }
        }
        private static void RemoveAlarmInternal(string path)
        {
            if (_alarmDataDic.TryGetValue(path, out AlarmData alarmData))
            {
                if(alarmData.count > 0)
                    alarmData.count--;

                if(alarmData.count == 0)
                    alarmData.alarmUI?.SetAlarm(false);
            }
        }


        ///////////////////
        ///  UI Regist  ///
        ///////////////////

        internal static void Regist(AlarmUI alarmUI)
        {
            if (_alarmDataDic.TryGetValue(alarmUI.Path, out AlarmData alarmData) == false)
            {
                alarmData = new AlarmData();
                _alarmDataDic.Add(alarmUI.Path, alarmData);
            }
            alarmData.alarmUI = alarmUI;

            if (alarmData.count > 0)
            {
                alarmUI.SetAlarm(true);
            }
            else
            {
                alarmUI.SetAlarm(false);
            }
        }

        internal static void Unregist(AlarmUI alarmUI)
        {
            if (_alarmDataDic.TryGetValue(alarmUI.Path, out AlarmData alarmData))
            {
                if (alarmData.alarmUI == alarmUI)
                {
                    alarmData.alarmUI = null;
                }
            }
        }
    }
}

