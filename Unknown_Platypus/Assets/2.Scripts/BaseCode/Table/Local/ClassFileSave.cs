using UnityEngine;
//using UnityEngine.AddressableAssets;
//using UnityEngine.ResourceManagement.AsyncOperations;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using BH;
public class ClassFileSave
{
    public delegate string ResPathAction(string _path);
    ResPathAction m_resPathAction;

    public virtual bool Save(string _path, object _data)
    {
        if (null == _data)
        {
            Debug.LogError("null == object : " + _path);
            return false;
        }

        FileStream stream = new FileStream(_path, FileMode.Create);
        BinaryFormatter formatter = new BinaryFormatter();  
        
        try
        {
            formatter.Serialize(stream, _data);
            return true;
        }
        catch
        {
            return false;
        }
        finally
        {
            stream.Close();
        }  
    }

    public void SetResPath(ResPathAction _resPathAction)
    {
        m_resPathAction = _resPathAction;
    }

    public string GetResPath(string _path)
    {
        if (m_resPathAction == null)
        {
            Debug.LogError("error : " + _path);
            return _path;
        }
        return m_resPathAction(_path);
    }

    public virtual object Load(string _path)
    {
        if (System.IO.File.Exists(_path) == false)
        {
            Debug.LogWarning("LoadClass() [file no exists] path : " + _path);
            return null;
        }

        BinaryFormatter formatter = new BinaryFormatter();
        FileStream stream = new FileStream(_path, FileMode.Open);

        try
        {
            return formatter.Deserialize(stream);
        }
        catch
        {
            return null;
        }
        finally
        {
            stream.Close();
        }     
    }

    public virtual object LoadRes(string _path)
    {
        TextAsset _asset = ResourceControl.instance.Load<TextAsset>(_path);
        if (null == _asset)
        {
            Debug.LogError("Load failed : " + _path);
            return null;
        }

        byte[] byteData = _asset.bytes;
        MemoryStream stream = new MemoryStream(byteData);
        try
        {
            stream.Seek(0, SeekOrigin.Begin);
            BinaryFormatter formatter = new BinaryFormatter();
            return formatter.Deserialize(stream);
        }       
        catch
        {
            return null;
        }
        finally
        {
            stream.Close();
        }
    }

}


public class ClassFileSave_Editor : ClassFileSave
{
    public override object LoadRes(string _path)
    {
        TextAsset _asset = ResourceControl.instance.Load_Editor<TextAsset>(_path);
        if (null == _asset)
        {
            Debug.LogError("Load failed : " + _path);
            return null;
        }

        byte[] byteData = _asset.bytes;
        MemoryStream stream = new MemoryStream(byteData);
        try
        {
            stream.Seek(0, SeekOrigin.Begin);
            BinaryFormatter formatter = new BinaryFormatter();
            return formatter.Deserialize(stream);
        }
        catch
        {
            return null;
        }
        finally
        {
            stream.Close();
        }
    }
}
