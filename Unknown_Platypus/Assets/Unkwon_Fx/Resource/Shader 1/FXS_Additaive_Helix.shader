// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Addive_Helix"
{
	Properties
	{
		_FXT_Helix01("FXT_Helix01", 2D) = "white" {}
		_Helix_Offset("Helix_Offset", Range( -1 , 1)) = 0.3529412
		_Mask_Radius("Mask_Radius", Range( 1 , 10)) = 1
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Helix_Pow("Helix_Pow", Range( 1 , 10)) = 1
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.BlendMode)]_Str_BlendMode("Str_Blend Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 1
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Float) = 0
		[Enum(Defult,2,Always,6)]_ZTest_Mode("ZTest_Mode", Float) = 0
		_HelixIns("Helix Ins", Float) = 0
		_Opactiy("Opactiy", Float) = 0
		_Dissovle("Dissovle", Range( -1 , 1)) = 0
		_Step("Step", Float) = 0
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		[Toggle(_STEPSW_ON)] _StepSw("Step Sw", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma shader_feature_local _STEPSW_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform half _Str_BlendMode;
		uniform half _Dst_BlendMode;
		uniform half _Cull_Mode;
		uniform half _ZTest_Mode;
		uniform sampler2D _FXT_Helix01;
		uniform float4 _FXT_Helix01_ST;
		uniform float _Helix_Offset;
		uniform float _Mask_Radius;
		uniform half _HelixIns;
		uniform float _Helix_Pow;
		uniform sampler2D _DissolveTex;
		uniform half _DissolveUpanner;
		uniform half _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform half _Dissovle;
		uniform half _Step;
		uniform float4 _Tint_Color;
		uniform half _Opactiy;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_FXT_Helix01 = i.uv_texcoord;
			uvs_FXT_Helix01.xy = i.uv_texcoord.xy * _FXT_Helix01_ST.xy + _FXT_Helix01_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch19 = i.uv_texcoord.z;
			#else
				float staticSwitch19 = _Helix_Offset;
			#endif
			half2 appendResult3 = (half2(( uvs_FXT_Helix01.xy.x + staticSwitch19 ) , uvs_FXT_Helix01.xy.y));
			half2 appendResult43 = (half2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			half2 panner44 = ( 1.0 * _Time.y * appendResult43 + uvs_DissolveTex.xy);
			#ifdef _USE_CUSTOM_ON
				half staticSwitch48 = i.uv_texcoord.w;
			#else
				half staticSwitch48 = _Dissovle;
			#endif
			half temp_output_46_0 = ( 1.0 - ( tex2D( _DissolveTex, panner44 ).r + staticSwitch48 ) );
			#ifdef _STEPSW_ON
				half staticSwitch47 = _Step;
			#else
				half staticSwitch47 = temp_output_46_0;
			#endif
			half temp_output_24_0 = ( saturate( pow( ( ( tex2D( _FXT_Helix01, appendResult3 ).r * saturate( pow( ( ( ( 1.0 - i.uv_texcoord.xy.x ) * i.uv_texcoord.xy.x ) * 4.0 ) , _Mask_Radius ) ) ) * _HelixIns ) , _Helix_Pow ) ) * step( temp_output_46_0 , staticSwitch47 ) );
			o.Emission = ( i.vertexColor * ( temp_output_24_0 * _Tint_Color ) ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( ( temp_output_24_0 * _Opactiy ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;36;-1835.688,-745.3386;Inherit;False;2125.944;1071.765;Helix;19;6;5;20;7;2;19;8;9;11;4;10;3;21;1;18;29;30;13;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;31;262.338,-102.753;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1362.748,-225.7493;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Addive_Helix;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;;0;True;_ZTest_Mode;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;_Str_BlendMode;10;False;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;25;1320.38,284.1078;Inherit;False;Property;_Str_BlendMode;Str_Blend Mode;7;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;1331.734,393.1122;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;8;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1315.838,504.3875;Inherit;False;Property;_Cull_Mode;Cull_Mode;9;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;1318.109,599.7663;Inherit;False;Property;_ZTest_Mode;ZTest_Mode;10;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1183.742,-179.0578;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;16;861.2007,-237.4627;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;765.4701,1.986406;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;399.862,83.69489;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1039.244,199.05;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1556.018,2.577667;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1785.688,-326.3388;Float;False;Property;_Helix_Offset;Helix_Offset;1;0;Create;True;0;0;0;False;0;False;0.3529412;-0.71;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;20;-1748.947,-196.445;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;-1238.018,-28.42231;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1476.688,-695.3386;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1090.018,-23.42233;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-878.8177,-20.29303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-930.9722,180.8291;Float;False;Property;_Mask_Radius;Mask_Radius;2;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-1159.688,-319.3388;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;10;-717.8313,-19.29312;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-957.6888,-537.3387;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;21;-429.9478,104.555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-751.4339,-295.2098;Inherit;True;Property;_FXT_Helix01;FXT_Helix01;0;0;Create;True;0;0;0;False;0;False;-1;5963adf3d4119ad4d98d9887a5b77235;3c9ead062f99f4fa8bb3ee7b81663101;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-427.8573,-151.6799;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-198.7366,-149.0955;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-273.1437,111.3288;Inherit;False;Property;_HelixIns;Helix Ins;11;0;Create;True;0;0;0;False;0;False;0;2.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-239.5158,211.4264;Float;False;Property;_Helix_Pow;Helix_Pow;4;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;30.25627,-124.8919;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;580.4921,405.6994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;734.2297,366.9098;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;413.227,518.7852;Inherit;False;Property;_Opactiy;Opactiy;12;0;Create;True;0;0;0;False;0;False;0;1.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-299.7129,443.0407;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1185.553,573.3343;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;15;0;Create;True;0;0;0;False;0;False;0;-0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-949.5612,609.0907;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1186.984,677.743;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;44;-843.5249,462.5714;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;-655.2466,422.1855;Inherit;True;Property;_DissolveTex;Dissolve Tex;6;0;Create;True;0;0;0;False;0;False;-1;None;0455e395e2f4f401ea64cdd26c499ac2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1167.422,404.421;Inherit;False;0;22;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-271.5096,749.3535;Inherit;False;Property;_Step;Step;14;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;39;103.3462,469.2905;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;-91.72471,422.4753;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;47;-115.114,674.1893;Inherit;False;Property;_StepSw;Step Sw;17;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;19;-1472.948,-227.445;Float;False;Property;_Use_Custom;Use_Custom;3;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;48;-578.6509,770.8731;Inherit;False;Property;_Use_Custom;Use_Custom;18;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-767.4464,642.4216;Inherit;False;Property;_Dissovle;Dissovle;13;0;Create;True;0;0;0;False;0;False;0;0.34;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;550.5381,-234.9819;Float;False;Property;_Tint_Color;Tint_Color;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,0.5039797,0.240566,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;31;0;12;0
WireConnection;0;2;17;0
WireConnection;0;9;34;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;14;0;24;0
WireConnection;14;1;15;0
WireConnection;24;0;31;0
WireConnection;24;1;39;0
WireConnection;34;0;16;4
WireConnection;34;1;35;0
WireConnection;7;0;6;1
WireConnection;8;0;7;0
WireConnection;8;1;6;1
WireConnection;9;0;8;0
WireConnection;4;0;2;1
WireConnection;4;1;19;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;3;0;4;0
WireConnection;3;1;2;2
WireConnection;21;0;10;0
WireConnection;1;1;3;0
WireConnection;18;0;1;1
WireConnection;18;1;21;0
WireConnection;29;0;18;0
WireConnection;29;1;30;0
WireConnection;12;0;29;0
WireConnection;12;1;13;0
WireConnection;32;0;24;0
WireConnection;32;1;33;0
WireConnection;35;0;32;0
WireConnection;37;0;22;1
WireConnection;37;1;48;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;44;0;23;0
WireConnection;44;2;43;0
WireConnection;22;1;44;0
WireConnection;39;0;46;0
WireConnection;39;1;47;0
WireConnection;46;0;37;0
WireConnection;47;1;46;0
WireConnection;47;0;40;0
WireConnection;19;1;5;0
WireConnection;19;0;20;3
WireConnection;48;1;38;0
WireConnection;48;0;20;4
ASEEND*/
//CHKSM=C27EA634D74A58590CC5F11F12638587EB79974D