using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BattleManager : WithSingleton<BattleManager>
{
    public void Attacking(float atk, ActorBase target, SkillBase skill = null)
    {
        float damage = atk - target.state.def;
        damage = damage > 0 ? damage : 1;
        target.SetHP(damage);

        if(target.actorType >= ActorType.Monster)
            FactoryManager.instance.DamageEffect(target.damagePos, (int)damage);

        if(skill != null)
        {
            target.SkillHit(skill);
            //스킬 이펙트 id 로 가져오기 
        }
        else
        {
            //평타 이펙트 id 로 가져오기 
        }
    }
    public void GetDropItem(ActorBase target)
    {
        if (target.item == BattleItem.NONE)
            return;
        OldDropItem item = FactoryManager.instance.GetDropItem(target.item);
        item.transform.position = target.transform.position;
    }
}
