using UnityEngine;

public class OldDropItem : MonoBehaviour
{
    private SpriteRenderer spriteRenderer;
    private float[] itemEffect = new float[(int)BattleItem.BOMB];
    private OldPlayer target;
    private Collider2D collider;

    public BattleItem battleItem { private set; get; }
    private void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        collider = GetComponent<Collider2D>();
    }
    public void Init(BattleItem item, Sprite sprite)
    {
        if (item == battleItem)
        {
            target = null;
            collider.enabled = true;
            return; 
        }

        battleItem = item;
        spriteRenderer.sprite = sprite;
        if(collider == null)
            collider = GetComponent<Collider2D>();
        collider.enabled = true;
    }

    public void GetItme()
    {
        switch(battleItem)
        {
            case BattleItem.EXP_10:
                target.SetEXP(10);
                break;
            case BattleItem.EXP_25:
                target.SetEXP(25);
                break;
            case BattleItem.EXP_50:
                target.SetEXP(50);
                break;
            case BattleItem.HP:
                target.HpItemGet();
                break;
            case BattleItem.BOMB:
                FactoryManager.instance.ClearMonster();
                break;
        }
        UseItem();
    }

    private void UseItem()
    {
        FactoryManager.instance.DropItem(this);
        gameObject.SetActive(false);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Player")
        {
            target = collision.GetComponent<OldPlayer>();
            collider.enabled = false;
            GetItme();
        }
    }
}
