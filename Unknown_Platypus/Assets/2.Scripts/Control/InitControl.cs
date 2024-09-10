
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace BH
{
    public class InitControl : BHSingleton<InitControl>
    {
        public override void Init()
        {

            Application.targetFrameRate = 60;

            try
            {
                //최초 실행시 언어 설정
                string rang = PlayerPrefs.GetString("Language", string.Empty);
                if(string.IsNullOrEmpty(rang))
                {
                    switch (Application.systemLanguage)
                    {
                        case SystemLanguage.Japanese:
                            PlayerPrefs.SetString("Language", "JP");
                            break;

                        case SystemLanguage.Korean:
                            PlayerPrefs.SetString("Language", "KR");
                            break;

                        default:
                            PlayerPrefs.SetString("Language", "EN");
                            break;
                    }
                }

                ResourceControl.instance.Init();
                TimeControl.instance.Init();
                TableControl.instance.Init();
                
            }catch(Exception e)
            {
                Debug.LogError(e.Message);
            }
        }
        
        public void Dispose()
        {
            
        }


        public void EndLogo(string NextSceneName)
        {
            Debug.Log(NextSceneName);
            SceneManager.LoadScene(NextSceneName);
        }
    }
}
