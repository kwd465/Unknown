using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelUpUI : UIBase
{
    public SkillSlot[] slot;
    public void SkillInit()
    {
        slot[0].Init(this, SkillType.Airsphere);
        slot[1].Init(this, SkillType.Elemental);
        slot[2].Init(this, SkillType.Planet);
        slot[3].Init(this, SkillType.Pulsebeam);
    }
}
