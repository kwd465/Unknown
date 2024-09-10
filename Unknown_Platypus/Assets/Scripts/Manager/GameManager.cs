using BH;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class GameManager : BHSingleton<GameManager>
{

    private void Awake()
    {
        StagePlayLogic.instance.Init();
    }

    private void Update()
    {
        StagePlayLogic.instance.UpdateLogic();
    }
}
