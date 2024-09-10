using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAni_Sprite : PlayerAni
{

    protected SpriteRenderer m_sprite;

    public PlayerAni_Sprite(SpriteRenderer _sprite)
    {
        m_sprite = _sprite;
    }

    public override void SetDir(Vector3 _dir)
    {
        base.SetDir(_dir);
        m_sprite.flipX = _dir.x < 0;
    }

    public override List<string> GetAniNameList()
    {
        return null;
    }

    public override float GetAniTime()
    {
        return 0;
    }

    public override bool IsPlay()
    {
        return true;
    }

    public override void Play(string _name, bool _loop)
    {
        
    }

    public override void PlayTime(string _name, float _time)
    {
        
    }

    public override void SetPause(bool _isPause)
    {
        
    }
}
