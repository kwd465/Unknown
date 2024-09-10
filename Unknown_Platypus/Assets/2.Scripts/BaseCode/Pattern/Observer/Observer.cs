using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface Notify
{
    public void Refresh(Observer _observer);
}


public class Observer
{

    private List<Notify> m_list = new List<Notify>();

    public void AddListner(Notify _noti)
    {
        if (m_list.Contains(_noti) == false)
            m_list.Add(_noti);
        else
            Debug.Log("Already Notify : "+ _noti.ToString());
    }

    public void RemoveListner(Notify _noti)
    {
        if (m_list.Contains(_noti) == true)
            m_list.Remove(_noti);
        else
            Debug.Log("Already Notify : " + _noti.ToString());
    }

    public void SetNotify()
    {
        for(int i = 0; i < m_list.Count; i++)
        {
            m_list[i].Refresh(this);
        }
    }

}
