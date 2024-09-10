// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Toon Basic Ins"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_MainIns("Main Ins", Float) = 1
		_AlphaTEx("Alpha TEx", 2D) = "white" {}
		_AlphaIns("Alpha Ins", Float) = 1
		_AlphaPow("Alpha Pow", Float) = 1
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_ScrBlend_Mode("ScrBlend_ Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_DstBlend_Mode("DstBlend_ Mode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_ Mode", Float) = 0
		[Enum(Default,2,Always,6)]_ZTest_Mode("ZTest_Mode", Float) = 2
		_DissolveStep("Dissolve Step", Float) = 0.4
		[Toggle(_USESTEP_ON)] _UseStep("Use Step", Float) = 0
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma shader_feature_local _USESTEP_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float _DstBlend_Mode;
		uniform float _Cull_Mode;
		uniform float _ZTest_Mode;
		uniform float _ScrBlend_Mode;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _MainIns;
		uniform sampler2D _AlphaTEx;
		uniform float4 _AlphaTEx_ST;
		uniform float _AlphaPow;
		uniform float _AlphaIns;
		uniform sampler2D _DissolveTex;
		uniform float _DissolveUpanner;
		uniform float _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform float _Dissolve;
		uniform float _DissolveStep;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch71 = i.uv_texcoord.w;
			#else
				float staticSwitch71 = _MainIns;
			#endif
			o.Emission = ( i.vertexColor * ( _MainColor * ( tex2D( _MainTex, uvs_MainTex.xy ) * staticSwitch71 ) ) ).rgb;
			float4 uvs_AlphaTEx = i.uv_texcoord;
			uvs_AlphaTEx.xy = i.uv_texcoord.xy * _AlphaTEx_ST.xy + _AlphaTEx_ST.zw;
			float3 desaturateInitialColor12 = tex2D( _AlphaTEx, uvs_AlphaTEx.xy ).rgb;
			float desaturateDot12 = dot( desaturateInitialColor12, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar12 = lerp( desaturateInitialColor12, desaturateDot12.xxx, 0.0 );
			float3 temp_cast_2 = (_AlphaPow).xxx;
			float2 appendResult69 = (float2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner70 = ( 1.0 * _Time.y * appendResult69 + uvs_DissolveTex.xy);
			float4 tex2DNode36 = tex2D( _DissolveTex, panner70 );
			#ifdef _USECUSTOM_ON
				float staticSwitch41 = i.uv_texcoord.z;
			#else
				float staticSwitch41 = _Dissolve;
			#endif
			#ifdef _USESTEP_ON
				float staticSwitch66 = step( _DissolveStep , saturate( ( tex2DNode36.r + staticSwitch41 ) ) );
			#else
				float staticSwitch66 = ( tex2DNode36.r * staticSwitch41 );
			#endif
			float3 temp_output_43_0 = ( ( ( pow( desaturateVar12 , temp_cast_2 ) * _AlphaIns ) * i.vertexColor.a ) * staticSwitch66 );
			o.Alpha = saturate( temp_output_43_0 ).x;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;19;-1913.449,391.9895;Inherit;False;1619.911;483.8628;Alpha;8;9;12;13;14;11;15;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1864.989,447.669;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1664.912,441.9895;Inherit;True;Property;_AlphaTEx;Alpha TEx;3;0;Create;True;0;0;0;False;0;False;-1;1fa8e99e9ad59f748b7c0f1dd1b6dd1b;8dc0c836ca62d49d9add680457681437;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;42;-1360.57,933.7437;Inherit;False;947.4083;557.8956;Dissolve;8;36;37;38;40;41;62;65;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;12;-1342.44,451.6153;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1308.749,744.0067;Inherit;False;Property;_AlphaPow;Alpha Pow;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-1554.963,-252.6992;Inherit;False;1225.315;582.5255;Main;8;6;1;3;4;7;5;2;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1504.963,8.946451;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;13;-1062.082,455.2253;Inherit;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1042.83,760.8522;Inherit;False;Property;_AlphaIns;Alpha Ins;4;0;Create;True;0;0;0;False;0;False;1;3.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1038.97,983.7437;Inherit;True;Property;_DissolveTex;Dissolve Tex;6;0;Create;True;0;0;0;False;0;False;-1;1fa8e99e9ad59f748b7c0f1dd1b6dd1b;8dc0c836ca62d49d9add680457681437;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;5;-642.8276,-187.7765;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1259.963,16.94646;Inherit;True;Property;_MainTex;Main Tex;0;0;Create;True;0;0;0;False;0;False;-1;1fa8e99e9ad59f748b7c0f1dd1b6dd1b;8dc0c836ca62d49d9add680457681437;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-825.0408,450.4122;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-528.5386,450.4354;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-866.7495,48.13214;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-944.5615,-202.6993;Inherit;False;Property;_MainColor;Main Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.8867924,0.426612,0.2635279,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-632.9199,37.89141;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-7.722793,584.4918;Inherit;False;Property;_DstBlend_Mode;DstBlend_ Mode;9;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-6.234352,717.7591;Inherit;False;Property;_Cull_Mode;Cull_ Mode;10;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-491.6481,4.930496;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;18;-208.5965,228.9707;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-6.2344,822.9265;Inherit;False;Property;_ZTest_Mode;ZTest_Mode;11;1;[Enum];Create;True;0;2;Default;2;Always;6;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;-166.4548,600.8218;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1.835243,475.0385;Inherit;False;Property;_ScrBlend_Mode;ScrBlend_ Mode;8;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;35;0,0;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Toon Basic Ins;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;True;_ZTest_Mode;False;0;False;;0;False;;False;0;Transparent;0.21;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;True;_ScrBlend_Mode;10;True;_DstBlend_Mode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-671.8475,1207.338;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-361.4292,732.0305;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-670.5836,985.169;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;64;-448.6579,984.6936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-776.1302,918.5547;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;40;-1186.245,1290.639;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-1266.541,1189.725;Inherit;False;Property;_Dissolve;Dissolve;7;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-456.8402,1394.753;Inherit;False;Property;_DissolveStep;Dissolve Step;13;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;66;-99.98999,1230.781;Inherit;False;Property;_UseStep;Use Step;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;61;-321.5744,1044.709;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1546.976,998.3719;Inherit;False;0;36;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-1630.202,1210.034;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1421.693,1235.791;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1628.976,1294.664;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;70;-1284.323,1028.509;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;41;-916.2144,1269.419;Inherit;False;Property;_UseCustom;Use Custom;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1190.527,240.8262;Inherit;False;Property;_MainIns;Main Ins;2;0;Create;True;0;0;0;False;0;False;1;5.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;71;-985.8445,267.1078;Inherit;False;Property;_UseCustom;Use Custom;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
WireConnection;11;1;9;0
WireConnection;12;0;11;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;36;1;70;0
WireConnection;2;1;1;0
WireConnection;14;0;13;0
WireConnection;14;1;16;0
WireConnection;17;0;14;0
WireConnection;17;1;5;4
WireConnection;3;0;2;0
WireConnection;3;1;71;0
WireConnection;4;0;7;0
WireConnection;4;1;3;0
WireConnection;8;0;5;0
WireConnection;8;1;4;0
WireConnection;18;0;43;0
WireConnection;60;0;43;0
WireConnection;35;2;8;0
WireConnection;35;9;18;0
WireConnection;65;0;36;1
WireConnection;65;1;41;0
WireConnection;43;0;17;0
WireConnection;43;1;66;0
WireConnection;62;0;36;1
WireConnection;62;1;41;0
WireConnection;64;0;62;0
WireConnection;59;0;36;1
WireConnection;66;1;65;0
WireConnection;66;0;61;0
WireConnection;61;0;63;0
WireConnection;61;1;64;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;70;0;37;0
WireConnection;70;2;69;0
WireConnection;41;1;38;0
WireConnection;41;0;40;3
WireConnection;71;1;6;0
WireConnection;71;0;40;4
ASEEND*/
//CHKSM=BCB6DDF98943638F60AE59ECBAEFF8490B8C5AA2