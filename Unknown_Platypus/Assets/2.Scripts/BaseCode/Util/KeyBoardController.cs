using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyBoardController : MonoBase
{
	// PUBLIC
	public delegate void TouchDelegate(Vector2 value);
	public event TouchDelegate ClickEvent;

	public bool isMove = false;

	private Vector2 keyBoardVector = Vector2.zero;
	private Vector2 movementVector;

	private bool useKeyBoard = false;

    public override void UpdateLogic()
    {
        base.UpdateLogic();
		if (StagePlayLogic.instance.IsPause)
		{
			return;
		}

		float _moveX = 0;
		float _moveY = 0;
		isMove = false;
		if (Input.GetKey(KeyCode.W) ||
			Input.GetKey(KeyCode.UpArrow))
		{
			isMove = true;
            _moveY = 90f;
		}

		if (Input.GetKey(KeyCode.A) ||
			Input.GetKey(KeyCode.LeftArrow))
		{
			isMove = true;
			_moveX = -90f;
		}

		if (Input.GetKey(KeyCode.S) ||
			Input.GetKey(KeyCode.DownArrow))
		{
			isMove = true;
			_moveY = -90f;
		}

		if (Input.GetKey(KeyCode.D) ||
			Input.GetKey(KeyCode.RightArrow))
		{
			isMove = true;
			_moveX = 90f;
		}

		if(isMove)
            useKeyBoard = true;

        if (_moveX == 0 && _moveY == 0 && useKeyBoard)
		{
			StagePlayLogic.instance.m_Player.Stop();
			useKeyBoard = false;
            return;
        }

		if (isMove == false && useKeyBoard == false)
			return;


		keyBoardVector.x = _moveX;
		keyBoardVector.y = _moveY;
		movementVector = (keyBoardVector - Vector2.zero).normalized;
		StagePlayLogic.instance.m_Player.Move(movementVector);
	}
}
