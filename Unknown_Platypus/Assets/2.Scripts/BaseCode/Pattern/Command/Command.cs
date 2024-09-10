using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace BH
{

    public interface Command
    {
        void Execute();
        void Update();
        bool IsFinished();
    }

    public class StackCommand
    {
        bool m_isActive = false;
        Stack<Command> m_commands = new Stack<Command>();

        public void Add(Command _command)
        {
            if (null == _command)
                return;

            m_commands.Push(_command);
        }

        public void Clear()
        {
            m_commands.Clear();
        }

        public void Execute()
        {
            if (m_commands.Count <= 0)
            {
                return;
            }

            Command _command = m_commands.Pop();
            _command.Execute();
        }

        public void Pop(bool _active)
        {
            m_isActive = _active;
        }

        public void UpdateLogic()
        {
            if (m_isActive == true)
            {
                Execute();
                m_isActive = false;
            }
        }

    }



    public class QueueCommand
    {
        Queue<Command> m_commandList = new Queue<Command>();
        Command m_curCommand;

        public bool IsEmpty()
        {
            return null == m_curCommand && m_commandList.Count <= 0;
        }

        public void Add(Command _command)
        {
            if (null == _command)
                return;

            m_commandList.Enqueue(_command);
        }

        void Execute()
        {
            if (m_commandList.Count <= 0)
            {
                m_curCommand = null;
                return;
            }

            m_curCommand = m_commandList.Dequeue();
            m_curCommand.Execute();
        }

        public void Update()
        {
            if (null == m_curCommand && m_commandList.Count <= 0)
                return;

            if (null != m_curCommand)
            {
                m_curCommand.Update();
                if (m_curCommand.IsFinished())
                {
                    Execute();
                }
            }
            else
            {
                Execute();
            }
        }
    }

    [System.Serializable]
    public class FlowCommand
    {
        [SerializeField]
        int m_index = 0;
        Command m_current;
        List<Command> m_commandList = new List<Command>();

        public bool IsEnd()
        {
            return m_commandList.Count <= m_index;
        }

        public void Add(Command _command)
        {
            if (null == _command)
                return;

            m_commandList.Add(_command);
        }

        public void Remove(Command _command)
        {
            if (null == _command)
                return;

            m_commandList.Remove(_command);
        }

        public void Execute()
        {
            SetCommand(0);
        }

        public void Update()
        {
            if (IsEnd() == true)
                return;

            if (m_current == null)
            {
                SetCommand(m_index);
                return;
            }

            m_current.Update();
            if (m_current.IsFinished())
            {
                SetCommand(m_index + 1);
            }
        }

        void SetCommand(int _index)
        {
            m_index = _index;
            if (m_commandList.Count <= m_index)
                return;

            m_current = m_commandList[m_index];
            m_current.Execute();
        }
    }
}
