using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using BH;
using Unity.VisualScripting;
using UnityEditor.Build.Content;

public class EditorTool : EditorWindow
{
    [MenuItem("Tool/GameCheat")]
    static void Init()
    {
        EditorWindow.GetWindow<EditorTool>(false, "GameCheat");
    }


    private void OnGUI()
    {

        GUILayout.Label("무적은  게임 플레이중에 사용이 불가능 합니다.");
        if (!Application.isPlaying)
        {
          
            #if NO_DIE
            if(GUILayout.Button("캐릭터 무적해제"))
            {
                var buildTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
                PlayerSettings.SetScriptingDefineSymbolsForGroup(buildTargetGroup, $"DOTWEEN;LOCAL_DATA;DEBUG_LOG;AMPLIFY_SHADER_EDITOR");

            }
            #else
            if(GUILayout.Button("캐릭터 무적"))
            {
                var buildTargetGroup = EditorUserBuildSettings.selectedBuildTargetGroup;
                PlayerSettings.SetScriptingDefineSymbolsForGroup(buildTargetGroup, $"DOTWEEN;LOCAL_DATA;DEBUG_LOG;AMPLIFY_SHADER_EDITOR;NO_DIE");

            }
            #endif
        }

        if (!Application.isPlaying)
        {
            GUILayout.Label("스킬 치트는 게임 플레이중에 사용가능합니다.");
            return;
        }

        if(SceneManager.GetActiveScene().name != "Game")
        {
            GUILayout.Label("스킬 치트는 인게임 씬에서만 사용가능합니다.");
            return;
        }

        GUILayout.Label("스킬 획득및 레벨업");
        GUILayout.Space(10);


        List<SkillGroupData> _List = TableControl.instance.m_skillTable.GetSkillGroupList(e_SkillType.InGameSkill);
        var m_haveSkillList = StagePlayLogic.instance.m_Player.GetInGameSkill();
        for (int i = 0; i < _List.Count;i++)
        {
            if (GUILayout.Button("Skill :" + _List[i].m_skillList[0].skillName.ToLocalize(), GUI.skin.button))
            {
                
                SkillTableData _haveSkill = m_haveSkillList.Find(item => item.group == _List[i].m_group);
                if (_haveSkill != null)
                {
                    
                    if (_haveSkill.skilllv == 4)
                        continue;


                    StagePlayLogic.instance.m_Player.SetSkill(_List[i].m_skillList[_haveSkill.skilllv]);
                }
                else
                {
                    StagePlayLogic.instance.m_Player.SetSkill(_List[i].m_skillList[0]);
                }
            }
        }
    }
}
