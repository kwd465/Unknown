using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    public static T instance;

    protected virtual void Awake()
    {
        if (instance == null)
            instance = this as T;
        else
            Destroy(this.gameObject);
    }
}
public class WithSingleton<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T _instance;
    public static T instance
    {
        get
        {
            if(_instance == null)
            {
                if(!FindSingleton<T>(out _instance))
                    _instance = new GameObject(typeof(T).Name).AddComponent<T>();
            }
            return _instance;
        }
    }
    
    public static bool FindSingleton<T>(out T singleton) where T : MonoBehaviour
    {
        singleton = FindObjectOfType<T>();
        return singleton ? true : false;
    }
}
public class ManagerWithSingleton<T,T1> : MonoBehaviour where T : MonoBehaviour where T1 : MonoBehaviour
{
    private static T _instance;
    private static T1 manager;
    public static T instance
    {
        get
        {
            if (_instance == null)
            {
                if (!FindSingleton<T>(out _instance))
                {
                    _instance = new GameObject(typeof(T).Name).AddComponent<T>();
                    manager = new GameObject(typeof(T1).Name).AddComponent<T1>();
                }
            }
            return _instance;
        }
    }
    public static bool FindSingleton<T>(out T singleton) where T : MonoBehaviour
    {
        singleton = FindObjectOfType<T>();
        return singleton ? true : false;
    }
}
public class DonSingleton<T> : MonoBehaviour where T : MonoBehaviour
{
    public static T instance;

    protected virtual void Awake()
    {
        if (instance == null)
        {
            instance = this as T;
            DontDestroyOnLoad(this);
        }
        else
            Destroy(this.gameObject);
    }
}
