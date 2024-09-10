using System.Collections;
using System.Collections.Generic;
using Spine;
using UnityEngine;
namespace BH
{
    public class BattleControl : BHSingleton<BattleControl>
    {

        public bool m_isBattleUpdate = true;

        public override void Init()
        {
            base.Init();
            m_isBattleUpdate = true;
        }

        public void SetDamage(Player _owner, Player _target, eSTAT _atkType, double _damage)
        {
            double finalDamage = 0;

            finalDamage = GetDamValue(_atkType, _owner.getData.GetStatValue(_atkType), _target);
            if (finalDamage <= 0)
                finalDamage = 1;

            bool _isCri = IsCri(_owner.getData.GetStatValue(eSTAT.cri));
            if (_isCri)
            {
                finalDamage *= 1.5f;
            }

           
            _target.SetDamage(finalDamage , _isCri);
        }

        private double GetDamValue(eSTAT _type , double _dam , Player target , bool _isPierce = false)
        {
            double _totalDam = 0;
            if(target == null)
                return _totalDam;
            if (_isPierce == false)
            {
                if (_type == eSTAT.atk)
                    _totalDam = _dam - target.getData.GetStatValue(eSTAT.def);
            }

            if (_totalDam < 1)
                _totalDam = 1;

            return _totalDam;
        }

        private bool IsCri(double _cri)
        {
            return _cri*10000f >= Random.Range(0f, 10000f);
        }

        public bool ApplySkill(SkillEffect _data ,Player _owner, Player _target)
        {
            bool _isDie = false;
            double _totalDam = 0;
            if(_target == null || _target.getData.IsDead())
                return true;
            for (int i = 0; i < _data.m_skillTable.skillEffectDataList.Count; i++)
            {
                _totalDam += ApplyEffect(_data, _data.m_skillTable.skillEffectDataList[i], _owner, _target);
            }

            //������ ����
            if (_totalDam > 0)
            {
                bool _isCri = IsCri(_owner.getData.GetStatValue(eSTAT.cri) + _data.GetOptionValue(SKILLOPTION_TYPE.cri));
                if (_isCri)
                {
                    _totalDam *= 1.5f + _data.GetOptionValue(SKILLOPTION_TYPE.criDam);
                }

                _target.SetDamage(_totalDam , _isCri);
            }

            return _isDie;
        }

        public double ApplyEffect(SkillEffect _skill, SkillEffectData _effect, Player _owner, Player target)
        {
            double _value = 0;

            switch (_effect.skillEffect)
            {
                case e_SkillEffect.buff:
                    _owner.getData.AddBuff(_skill.m_skillTable.index, _effect, true);
                    break;

                case e_SkillEffect.debuff:
                    target.getData.AddBuff(_skill.m_skillTable.index, _effect, false);
                    break;

                case e_SkillEffect.damage:
                case e_SkillEffect.piercedamage:
                    float _skillRatio = _effect.skillEffectValue + _skill.GetOptionValue(SKILLOPTION_TYPE.damage);
                    double baseDam = _owner.getData.GetStatValue(eSTAT.atk);
                    _value = GetDamValue(eSTAT.atk, baseDam, target , _effect.skillEffect == e_SkillEffect.piercedamage) * _skillRatio;

                    if (_value < 1)
                        _value = 1;

                    break;
            }

            return _value;
        }

        public void ApplyAttack(Player _player , SkillEffect _skill)
        {
            Player _target = null;
            float _dis = SkillControl.instance.GetSkillDistance(_player, _skill.m_skillTable);
            float _area = SkillControl.instance.GetSkillArea(_player, _skill.m_skillTable);

            //if (_skill.m_skillTable.skillSubType == e_SkillSubType.SWORD)
            //{
            //    if (_player.PlayerType == e_PlayerType.CHAR)
            //    {
            //        List<Player> _targetList = GameUtil.GetNearTargets(_player);
            //        _target = GameUtil.GetSectorFormTarget(_targetList, _player, 120f, _dis);
            //    }
            //    else
            //    {
            //        _target = GameUtil.IsSectorFormTarget(StagePlayLogic.instance.getUser, _player, 120f, _dis);
            //    }
            //}
            //else if (_player.BaseSkill.m_skillTable.skillSubType == e_SkillSubType.SPEAR)
            //{
            //    _target = GameUtil.GetAreaTarget(_player, _area, _dis, true);
            //}
            //else
            //{
            //    if(_player.PlayerType != e_PlayerType.CHAR)
            //        _target = StagePlayLogic.instance.getUser;
            //}

            if (_target == null)
                return;

            SkillObject _skillObj = EffectManager.instance.Play(_skill.m_skillTable.effectPath, _player.transform.position, Quaternion.identity).GetComponent<SkillObject>();
            _skillObj.Init(_skill, _target, _player , Vector2.zero);
        }

        public void ApplyHeal(Player _player)
        {
            ////�������� ���͸� ����Ѵ�
            //float _dis = SkillControl.instance.GetSkillDistance(_player, _player.BaseSkill.m_skillTable);
            //float _area = SkillControl.instance.GetSkillArea(_player, _player.BaseSkill.m_skillTable);

            //Player _target = GameUtil.GetNearTarget(_player, false, _area, true);

            ////Ÿ���� ������ ���� ��
            //if (_target == null)
            //    _target = _player;

            //_target.HpRegen((int)_player.getData.GetStatValue(eSTAT.AtkP));
            //EffectManager.instance.Play("Prefab/Effect/Heal", _target.transform).transform.localPosition = Vector3.zero;
        }

    }

}
    
