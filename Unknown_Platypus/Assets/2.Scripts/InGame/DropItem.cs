
using UnityEngine;


public class DropItem : UIBase
{
    public CircleCollider2D m_collider;
    public SpriteRenderer m_icon;

    private int m_ItemKey;
    private ItemTableData m_item;
    private int m_count;
    private bool isMove;

    public virtual void Open(GachaTableData _reward , Vector3 _pos)
    {
        Open(_reward.itemidx, _reward.itemcount, _pos);
    }

    public virtual void Open(int _itemKey, int _count, Vector3 _pos)
    {
        isMove = false;
        
        m_ItemKey = _itemKey;
        m_collider.radius = 0.5f;
        ItemTableData _item = TableControl.instance.GetItem(_itemKey);
        if (_item == null)
        {
            Close();
            return;
        }

        m_item = _item;
        transform.position = _pos;
        transform.localScale = Vector3.one* 0.5f;
        m_item = _item;
        m_count = _count;

        //if (_item.itemSubType == ItemSubType.EXP)
        //{
        //    m_count = _count;
        //    SetIcon(m_icon, m_item.icon);
        //    return;
        //}
        //if (_item.itemSubType == ItemSubType.GOLD)
        //    m_count += Math.Truncate(m_count * StagePlayLogic.instance.getUser.getData.GetStatValue(eSTAT.GoldUp));

        SetIcon(m_icon, m_item.icon);
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();

        if (isMove == false)
            return;

        Vector3 _dir = StagePlayLogic.instance.m_Player.transform.position - transform.position;
        
        if (_dir.magnitude < 0.5f)
        {
            isMove = false;
            FinishRooting();
            return;
        }
        transform.position += _dir.normalized * Time.deltaTime * 12f;
    }


    public void Rooting()
    {
        isMove = true;
    }

    private void FinishRooting()
    {
        Close();

        SoundControl.Play("addgold");

        StagePlayLogic.instance.AddItem(m_item, m_count);

    }
}
