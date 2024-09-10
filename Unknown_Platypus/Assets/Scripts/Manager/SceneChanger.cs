using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SceneChanger : DonSingleton<SceneChanger>
{
    public Image sceneAni;
    public Canvas loadingCanvas;
    private Scene scene = Scene.Title;
    private void Start()
    {
        DontDestroyOnLoad(loadingCanvas.gameObject);
    }
    public void ChangeScene()
    {
        if(scene == Scene.Game)
            --scene;
        else
            ++scene;

        StartCoroutine(FadeIn((int)scene));
    }
    IEnumerator FadeIn(int id)
    {
        loadingCanvas.sortingOrder = 500;
        loadingCanvas.gameObject.SetActive(true);
        float timer = 0f;
        Color color = sceneAni.color;
        while(timer < 1)
        {
            timer += Time.deltaTime;
            sceneAni.color = Color.Lerp(color, new Color(color.r,color.g,color.b,1), timer);
            yield return null;
        }
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(id);
        while(!asyncLoad.isDone)
        {
            float progress = Mathf.Clamp01(asyncLoad.progress / 0.9f);
            yield return null;
        }
        color = sceneAni.color;
        timer = 0;
        yield return new WaitForSeconds(1f);
        while (timer < 1)
        {
            timer += Time.deltaTime;
            sceneAni.color = Color.Lerp(color, new Color(color.r, color.g, color.b, 0), timer/3f);
            yield return null;
        }
        loadingCanvas.sortingOrder = 0;
        loadingCanvas.gameObject.SetActive(false);
        yield break;
    }
}
