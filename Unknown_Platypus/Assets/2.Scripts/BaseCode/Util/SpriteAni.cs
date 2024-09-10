using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteAni : MonoBase
{
    public SpriteRenderer m_spriteRenderer;
    public List<Sprite> m_spriteList = new List<Sprite>();
    public float m_frameTime = 0.1f;

    private float m_curTime = 0;
    private int m_curIndex = 0;

    private void Awake()
    {
        m_curIndex = 0;
        m_curTime = 0;
        StagePlayLogic.instance.AddSpriteAni(this);
    }

    private void OnEnable()
    {
        m_curIndex = 0;
        m_curTime = 0;
    }

    private void OnDisable()
    {
        
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if (m_spriteList.Count == 0)
            return;

        m_curTime += Time.fixedDeltaTime;

        if (m_curTime >= m_frameTime)
        {
            m_curTime = 0;
            m_curIndex++;
            if (m_curIndex >= m_spriteList.Count)
                m_curIndex = 0;

            m_spriteRenderer.sprite = m_spriteList[m_curIndex];
        }
    }
}
