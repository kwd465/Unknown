using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class GamePlayStatics
{
    public static bool IsRandomActive(float _percent)
    {
        float checkValue = Random.Range(0f, 100f);

        if (checkValue <= _percent)
        {
            return true;
        }

        return false;
    }
}