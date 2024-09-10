using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BH;

[System.Serializable]
public class ItemTableData : RecordBase
{
    public ItemType itemType;
    public ItemSubType itemSubType;
    public string icon;
    public string itemName;
    public string itemDesc;
    public int price;
    public string rewardKey;

    public override void LoadExcel(Dictionary<string, string> _data)
    {
        base.LoadExcel(_data);
        itemType = FileUtil.Get<ItemType>(_data, "itemType");
        itemSubType = FileUtil.Get<ItemSubType>(_data, "itemSubType");
        icon = FileUtil.Get<string>(_data, "icon");
        itemName = FileUtil.Get<string>(_data, "itemName");
        itemDesc = FileUtil.Get<string>(_data, "itemDesc");
        price = FileUtil.Get<int>(_data, "price");
        rewardKey = FileUtil.Get<string>(_data, "rewardKey");
    }
}

public class ItemTable : TTableBase<ItemTableData>
{

    public ItemTable(ClassFileSave _save) : base("Table/ItemTable", _save)
    {

    }

}
