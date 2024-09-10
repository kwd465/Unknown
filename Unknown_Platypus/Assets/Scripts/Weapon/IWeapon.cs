
using UnityEngine;

public interface IWeapon
{
    void Attack();
    void Init(OldPlayer _player);

    void SetDir(Vector3 dir);

    void TargetListClear();
}
