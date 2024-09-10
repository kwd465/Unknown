using UnityEngine;
using System.Collections;


public abstract class FsmState<T>
{
    private T m_state;
	
	public FsmState(T _state ) 
	{
        m_state = _state;      
    }

    public T getState
	{
		get 
		{
			return m_state;
		}
	}	
	
	#region - virtaul 
	public virtual void Enter()
	{		
	}	
	public virtual void Update()
	{		
	}	
	public virtual void End()
	{		
	}
    public virtual void DrawGizmos()
    {
    }
    #endregion
}
