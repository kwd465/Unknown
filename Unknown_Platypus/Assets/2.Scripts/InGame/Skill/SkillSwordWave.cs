using System.Collections;
using System.Collections.Generic;
using BH;
using Unity.VisualScripting;
using UnityEngine;

public class SkillSwordWave : SkillObject
{
    

    private List<GameObject> targetList = new List<GameObject>();
    private float m_checkTime = 0;

    private void Awake()
    {
        gameObject.SetActive(false);
    }


    override public void Apply()
    {
        base.Apply();
        targetList.Clear();
        gameObject.SetActive(true);
        m_checkTime = 0;
        transform.localScale = new Vector3(m_area ,m_area , 1f);
    }

    override public void UpdateLogic()
    {
        base.UpdateLogic();

        m_checkTime += Time.fixedDeltaTime;

        Vector3 _target = m_dir * 5f * Time.fixedDeltaTime;
        transform.position += _target;
        // 이동 방향의 각도를 구합니다.
        float angle = Mathf.Atan2(m_dir.y, m_dir.x) * Mathf.Rad2Deg;

        // 오브젝트의 회전 각도를 설정합니다.
        transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);



        if (m_checkTime >= m_duration)
        {
            m_checkTime = 0;
            Close();
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag != "Monster" || targetList.Contains(collision.gameObject))
            return;

        targetList.Add(collision.gameObject);
        BattleControl.instance.ApplySkill(m_skillData, m_owner, collision.GetComponent<Player>());
    }  


}
