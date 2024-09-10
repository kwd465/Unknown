using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FactoryManager : WithSingleton<FactoryManager>
{
    public bool isFactory = false;

    private DropItemScriptable itemSprite;
    private HashSet<MonsterBase> liveMonster = new HashSet<MonsterBase>();
    private HashSet<OldDropItem> liveItem = new HashSet<OldDropItem>();

    private void Start()
    {
        itemSprite = Resources.Load<DropItemScriptable>("Prefabs/Item/DropItemScriptable");
    }

    public void MonsterFactory(int id, Transform tr)
    {
        DataManager.State info = new DataManager.State();
        info.id = 1;
        info.name = "slime";
        info.hp = 1;
        info.atk = 1;
        info.def = 1;
        info.range = 0;
        info.moveSpeed = 1.5f;
        info.attackSpeed = 1f;
        info.AttackType = WeaponStyle.Melee;


        //TableManager.tableMonster.Get(id);

        if (!ObjectPoolManager.instance.GetMonster(id, out MonsterBase monster))
        {
            monster = Instantiate(Resources.Load<MonsterBase>($"Prefabs/Monster/{info.name}"));
            monster.transform.parent = transform;
        }

        monster.init(info);
        monster.transform.position = tr.position;
        liveMonster.Add(monster);
        monster.item = MonsterItemSet();
    }
    public void DamageEffect(Transform tr, int damage)
    {
        DamageEffect effect;
        if (!ObjectPoolManager.instance.GetDamageEffect(out effect))
            effect = Instantiate(Resources.Load<DamageEffect>("Prefabs/damageEffect"));

        if(!effect.gameObject.activeSelf)
            effect.gameObject.SetActive(true);
        effect.Open(damage);
        effect.transform.position = tr.transform.position;
    }

    public void DropItem(OldDropItem item)
    {
        liveItem.Remove(item);
        ObjectPoolManager.instance.DropItem(item);
    }

    public OldDropItem GetDropItem(BattleItem item)
    {
        OldDropItem temp;

        if (!ObjectPoolManager.instance.GetItem(out temp))
            temp = Instantiate(Resources.Load<OldDropItem>("Prefabs/Item/DropItem"));

        temp.Init(item, itemSprite.GetItemSprite(item));
        liveItem.Add(temp);

        return temp;
    }
    public void ClearMonster()
    {
        StartCoroutine(Bomb());
    }
    private BattleItem MonsterItemSet()
    {
        float rand = Random.Range(0, 100);
        BattleItem temp = BattleItem.NONE;
        //if (rand <= 30)
        //    temp = BattleItem.NONE;
        if (rand > 30 && rand <= 60)
            temp = BattleItem.EXP_10;
        else if (rand > 60 && rand <= 70)
            temp = BattleItem.EXP_25;
        else if (rand > 70 && rand <= 80)
            temp = BattleItem.EXP_50;
        else if (rand > 80 && rand <= 100)
            temp = BattleItem.HP;
        //else if (rand > 90 && rand <= 100)
        //    temp = BattleItem.BOMB;

        return temp;
    }
    IEnumerator Bomb()
    {
        foreach(MonsterBase i in liveMonster)
            i.status = ActorStatus.Die;

        yield break;
    }

    public HashSet<MonsterBase> GetLiveMonster()
    {
        return liveMonster;
    }
}
