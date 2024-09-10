using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace BH
{
	public class BHSingletonBase : MonoBase
	{
		public bool isDonDestroy = true;
		public bool isInit = false;

		public virtual void Init() {
			if (isInit == true)
				return;

			if (isDonDestroy)
				DontDestroyOnLoad(this.gameObject);
			isInit = true;
		}

    }

	public class BHSingleton<T> : BHSingletonBase where T : BHSingletonBase
	{
		protected static T _instance;
		private static object _lock = new object();

		public static T instance
		{
			get
			{
				if (_instance == null)
				{
					GameObject obj;

					obj = GameObject.Find(typeof(T).Name);

					if (obj == null)
					{
						obj = new GameObject(typeof(T).Name);
						_instance = obj.AddComponent<T>();
					}
					else
						_instance = obj.GetComponent<T>();
				}

				return _instance;
			}
		}
	}
}


