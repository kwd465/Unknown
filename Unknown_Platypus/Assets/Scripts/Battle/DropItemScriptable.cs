using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu]
public class DropItemScriptable : ScriptableObject
{
    [SerializeField]
    private Sprite[] ITEM;

    public Sprite GetItemSprite(BattleItem item)
    {
        return ITEM[(int)item];
    }
}
