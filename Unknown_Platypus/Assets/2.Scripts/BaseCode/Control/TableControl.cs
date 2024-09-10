using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using BH;
using UnityEngine.UIElements;

public class TableControl : BHSingleton<TableControl>
{
    public StringTable m_stringTable;
    public StringBasicTable m_stringBasicTable;
    public CharacterTable m_characterTable;
    public MonsterTable m_monsterTable;
    public SkillTable m_skillTable;
    public ItemTable m_ItemTable;
    public StageTable m_stageTable;
    public WaveTable m_waveTable;
    public EquipTable m_equipTable;
    public GachaTable m_gachaTable;

    public SkillOptionTable m_skillOptionTable;

    public bool isLoad = false;
    public Action _endLoadEvent;

    ClassFileSave m_fileSave = new ClassFileSave();
    List<TableBase> m_tableList = new List<TableBase>();

    public ItemTableData GetItem(int key)
    {
        return m_ItemTable.GetRecord(key);
    }


    public override void Init()
    {
        base.Init();
        PreLoad();
        Load();
    }

    public void PreLoad(ClassFileSave _fileSave = null)
    {
        m_stringBasicTable = new StringBasicTable(m_fileSave);
        m_stringBasicTable.Load();
    }

    public void Load(ClassFileSave _fileSave = null)
    {
        if (null != _fileSave)
        {
            m_fileSave = _fileSave;
        }

        m_tableList.Clear();

        m_tableList.Add(m_characterTable = new CharacterTable(m_fileSave));
        m_tableList.Add(m_stringTable = new StringTable(m_fileSave));
        m_tableList.Add(m_monsterTable = new MonsterTable(m_fileSave));
        m_tableList.Add(m_skillTable = new SkillTable(m_fileSave));
        m_tableList.Add(m_stageTable = new StageTable(m_fileSave));
        m_tableList.Add(m_waveTable = new WaveTable(m_fileSave));
        m_tableList.Add(m_equipTable = new EquipTable(m_fileSave));
        m_tableList.Add(m_ItemTable = new ItemTable(m_fileSave));
        m_tableList.Add(m_gachaTable = new GachaTable(m_fileSave));
        m_tableList.Add(m_skillOptionTable = new SkillOptionTable(m_fileSave));

        for (int i = 0; i < m_tableList.Count; ++i)
        {
            m_tableList[i].Load();
        }
        isLoad = true;
        _endLoadEvent?.Invoke();
        _endLoadEvent = null;
    }


    public void LoadLanguageTable()
    {
        m_stringTable.Load();
        _endLoadEvent?.Invoke();
        _endLoadEvent = null;
    }

    public string GetText(int _key)
    {

        StringTableData _data = null;

        if(m_stringBasicTable == null)
            return _key.ToString();

        if(m_stringBasicTable.IsHasRecord(_key))
            _data = m_stringBasicTable.GetRecord(_key);
        else
        { 
            if (m_stringTable == null)
                return _key.ToString();

            _data = m_stringTable.GetRecord(_key);
        }

        if (_data == null)
        {
            return "<color=green>!_" + _key.ToString() + "</color>"; ;
        }

        return GetRangText(_data);
    }

    private string GetRangText(StringTableData _data)
    {
        string rang = PlayerPrefs.GetString("Language", "EN");

        switch (rang)
        {
            case "KR":
                return _data.KR;

            case "EN":
                return _data.EN;

            case "JP":
                return _data.JP;

            default:
                return _data.EN;
        }
    }

}
