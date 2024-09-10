using UnityEngine;
using UnityEngine.UI;

public class DamageEffect : MonoBase
{
    public Text damageText;

    public virtual void Open(double damage , bool isUser = false , bool isCri = false)
    {
        damageText.text = damage.ToString();
        if(isUser == false)
            damageText.color = Color.red;
        else
            damageText.color = Color.white;

        //크리티컬일땐 어케 할지
    }
    public void OffEffect()
    {
        gameObject.SetActive(false);
        ObjectPoolManager.instance.SetDamageEffect(this);
    }
}
