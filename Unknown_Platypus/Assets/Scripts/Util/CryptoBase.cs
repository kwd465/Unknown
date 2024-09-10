using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Xml.Schema;
using Unity.VisualScripting;
using UnityEngine;




public class CryptoPlayerPrefs
{
    public static void SetString(string _key, string _value)
    {       
        MD5 md5Hash = MD5.Create();
        byte[] hashData = md5Hash.ComputeHash(System.Text.Encoding.UTF8.GetBytes(_key));
        string hashKey = System.Text.Encoding.UTF8.GetString(hashData);

        byte[] bytes = System.Text.Encoding.UTF8.GetBytes(_value);

        ICryptoTransform xform = CryptoBase.Instance.DES.CreateEncryptor();                
        byte[] encrypted = xform.TransformFinalBlock(bytes, 0, bytes.Length);

        string encryptedString = Convert.ToBase64String(encrypted);

        PlayerPrefs.SetString(hashKey, encryptedString);

#if UNITY_EDTOR
        Debug.Log($"SetString hashKey: {hashKey} Encrypted Data: {encryptedString}");
#endif
    }


    public static string GetString(string _key, string defaultValue="")
    {
        MD5 md5Hash = MD5.Create();
        byte[] hashData = md5Hash.ComputeHash(System.Text.Encoding.UTF8.GetBytes(_key));
        string hashKey = System.Text.Encoding.UTF8.GetString(hashData);

        string _value = PlayerPrefs.GetString(hashKey);
        if (string.IsNullOrEmpty(_value))
            return defaultValue;

        byte[] bytes = Convert.FromBase64String(_value);        

        ICryptoTransform xform = CryptoBase.Instance.DES.CreateDecryptor();
        byte[] decrypted = xform.TransformFinalBlock(bytes, 0, bytes.Length);

        string decryptedString = System.Text.Encoding.UTF8.GetString(decrypted);

#if UNITY_EDTOR
        Debug.Log($"GetString hashKey: {hashKey} GetData:{_value} Decrypted Data:{decryptedString}");
#endif

        return decryptedString;
    }

}

public class CryptoValue<T> where T : IComparable
{
    string encryptData = string.Empty;
    T data;

    public void Set(T value)
    {        
        encryptData = Encrypt(value.ToString());
        data = value;

#if UNITY_EDTOR
        Debug.Log($"Set original:{data} encryptData:{encryptData}");
#endif
    }

    public T Get()
    {
        if (encryptData.Length == 0)
            return data;

        T temp = (T)Convert.ChangeType(Decrypt(encryptData), typeof(T));        
        if(temp.CompareTo(data)!=0)
        {
            data = temp;
        }

        return temp;
    }

    string Encrypt(string _value)
    {
        byte[] bytes = System.Text.Encoding.UTF8.GetBytes(_value);

        ICryptoTransform xform = CryptoBase.Instance.DES.CreateEncryptor();
        byte[] encrypted = xform.TransformFinalBlock(bytes, 0, bytes.Length);

        return Convert.ToBase64String(encrypted);
    }

    string Decrypt(string _value)
    {
        byte[] bytes = Convert.FromBase64String(_value);

        ICryptoTransform xform = CryptoBase.Instance.DES.CreateDecryptor();
        byte[] decrypted = xform.TransformFinalBlock(bytes, 0, bytes.Length);

        return System.Text.Encoding.UTF8.GetString(decrypted);
    }
}

public class CryptoBase
{
    string baseSecret = "!#$@$#!!^$$#&^%*";
    byte[] secret;

    TripleDES des = new TripleDESCryptoServiceProvider();

    static CryptoBase instance;
    public static CryptoBase Instance
    {
        get
        {
            if(instance == null)
            {
                instance = new CryptoBase();
            }
            return instance;
        }
    }

    CryptoBase()
    {
        MD5 md5Hash = new MD5CryptoServiceProvider();
        secret = md5Hash.ComputeHash(System.Text.Encoding.UTF8.GetBytes(baseSecret));
        //Debug.Log($"Construct secret {secret}");

        des.Key = secret;
        des.Mode = CipherMode.ECB;
    }

    public byte[] Key
    {
        get
        {
            return secret;
        }
    }

    public TripleDES DES
    {
        get
        {
            return des;
        }
    }
}


public class ObscureInt
{
    public CryptoValue<int> Data
    {
        get;set;
    }

    public ObscureInt(int data)
    {
        Data = new CryptoValue<int>();
        Data.Set(data);
    }

    public static implicit operator int(ObscureInt o)
    {
        return o.Data.Get();
    }

    public static implicit operator ObscureInt(int data)
    {
        return new ObscureInt(data);
    }

    public static ObscureInt operator +(ObscureInt a, int b)
    {        
        a.Data.Set(a.Data.Get() + b);        
        return a;
    }    

}