using System.Collections;
using System.Collections.Generic;
using BH;
using UnityEngine;

public class SkillSatellite : SkillObject
{

    [SerializeField]
    private SkillSatelliteItem[] m_satellites;

    public override void Init(SkillEffect _data, Player _target, Player _owner, Vector3 _dir)
    {
        base.Init(_data, _target, _owner, _dir);
        transform.SetParent(_owner.transform);
        transform.rotation = Quaternion.identity;
        transform.localPosition = Vector3.zero;
    }


    public override void Apply()
    {
        base.Apply();

        for(int i = 0 ; i < m_count; i++)
        {
            m_satellites[i].Open(this);
        }

        for(int i = m_count; i < m_satellites.Length; i++)
        {
            m_satellites[i].Close();
        }
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
         
        // float _dir = StagePlayLogic.instance.m_Player.Ani.Dir.x > 0 ?-1f:1f;
        // Vector3 _scale = transform.localScale;
        // _scale.x = _dir;
        // transform.localScale = _scale;

        for(int i = 0 ; i < m_count; i++)
        {
            m_satellites[i].UpdateLogic();
        }

    }

    public override void OnTriggerEnterChild(Collider2D collision)
    {
        base.OnTriggerEnterChild(collision);
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }

}
