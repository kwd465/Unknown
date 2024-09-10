public partial class DataManager : WithSingleton<DataManager>
{
    public class BaseClass
    {
        public int id;
    }
    
    public class State : BaseClass
    {
        public string name;
        public float hp;
        public float atk;
        public float def;
        public float range;
        public float moveSpeed;
        public float attackSpeed;
        public WeaponStyle AttackType;
    }
    public class Skill : BaseClass
    {
        public string name;
        public float atk;
        public float attackSpeed;
        public float delayTime;
        public float duration;
        public string effect;
        public string hitEffect;
    }
}
