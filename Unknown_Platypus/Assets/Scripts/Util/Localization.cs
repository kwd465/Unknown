
using UnityEngine;
using System.Collections;
using System.IO;
using System.IO.Compression;
using System.Collections.Generic;
using System.Text;
using UnityEngine.UI;

//----------------------------------------------------------------------------
// 기능 : 지역화 관련된 사항들 정의하는 클래스
//----------------------------------------------------------------------------
public class Localization
{
    public static string[] languageKey = { "ko", "en", "ja", "es", "zh_cn", 
                                    "zh_tw", "id", "fr", "th", "ru", 
                                    "vi", "tr", "it", "pt", "de"};
    
    public Dictionary<string, Dictionary<string, string>> LangData = null;
    public Dictionary<string, string> curLangData = null;

    private static Localization s_Instance;

    public SystemLanguage setLanguage { get; private set; }

    List<LocalizationTMPText> availableTMPTextList = new List<LocalizationTMPText>();

    public static Localization Singleton
    {
        get
        {
            if (null == s_Instance)
            {
                s_Instance = new Localization();
            }

            return s_Instance;
        }
    }


    public bool IsNotLoaded()
    {
        return LangData != null && LangData.Count != 0;
    }
    
    //----------------------------------------------------------------------------
    public void LoadLanguage(SystemLanguage setLanguage = SystemLanguage.English)
    {
        Load();

        string langKey = "";

        int langCode = SystemLanguageToLanguageCode(setLanguage);
        if (langCode == -1)
        {
            setLanguage = SystemLanguage.English;
            langCode = 1;
        }

        langKey = languageKey[langCode];        

        this.setLanguage = setLanguage;
        curLangData = LangData[langKey];        
    }    

    private void Load()
    {
        if (LangData == null)
        {
            LangData = new Dictionary<string, Dictionary<string, string>>();                        
        }
        LangData.Clear();

        foreach( var lan in languageKey)
        {
            var dic = new Dictionary<string, string>();
            LangData.Add(lan, dic);
        }
        
        //var table = (TableLocalization)Resources.Load<ScriptableObject>("Data/TableLocalization");

        //foreach( var data in table.dataList)
        //{
        //    LangData["ko"].Add(data.key, data.ko);
        //    LangData["en"].Add(data.key, data.en);
        //    LangData["ja"].Add(data.key, data.ja);
        //    LangData["es"].Add(data.key, data.es);
        //    LangData["zh_cn"].Add(data.key, data.zh_cn);
            
        //    LangData["zh_tw"].Add(data.key, data.zh_tw);
        //    LangData["id"].Add(data.key, data.id);
        //    LangData["fr"].Add(data.key, data.fr);
        //    LangData["th"].Add(data.key, data.th);
        //    LangData["ru"].Add(data.key, data.ru);

        //    LangData["vi"].Add(data.key, data.vi);
        //    LangData["tr"].Add(data.key, data.tr);
        //    LangData["it"].Add(data.key, data.it);
        //    LangData["pt"].Add(data.key, data.pt);
        //    LangData["de"].Add(data.key, data.de);
        //}
    }

    //----------------------------------------------------------------------------
    public static string getString(string key)
    {
        if (string.IsNullOrEmpty(key))
            return key;

        if (Singleton.LangData == null || Singleton.LangData.Count == 0)
        {            
            // String Data를 직접 로드하기 전에 getString이 호출되었다.
            // 아마도 게임 초기화 이전에 출력되는 글자들에 해당될 것이다.
            // 로컬에서 바로 읽어들일 확율이 높다
            Singleton.LoadLanguage(Application.systemLanguage);
        }
        
        string value = "";
        if (Singleton.curLangData.TryGetValue(key, out value))
        {
            return value;
        }
        else
        {
#if UNITY_EDITOR
            Debug.LogWarning("can't find string data for [" + key + "]");
#endif
            // 없으면 그냥 key값을 반환
            return key;

        }
    }

    public static string getStringFormat(string key, params object[] args)
    {
        var format = getString(key);

        if (args == null || args.Length <= 0)
            return format;

        return string.Format(format, args);
    }

    public static string GetString(string lang, string key)
    {
        Dictionary<string, string> langDic = null;
        if( Singleton.LangData.TryGetValue(lang, out langDic) )
        {
            string value = "";
            if(langDic.TryGetValue(key, out value))
            {
                return value;
            }
            else
            {
                return $"!{key}";
            }
        }
        else
        {
            return $"!{lang}_{key}";
        }        
    }

    public static SystemLanguage LanguageCodeToSystemLanguage(int langCode)
    {
        switch (languageKey[langCode])
        {
            case "ko": return SystemLanguage.Korean;
            case "en":  return SystemLanguage.English;            
            case "ja": return SystemLanguage.Japanese;
            case "es": return SystemLanguage.Spanish;
            case "zh_cn": return SystemLanguage.ChineseSimplified;

            case "zh_tw": return SystemLanguage.ChineseTraditional;
            case "id": return SystemLanguage.Indonesian;
            case "fr": return SystemLanguage.French;
            case "th": return SystemLanguage.Thai;
            case "ru": return SystemLanguage.Russian;

            case "vi": return SystemLanguage.Vietnamese;
            case "tr": return SystemLanguage.Turkish;
            case "it": return SystemLanguage.Italian;
            case "pt": return SystemLanguage.Portuguese;
            case "de": return SystemLanguage.Dutch;
        }

        return SystemLanguage.English;
    }

    public static int SystemLanguageToLanguageCode(SystemLanguage systemLanguage)
    {
        switch(systemLanguage)
        {            
            case SystemLanguage.Korean:     return 0;
            case SystemLanguage.English:    return 1;
            case SystemLanguage.Japanese:   return 2;
            case SystemLanguage.Spanish:    return 3;
            case SystemLanguage.ChineseSimplified:  return 4;

            case SystemLanguage.ChineseTraditional: return 5;
            case SystemLanguage.Indonesian: return 6;
            case SystemLanguage.French:     return 7;
            case SystemLanguage.Thai:       return 8;
            case SystemLanguage.Russian:    return 9;

            case SystemLanguage.Vietnamese: return 10;
            case SystemLanguage.Turkish:    return 11;
            case SystemLanguage.Italian:    return 12;
            case SystemLanguage.Portuguese: return 13;
            case SystemLanguage.Dutch:      return 14;
            default: return -1;
        }
    }


    public void AddTMPText( LocalizationTMPText tmptext )
    {
        availableTMPTextList.Add(tmptext);     
    }

    public void ReoveTMPText(LocalizationTMPText tmptext)
    {        
        availableTMPTextList.Remove(tmptext);
    }

    public void UpdateAvailableTMPText()
    {
        foreach(var item in availableTMPTextList)
        {
            Debug.Log($"UpdateAvailableTMPText {item.key}");
            item.SetText();
        }
    }
    
}
