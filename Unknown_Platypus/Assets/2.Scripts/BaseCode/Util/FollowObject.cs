using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Yoo
{
    public class FollowObject : UIBase
    {
        public virtual void UpdateLogic(Transform _target)
        {
            base.UpdateLogic();
            transform.position = _target.position; 
        }
    }
}
