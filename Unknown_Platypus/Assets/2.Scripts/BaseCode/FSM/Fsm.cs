using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Fsm<T>
{    
    protected SortedList<T, FsmState<T>> m_stateList = new SortedList<T, FsmState<T>>();       
    protected FsmState<T> m_curState = null;    
    protected FsmState<T> m_nextState = null;
    
    public T curState; 
    public T nextState;
    
    #region - virtual
    public virtual void Clear()
    {
        m_stateList.Clear();
        m_curState = null;
        m_nextState = null;
        curState = default(T);
        nextState = default(T);
    }
	
	public virtual void AddFsm(FsmState<T> _state )
	{
        if (true == m_stateList.ContainsKey(_state.getState))
        {
            Debug.LogError(_state.getState.ToString() );
            return;
        }
        m_stateList.Add(_state.getState, _state );
	}	
	
	public virtual void SetState(T _state)
	{
        if (false == m_stateList.ContainsKey(_state))
        {
            Debug.LogError(_state);
            return;
        }     

        m_nextState = m_stateList[nextState = _state];
    }

    public virtual void Update()
    {

        if (null != m_nextState)
        {
            if (null != m_curState)
                m_curState.End();


            curState = nextState;
            m_curState = m_nextState;
            m_nextState = null;
            nextState = default(T);  
            m_curState.Enter();
        }
		
		if( null != m_curState )
            m_curState.Update();
	}		

    public virtual void DrawGizmos()
    {
        if (null != m_curState)
            m_curState.DrawGizmos();
    }
    #endregion

}
