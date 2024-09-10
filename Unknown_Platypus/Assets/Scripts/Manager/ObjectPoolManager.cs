using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class ObjectPoolManager : WithSingleton<ObjectPoolManager>
{
    HashSet<MonsterBase> dieMonster = new HashSet<MonsterBase>();
    Queue<OldDropItem> dropItem = new Queue<OldDropItem>();
    Queue<MonsterBase> tempMonster = new Queue<MonsterBase>();
    Queue<DamageEffect> damageEffect = new Queue<DamageEffect>();

    private object lockObject = new object();

    public void SetDamageEffect(DamageEffect effect)
    {
        try
        {
            damageEffect.Enqueue(effect);
        }
        catch
        {
            Destroy(effect);
        }
    }
    public bool GetDamageEffect(out DamageEffect effect)
    {
        if (damageEffect.Count == 0)
        {
            effect = null;
            return false; 
        }

        if(!damageEffect.TryDequeue(out effect))
            return false;

        return true;
    }
    public void tempMonsterSet()
    {
        if (!FactoryManager.instance.isFactory && tempMonster.Count > 0)
            StartCoroutine(TempMonsterSet());
    }
    IEnumerator TempMonsterSet()
    {
        while (tempMonster.Count > 0 && !FactoryManager.instance.isFactory)
        {
            dieMonster.Add(tempMonster.Dequeue());
            yield return null;
        }

        yield break;
    }
    public void DropItem(OldDropItem item)
    {
        dropItem.Enqueue(item);
    }
    public bool GetItem(out OldDropItem item)
    {
        if (dropItem.Count == 0)
        {
            item = null;
            return false; 
        }

        return dropItem.TryDequeue(out item);
    }
    public void DieMonsterAdd(MonsterBase monster)
    {
        lock (lockObject)
        {
            if (!FactoryManager.instance.isFactory)
                tempMonster.Enqueue(monster); 
            else
                dieMonster.Add(monster);
        }
    }
    public bool GetMonster(int id, out MonsterBase resetMonster)
    {
        if (dieMonster.Count == 0)
        {
            resetMonster = null;
            return false; 
        }

        if (MonsterReset(id, out resetMonster))
            return true; 
        else
        {
            resetMonster = null;
            return false;
        }
    }
    private bool MonsterReset(int id, out MonsterBase resetMonster)
    {
        MonsterBase monster = dieMonster.FirstOrDefault(temp => temp.state.id == id);

        if (monster != null)
            dieMonster.Remove(monster);

        resetMonster = monster;

        return true;
    }
}
