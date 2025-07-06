using UnityEngine;
using System.Collections.Generic;
using Unity.Collections;
using System;
using Cysharp.Threading.Tasks;
using System.Threading;
using Spine.Unity;


[System.Flags]
public enum STATUS_EFFECT
{
    NONE = 0,

    FROZEN = 1 << 0,
}

public class StatusEffectController
{
    public STATUS_EFFECT Now_Status_Effect { get; protected set; }

    protected Queue<STATUS_EFFECT> effectQueue;

    /// <summary>
    /// key == effect type, key == time , value == task queue -Jun 24-10-23
    /// </summary>
    private Dictionary<STATUS_EFFECT, Dictionary<float, Queue<UniTask>>> effectDict;
    private Dictionary<STATUS_EFFECT, Dictionary<float, Queue<CancellationTokenSource>>> cancelTokenDict;

    private Player thisUnit;

    public StatusEffectController(Player _unit)
    {
        effectQueue = new();
        effectDict = new();
        cancelTokenDict = new();
        Now_Status_Effect = STATUS_EFFECT.NONE;

        thisUnit = _unit;
    }

    public bool IsExistStatusEffect(STATUS_EFFECT _effect)
    {
        return Now_Status_Effect.HasFlag(_effect) ? true : false;
    }

    public long GetEffectValue(STATUS_EFFECT _effect)
    {
        if (Now_Status_Effect.HasFlag(_effect) is false)
        {
            return 0;
        }

        return 0;
    }

    public void SetStatusEffect(STATUS_EFFECT _effect, float _time, long _value)
    {
        if(IsExistStatusEffect(_effect) == false)
        {
            Now_Status_Effect |= _effect;
        }

        if (effectDict.TryGetValue(_effect, out var dict) is false)
        {
            effectDict.Add(_effect, new());
            cancelTokenDict.Add(_effect, new());
        }

        if (effectDict[_effect].TryGetValue(_time, out var queue) is false)
        {
            effectDict[_effect].Add(_time, new());
            cancelTokenDict[_effect].Add(_time, new());
        }

        var newCancelToken = new CancellationTokenSource();

        switch (_effect)
        {
            case STATUS_EFFECT.FROZEN:
                Debug.Log("frozen 상태");
                //thisUnit.AddStat(UNIT_STAT_TYPE.ATTACK_POWER, _value);
                break;
        }

        cancelTokenDict[_effect][_time].Enqueue(newCancelToken);
        effectDict[_effect][_time].Enqueue(CaclEffectTime(_effect, _time, _value, newCancelToken));

        thisUnit.StatusEffectActiveAction?.Invoke(_effect, _time);
    }

    private async UniTask CaclEffectTime(STATUS_EFFECT _effect, float _time, long _value, CancellationTokenSource _token)
    {
        float timeCheck = 0;

        while (timeCheck < _time)
        {
            await UniTask.Yield(cancellationToken: _token.Token);

            timeCheck += Time.deltaTime;

            //if (_effect == STATUS_EFFECT.BURN || _effect == STATUS_EFFECT.CURSED)
            //{
            //    thisUnit.FixedDamageHit(_value);
            //}
        }

        //if (_effect == STATUS_EFFECT.ATTACK_UP)
        //{
        //    thisUnit.AddStat(UNIT_STAT_TYPE.ATTACK_POWER, -_value);
        //}

        EndStatusEffect(_effect, _time);
    }

    public void EndStatusEffect(STATUS_EFFECT _effect, float _time)
    {
        if (effectDict[_effect][_time].Count == 0 || cancelTokenDict[_effect][_time].Count == 0)
        {
            return;
        }

        thisUnit.StatusEffectEndAction?.Invoke(_effect, _time);

        effectDict[_effect][_time].Dequeue();
        cancelTokenDict[_effect][_time].Dequeue();

        if (cancelTokenDict[_effect][_time].Count == 0)
        {
            Now_Status_Effect &= ~_effect;
        }
    }

    /// <summary>
    /// 딱히 effect type 굽분 없이 존재하는 갯수 만약에 한개의 상태이상의 갯수보다 많으면 다음 상태이상으로 넘어감 -Jun 24-12-19
    /// </summary>
    /// <param name="_endCount"></param>
    public void EndStatusEffect(int _endCount)
    {
        foreach (var leftEffectDict in effectDict)
        {
            if (_endCount == 0)
            {
                break;
            }

            if (leftEffectDict.Value.Count == 0)
            {
                continue;
            }

            foreach (var queueDict in leftEffectDict.Value)
            {
                if (queueDict.Value.Count == 0)
                {
                    continue;
                }

                if (_endCount <= 0)
                {
                    break;
                }

                EndStatusEffect(leftEffectDict.Key, queueDict.Key);
                _endCount--;
            }
        }
    }

    /// <summary>
    /// 하나의 상태이상만 end 상태이상 갯수보다 많으면 넘어가지 않고 그대로 끝 -Jun 24-12-19
    /// </summary>
    /// <param name="_effect"></param>
    /// <param name="_endCount"></param>
    public void EndStatusEffect(STATUS_EFFECT _effect, int _endCount)
    {
        foreach (var leftEffectDict in effectDict)
        {
            if (_endCount == 0)
            {
                return;
            }

            if (leftEffectDict.Value.Count == 0)
            {
                return;
            }

            foreach (var queueDict in leftEffectDict.Value)
            {
                if (queueDict.Value.Count == 0)
                {
                    continue;
                }

                if (_endCount <= 0)
                {
                    break;
                }

                EndStatusEffect(leftEffectDict.Key, queueDict.Key);
                _endCount--;
            }
        }
    }
    public void RemoveAllStatusEffect()
    {
        foreach (var tokenDict in cancelTokenDict.Values)
        {
            foreach (var tokenQueue in tokenDict.Values)
            {
                tokenQueue.TryDequeue(out var token);

                if (token != null)
                {
                    token.Cancel();
                    token.Dispose();
                }
            }
        }

        cancelTokenDict.Clear();
        effectDict.Clear();
        Now_Status_Effect = STATUS_EFFECT.NONE;
    }
}