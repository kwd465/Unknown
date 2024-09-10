
using System;
using System.Collections;
using System.Globalization;
using System.Net;
using BH;
using UnityEngine;

public class TimeControl : BHSingleton<TimeControl>
{

    DateTime m_ServerTime;
    float m_startTime;

    public Action UpdateHandler;
    public Action UpdateHourHandler;
    public Action UpdateDayHandler;

    private Coroutine m_curCorutine;

    private DateTime m_unixDateTime = new DateTime(1970, 1, 1, 0, 0, 0, System.DateTimeKind.Utc);

    private WaitForSecondsRealtime m_waitForSecond = new WaitForSecondsRealtime(1f);

    private int m_curSecond = 0;

    private string m_curDay;

    private float m_StartTime;
    private int m_lastHour;

    public override void Init()
    {
        base.Init();
        m_startTime = 0;
        m_curSecond = 0;
        m_lastHour = 0;
        m_StartTime = 0;
    }

    private void CheatDetected()
    {

    }


    //Second Check Update Event
    public void AddSecondEvent(Action _event)
    {
        UpdateHandler += _event;
    }

    public void RemoveSecondEvent(Action _event)
    {
        UpdateHandler -= _event;
    }

    public void SetTime()
    {


        try
        {
            //WebRequest 객체로 구글사이트 접속 해당 날짜와 시간을 로컬 형태의 포맷으로 리턴 일자에 담는다.
            using (var response = WebRequest.Create("http://www.google.com").GetResponse())
            {
                m_ServerTime = DateTime.ParseExact(response.Headers["date"],
                    "ddd, dd MMM yyyy HH:mm:ss 'GMT'",
                    CultureInfo.InvariantCulture.DateTimeFormat,
                    DateTimeStyles.AssumeUniversal);
#if DEBUG_LOG
                Debug.Log("[TimeControl] Now Server Time:" + m_ServerTime);
#endif
            }
        }
        catch (Exception)
        {
            //오류 발생시 로컬 날짜그대로 리턴
            m_ServerTime = DateTime.UtcNow.AddHours(9);
        }


        m_startTime = Time.realtimeSinceStartup;

        if (m_curCorutine != null)
            StopCoroutine(m_curCorutine);

        m_curCorutine = StartCoroutine(SecondHandler());
        m_curDay = DailyID();
    }

    IEnumerator SecondHandler()
    {
        while (true)
        {
            yield return m_waitForSecond;
            m_curSecond += 1;
            m_StartTime += 1;
            UpdateHandler?.Invoke();

            if (m_curSecond == 30)
            {
                if(m_curDay.Equals(DailyID())== false)
                {
                    UpdateDayHandler?.Invoke();
                    m_curDay = DailyID();
                }

                m_curSecond = 0;
            }

            string rang = PlayerPrefs.GetString("Language", "EN");

            if (rang.Equals("KR"))
            {
                if (m_StartTime == 3600)
                {
                    m_StartTime = 0;
                    m_lastHour += 1;
                }
            }
        }
    }

    public DateTime GetNowTime()
    {
        float lastTIme = Time.realtimeSinceStartup - m_startTime;

        if(lastTIme < 0)
        {
            SetTime();
            lastTIme = Time.realtimeSinceStartup - m_startTime;
        }

        DateTime _nowTime = m_ServerTime.AddSeconds(lastTIme);
        return _nowTime;
    }

    //해당 연도월일을 가져온다
    public string DailyID()
    {
        return GetNowTime().ToString("yyyyMMdd");
    }

    //해당 연도월을 가져온다
    public string MonthID()
    {
        return GetNowTime().ToString("yyyyMM");
    }
    

    //해당주의 월요일을 가져온다
    public string WeekMonID()
    {
        DateTime dateToday = GetNowTime();
        if (dateToday.DayOfWeek == DayOfWeek.Sunday)
            dateToday = dateToday.AddDays(-1);

        DateTime mondayDate = dateToday.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(dateToday.DayOfWeek));
        return mondayDate.ToString("yyyyMMdd", new CultureInfo("ko-KR"));
    }

    //지난주의 월요일을 가져온다
    public string LastWeekMonID()
    {
        DateTime dateToday = GetNowTime().AddDays(-7);
        if(dateToday.DayOfWeek == DayOfWeek.Sunday)
            dateToday = dateToday.AddDays(-1);

        DateTime mondayDate = dateToday.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(dateToday.DayOfWeek));
        return mondayDate.ToString("yyyyMMdd", new CultureInfo("ko-KR"));
    }

    public double UnixTimeNow()
    {
        var timeSpan = (GetNowTime() - m_unixDateTime);
        return timeSpan.TotalMilliseconds;
    }

    public double UnixTimeADDMin(int _min)
    {
        DateTime _curTime = GetNowTime().AddMinutes(_min);
        var timeSpan = _curTime - m_unixDateTime;
        return timeSpan.TotalMilliseconds;
    }

    public DateTime ConvertToDateTime(double _unixTime)
    {
        System.DateTime dtDateTime = m_unixDateTime;
        dtDateTime = dtDateTime.AddMilliseconds(_unixTime).ToUniversalTime();
        return dtDateTime;
    }

    public double ConvertToUnixTime(string _time)
    {
        return ConvertToUnixTime(_time.ToDateTime());
    }


    public double ConvertToUnixTime(DateTime _time)
    {
        var timeSpan = _time - m_unixDateTime;
        return timeSpan.TotalMilliseconds;
    }

    public bool isActiveTime(string _start, string _end)
    {
        DateTime _startTime = _start.ToDateTime();
        DateTime _endTime = _end.ToDateTime();

        return isActiveTime(_startTime, _endTime);
    }


    public bool isActiveTime(DateTime _start , DateTime _end)
    {
        DateTime _curTime = GetNowTime();

        if (m_unixDateTime == _curTime)
            return true;

        if (_curTime <= _start || _curTime > _end)
            return false;

        return true;
    }

    public string TimeCodeFormat(double _millisecond)
    {
        double tempTime = Math.Truncate(_millisecond / 1000);
        double hour = Math.Truncate(tempTime / 3600);
        double minute = Math.Truncate(tempTime % 3600 / 60);
        double seconds = tempTime % 3600 % 60;
        return string.Format("{0:00}:{1:00}:{2:00}" , hour , minute,seconds);

    }

}
