using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;



public class WaveInfo
{
    private WaveTableData m_waveData;
    private float m_timer;
    private float m_spawnTimer;
    private bool m_isFinish;
    private Action<WaveInfo> m_callBackFinish;

    public bool IsFinish => m_isFinish;

    public WaveInfo(WaveTableData _data)
    {
        m_waveData = _data;
        m_timer = 0;
        m_isFinish = false;
    }

    public void UpdateLogic(float _curTime)
    {
        if (m_isFinish)
            return;

        if (_curTime <= (float)m_waveData.startTime)
            return;

        if (m_timer >= m_waveData.duration)
        {
            m_isFinish= true;
            m_callBackFinish?.Invoke(this);
            return;
        }
        
        if(m_spawnTimer >= m_waveData.respawnTime)
        {
            StagePlayLogic.instance.m_SpawnLogic.SpawnMonster(m_waveData.monsterType, m_waveData.monsterIdx ,m_waveData.rewardIdx, m_waveData.monsterLv );
            m_spawnTimer = 0;
            if (m_waveData.monsterType == MonsterType.BOSS)
                m_isFinish = true;
        }
        else
            m_spawnTimer += Time.fixedDeltaTime;

        m_timer += Time.fixedDeltaTime;
    }
}


public class SpawnLogic : MonoBase
{
    public PoolObjectGroup<Player> m_monsterList;
    public PoolObjectGroup<DropItem> m_dropItemList;

    public List<Player> m_monList;
    public Transform m_trSpawn;
    private Transform[] spawnPoint;

    private List<WaveInfo> m_waveList = new List<WaveInfo>();


    float timer;
    string spwnPath = "Prefabs/Monster/";

    bool isBoss = false;

    private void Awake()
    {
        spawnPoint = m_trSpawn.GetComponentsInChildren<Transform>();
        
    }

    public void Init()
    {
        m_monsterList = new PoolObjectGroup<Player>(transform);
        m_dropItemList = new PoolObjectGroup<DropItem>(transform);
        m_monList = new List<Player>();
        m_waveList.Clear();
        isBoss = false;
        WaveGroup _group = TableControl.instance.m_waveTable.GetGroupData(GameData.m_curStage.wavegroup);

        for(int i = 0; i < _group.m_list.Count; i++)
        {
            m_waveList.Add(new WaveInfo(_group.m_list[i]));
        }
    }
    
    public void Clear()
    {
        m_waveList.Clear();
        m_monsterList.Clear();
    }

    public override void UpdateLogic()
    {
        base.UpdateLogic();
        m_monsterList.UpdateLogic();
        m_dropItemList.UpdateLogic();
        if (isBoss == false)
        {
            for (int i = 0; i < m_waveList.Count; i++)
            {
                m_waveList[i].UpdateLogic(timer);
            }

            timer += Time.deltaTime;
        }
    }

    public void SetPause(bool _isPause)
    {
        for(int i = 0; i < m_monList.Count; i++)
        {
            m_monList[i].Ani.SetPause(_isPause);
        }
    }

    public Vector3 GetSpawnPos()
    {
        float randomAngle = UnityEngine.Random.Range(0f, Mathf.PI * 2); // 0에서 2파이(360도) 사이의 랜덤한 각도
        float distance = 10f;
        Vector3 playerPosition = StagePlayLogic.instance.m_Player.transform.position;
        Vector3 spawnPosition = playerPosition + new Vector3(Mathf.Cos(randomAngle) * distance, Mathf.Sin(randomAngle) * distance, 0);
        if (StagePlayLogic.instance.mapSize.Contains(spawnPosition))
            return spawnPosition;
        else
            return GetSpawnPos();
    }


    public void SpawnMonster(MonsterType _type , int _monIdx ,string _rewardIdx, int _monLv = 1)
    {
        CharacterTableData _mData = TableControl.instance.m_monsterTable.GetRecord(_monIdx);

        Player _monster = m_monsterList.Get(spwnPath + _mData.prefab);

        if (null == _monster)
            return;

        //Transform point = spawnPoint[UnityEngine.Random.Range(1, spawnPoint.Length)];
        PlayerData _monData = new PlayerData(e_PlayerType.MON , _mData, _rewardIdx, _monLv);
        
        ((Monster)_monster).Init(_type== MonsterType.NORMAL?e_PlayerType.MON:e_PlayerType.MON_BOSS, _monData, new PlayerFsm_Monster() , GetSpawnPos());
        m_monList.Add(_monster);
        //보스 몬스터 소환할때 소환되어 있던 몬스터를 전부 없앨 것인가?
        if (_type == MonsterType.BOSS)
        {
            isBoss = true;
            StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.BOSS_START);
        }
    }

    public void MonsterDie(Player _mon)
    {
        m_monList.Remove(_mon);

        //아이템 드랍도 여기서?
        GachaTableData _result = TableControl.instance.m_gachaTable.GetGacha(_mon.getData.m_rewardIdx);

        if (_result == null)
            return;

        DropItem _item = m_dropItemList.Get("Prefabs/Item/DropItem");
        _item.Open(_result, _mon.transform.position);
    }

    public void BossMonsterDie()
    {
        isBoss = false;
        //마지막 웨이브였는지 체크
        bool _isFinish = true;

        for(int i = 0; i < m_waveList.Count; i++)
        {
            if (m_waveList[i].IsFinish == false)
            {
                _isFinish = false;
                break;
            }
        }

        if(_isFinish == true)
        {
            StagePlayLogic.instance.m_stageFsm.SetState(eSTAGE_STATE.FINISH);
        }
    }

}
