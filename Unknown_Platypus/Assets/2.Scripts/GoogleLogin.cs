using Google;
using System.Collections.Generic;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;

public class GoogleLogin : MonoBehaviour
{
    private string web_client_id = "491876363766-j0mc1jtooft88k2ev9078s7ko5oi08iv.apps.googleusercontent.com";
    [SerializeField] TMP_Text testText;

    private void Awake()
    {
        Init();
    }

    private void Init()
    {
        GoogleSignIn.Configuration = new GoogleSignInConfiguration
        {
            WebClientId = web_client_id,
            UseGameSignIn = false,
            RequestEmail = true,
            RequestIdToken = true
        };
    }

    public void SignIn()
    {
        Debug.Log("Calling SignIn");
        testText.text = "Calling SignIn";
        GoogleSignIn.DefaultInstance.SignIn().ContinueWith(
          OnAuthenticationFinished);
    }

    internal void OnAuthenticationFinished(Task<GoogleSignInUser> task)
    {
        Debug.Log("Authentication finished, processing on main thread");
        MainThreadDispatcher.RunOnMainThread(() => ProcessAuthResult(task));
    }

    private void ProcessAuthResult(Task<GoogleSignInUser> task)
    {
        Debug.Log("Auth Result");
        if (task.IsFaulted)
        {
            using (IEnumerator<System.Exception> enumerator = task.Exception.InnerExceptions.GetEnumerator())
            {
                if (enumerator.MoveNext())
                {
                    GoogleSignIn.SignInException error = (GoogleSignIn.SignInException)enumerator.Current;
                    
                    Debug.Log("Got Error: " + error.Status + " " + error.Message);
                }
                else
                {
                    testText.text = @$"Calling SignIn {task.Exception}";
                    
                    Debug.Log("Got Unexpected Exception?!?" + task.Exception);
                }
            }
        }
        else if (task.IsCanceled)
        {
            testText.text = @$"canceled";
            Debug.Log("Canceled");
        }
        else
        {
            testText.text = @$"{task.Result.DisplayName} 
{task.Result.Email}
{task.Result.IdToken}";
            
            Debug.Log("Welcome: " + task.Result.DisplayName + "!");
            Debug.Log(task.Result.Email + "!");
            Debug.Log(task.Result.IdToken + "!");
        }
    }
}
