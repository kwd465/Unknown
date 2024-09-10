using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
[System.Serializable]
public class FxAttachData
{
    public string path;
    public eDUMMY attach;

    public FxAttachData(string _path, eDUMMY _attach)
    {
        path = _path;
        attach = _attach;
    }
}


public class Effect : MonoBase
{
    public enum eEFFECT_KIND
    {
        pos,
        attach,
    }

    [SerializeField]
    private string m_soundPath;

    protected Transform m_parent;
    protected eEFFECT_KIND m_effectState = eEFFECT_KIND.pos;
    protected List<ParticleBase> m_particleList = new List<ParticleBase>();

    public float ActiveTime;
    private float CheckTime;
    [SerializeField]
    private SkillObject SkillObj;

    public SkillObject GetSkillObj => SkillObj;
    

    private void Awake()
    {
        AwakeLogic();
        if(SkillObj == null)
            SkillObj = GetComponent<SkillObject>();
    }

    protected virtual void AwakeLogic()
    {
        ParticleSystem[] particles
            = gameObject.GetComponentsInChildren<ParticleSystem>();
        for (int i = 0; i < particles.Length; ++i)
        {
            m_particleList.Add(new Particle_particleSystem(particles[i]));
        }

        Animation[] animations = gameObject.GetComponentsInChildren<Animation>();
        for (int i = 0; i < animations.Length; ++i)
        {
            m_particleList.Add(new Particle_animation(animations[i]));
        }

        Spine.Unity.SkeletonAnimation[] spineAnimations
        = gameObject.GetComponentsInChildren<Spine.Unity.SkeletonAnimation>();
        for (int i = 0; i < spineAnimations.Length; ++i)
        {
            m_particleList.Add(new Particle_spineAnimation(spineAnimations[i]));
        }

        Spine.Unity.SkeletonGraphic[] spineGraphics
            = gameObject.GetComponentsInChildren<Spine.Unity.SkeletonGraphic>();
        for (int i = 0; i < spineGraphics.Length; ++i)
        {
            m_particleList.Add(new Particle_spineGrapthic(spineGraphics[i]));
        }

#if USE_SPINE
        Spine.Unity.SkeletonAnimation[] spineAnimations 
            = gameObject.GetComponentsInChildren<Spine.Unity.SkeletonAnimation>();
        for (int i = 0; i < spineAnimations.Length; ++i)
        {
            m_particleList.Add(new Particle_spineAnimation(spineAnimations[i]));
        }
#endif
    }

    public virtual void Play(Vector3 _pos, Quaternion _rot, float _size, bool _loop = false)
    {
        CheckTime = 0;
        m_effectState = eEFFECT_KIND.pos;
        transform.localScale = Vector3.one * _size;
        transform.position = _pos;
        transform.rotation = _rot;

        if(string.IsNullOrEmpty(m_soundPath) == false)
            SoundControl.Play(m_soundPath);
        for (int i = 0; i < m_particleList.Count; ++i)
        {
            m_particleList[i].SetSize(_size);
            m_particleList[i].Play(_loop);
        }


    }

    public virtual void Play(Transform _parent, float _size, bool _loop = false)
    {
        CheckTime = 0;
        m_effectState = eEFFECT_KIND.attach;

        
        //transform.localPosition = Vector3.zero;
        //transform.localRotation = Quaternion.identity;
        m_parent = _parent;
        if (string.IsNullOrEmpty(m_soundPath) == false)
            SoundControl.Play(m_soundPath);
        if (null != m_parent)
        {
            transform.SetParent(m_parent);
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
        }

        transform.localScale = Vector3.one * _size;

        for (int i = 0; i < m_particleList.Count; ++i)
        {
            m_particleList[i].SetSize(_size);
            m_particleList[i].Play(_loop);
        }
    }

    public void Play(string _aniName, bool _loop)
    {
        CheckTime = 0;
        if (string.IsNullOrEmpty(m_soundPath) == false)
            SoundControl.Play(m_soundPath);
        for (int i = 0; i < m_particleList.Count; ++i)
        {
            m_particleList[i].Play(_aniName, _loop);
        }

    }

    public override void UpdateLogic()
    {
        if (m_effectState == eEFFECT_KIND.attach)
        {
            if (m_parent == null || m_parent.gameObject.activeInHierarchy == false)
            {
                Close();
                return;
            }
        }

        if(ActiveTime > 0)
        {
            if (CheckTime >= ActiveTime)
                Close();
            else
            {
                CheckTime += Time.deltaTime;
               
            }
        }

        if (IsStop())
            Close();
        else
        {
            if (SkillObj != null)
                SkillObj.UpdateLogic();
        }

    }

    public bool IsStop()
    {
        if(ActiveTime == 0)
            return false;

        if (ActiveTime > 0 && CheckTime < ActiveTime)
            return false;

        if (m_particleList.Count == 0)
            return false;

        for (int i = 0; i < m_particleList.Count; ++i)
        {
            if (false == m_particleList[i].IsStop())
                return false;
        }

        return true;
    }
    public void SetSpeed(float _speed)
    {
        for (int i = 0; i < m_particleList.Count; ++i)
        {
            m_particleList[i].SetSpeed(_speed);
        }
    }
    public override void Close()
    {
        base.Close();
        SkillObj?.Close();

        if (m_effectState == eEFFECT_KIND.attach)
        {
            transform.parent = EffectManager.instance.transform;
        }
    }
}
