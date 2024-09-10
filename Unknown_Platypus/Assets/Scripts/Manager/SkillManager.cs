using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Skill
{

    public enum SkillState
    {
        ready,
        cool,
        work,   // 스킬 사용중
    }

    public SkillState state;
    public int level;
    public float coolTime;
    public float totalCoolTime;
    public SkillBase skillBase;
    public bool isManual;
    public float skillDuration;

    public int skillSlotIndex;

    public void UpdateState()
    {
        if (state == SkillState.cool)
        {
            coolTime -= Time.fixedDeltaTime;
            if (coolTime <= 0)
            {
                coolTime = 0;

                if (isManual && skillSlotIndex != -1)
                {
                    state = SkillState.ready;
                    BattleUIManager.instance.SetSkillButttonReady(skillSlotIndex);
                }
                else
                {
                    UseSkill(SkillManager.instance.Player);
                }
            }
            else
            {
                if (skillSlotIndex != -1)
                {
                    BattleUIManager.instance.UpdateSkillButton(skillSlotIndex, this);
                }
            }
        }
        else if (state == SkillState.work)
        {
            if (skillDuration == 0)
                return;

            coolTime += Time.fixedDeltaTime;
            if(coolTime >= skillDuration)
            {
                state = SkillState.cool;
                coolTime = totalCoolTime;

                if(skillSlotIndex!=-1)
                {
                    BattleUIManager.instance.SetSkillButtonLock(skillSlotIndex);
                }
            }
        }
    }

    public void UseSkill(OldPlayer player)
    {
        state = SkillState.work;
        coolTime = 0;
        skillBase.UseSkill(player.transform.position);

        if (skillSlotIndex != -1)
        {
            BattleUIManager.instance.SetSkillButtonLock(skillSlotIndex);
        }

    }
}


public class SkillManager : Singleton<SkillManager>
{    
    List<Skill> skillList = new List<Skill>();

    OldPlayer player;

    public void InitPlayer(OldPlayer player)
    {
        this.player = player;
    }

    public OldPlayer Player
    {
        get
        {
            return player;
        }
    }


    void FixedUpdate()
    {
        //if (GameManager.instance.isPause)
        //    return;

        foreach (var skill in skillList)
        {
            skill.UpdateState();
        }        
    }

    public Skill AddSkill(SkillBase skillbase, bool isManual)
    {
        Skill skill = new Skill();

        skill.skillBase = skillbase;
        skill.level = 1;
        skill.totalCoolTime = 10;
        skill.coolTime = skill.totalCoolTime;        
        skill.state = Skill.SkillState.cool;
        skill.isManual = isManual;
        skill.skillDuration = 1;

        skillList.Add(skill);
        skill.skillSlotIndex = -1;

        return skill;
    }

    public void UseSkill(Skill skill)
    {
        skill.UseSkill(player);

    }    

}
