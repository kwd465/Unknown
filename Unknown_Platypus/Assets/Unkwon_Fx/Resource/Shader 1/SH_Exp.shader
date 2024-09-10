// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/SH_Exp"
{
	Properties
	{
		_NoiseUpanner("Noise Upanner", Float) = 0
		_NoiseVpanner("Noise Vpanner", Float) = -0.5
		_NoiseTex("Noise Tex", 2D) = "bump" {}
		_NoiseStr("Noise Str", Float) = 0.25
		_ColorRangeVal("ColorRange Val", Float) = 0
		_HighStep("High Step", Float) = 1.1
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		[HDR]_BaseAColor("BaseA Color", Color) = (1,0.6487261,0.1650943,0)
		[HDR]_HighColor("High Color", Color) = (1,0.7742941,0.495283,0)
		[HDR]_BaseBColor("BaseB Color", Color) = (0.3301887,0.08298262,0,0)
		[HDR]_ShadowColor("Shadow Color", Color) = (0.4716981,0.09241393,0,0)
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_SubTex("Sub Tex", 2D) = "white" {}
		_SubVal("Sub Val", Float) = 0.5
		_Dissolve("Dissolve", Range( -1 , 1)) = 1
		_Smooth("Smooth", Float) = 0.01
		_BaseStep("Base Step", Float) = 0.68
		[Toggle(_USECUSTOM1_ON)] _UseCustom1("Use Custom", Float) = 0
		_ShadowStep("Shadow Step", Float) = 0.68
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma shader_feature_local _USECUSTOM1_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv2_texcoord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _HighColor;
		uniform float4 _BaseAColor;
		uniform float _HighStep;
		uniform sampler2D _NoiseTex;
		uniform float _NoiseUpanner;
		uniform float _NoiseVpanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseStr;
		uniform float _ColorRangeVal;
		uniform sampler2D _SubTex;
		uniform float4 _SubTex_ST;
		uniform float _SubVal;
		uniform float4 _BaseBColor;
		uniform float _BaseStep;
		uniform float4 _ShadowColor;
		uniform float _ShadowStep;
		uniform float _Dissolve;
		uniform float _Smooth;
		uniform sampler2D _DissolveTex;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			#ifdef _USECUSTOM_ON
				float staticSwitch22 = i.uv2_texcoord2.x;
			#else
				float staticSwitch22 = _HighStep;
			#endif
			float2 appendResult5 = (float2(_NoiseUpanner , _NoiseVpanner));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner6 = ( 1.0 * _Time.y * appendResult5 + uv_NoiseTex);
			float2 uv_SubTex = i.uv_texcoord * _SubTex_ST.xy + _SubTex_ST.zw;
			float2 panner35 = ( 1.0 * _Time.y * appendResult5 + uv_SubTex);
			float temp_output_19_0 = ( saturate( ( (( ( (UnpackNormal( tex2D( _NoiseTex, panner6 ) )).xy * _NoiseStr ) + i.uv_texcoord )).y + _ColorRangeVal ) ) * saturate( ( tex2D( _SubTex, panner35 ).r + _SubVal ) ) );
			float4 lerpResult23 = lerp( _HighColor , _BaseAColor , step( staticSwitch22 , temp_output_19_0 ));
			#ifdef _USECUSTOM_ON
				float staticSwitch56 = i.uv2_texcoord2.y;
			#else
				float staticSwitch56 = _BaseStep;
			#endif
			float4 lerpResult26 = lerp( lerpResult23 , _BaseBColor , step( staticSwitch56 , temp_output_19_0 ));
			#ifdef _USECUSTOM1_ON
				float staticSwitch58 = i.uv2_texcoord2.z;
			#else
				float staticSwitch58 = _ShadowStep;
			#endif
			float4 lerpResult29 = lerp( lerpResult26 , _ShadowColor , step( staticSwitch58 , temp_output_19_0 ));
			o.Emission = ( lerpResult29 * i.vertexColor ).rgb;
			#ifdef _USECUSTOM_ON
				float staticSwitch48 = i.uv2_texcoord2.w;
			#else
				float staticSwitch48 = _Dissolve;
			#endif
			float temp_output_49_0 = ( 1.0 - staticSwitch48 );
			float2 panner44 = ( 1.0 * _Time.y * appendResult5 + i.uv_texcoord);
			float smoothstepResult46 = smoothstep( temp_output_49_0 , ( temp_output_49_0 + _Smooth ) , tex2D( _DissolveTex, panner44 ).r);
			o.Alpha = ( i.vertexColor.a * smoothstepResult46 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
24;101;1658;785;3420.794;865.4132;2.801778;True;False
Node;AmplifyShaderEditor.CommentaryNode;42;-3441.625,-356.8748;Inherit;False;1599.368;520.0601;Comment;11;4;3;6;5;11;12;10;13;14;9;2;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-3391.625,-143.0748;Inherit;False;Property;_NoiseUpanner;Noise Upanner;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3389.025,-61.17483;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;2;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-3348.725,-306.8748;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-3195.324,-157.3749;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;6;-3078.323,-282.1748;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-2883.323,-291.2748;Inherit;True;Property;_NoiseTex;Noise Tex;3;0;Create;True;0;0;0;False;0;False;-1;583d109e49600b04382baffd4f84435d;583d109e49600b04382baffd4f84435d;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;41;-3352.092,295.3698;Inherit;False;1233.45;545.8376;Comment;6;35;37;34;39;38;40;Sub Tex;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2531.019,-88.47467;Inherit;False;Property;_NoiseStr;Noise Str;4;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-2576.521,-293.8747;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-3302.092,357.8361;Inherit;False;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2313.92,-300.3747;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2444.508,4.185232;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;43;-1700.698,-771.1198;Inherit;False;2213.231;1151.399;Comment;23;15;17;16;18;19;20;21;22;25;24;23;27;26;28;30;31;32;33;29;55;56;57;58;Lerp Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-2077.257,-294.4767;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-3010.021,366.7405;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2792.967,537.7092;Inherit;False;Property;_SubVal;Sub Val;14;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;-1651.698,-244.8134;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1634.58,-111.8596;Inherit;False;Property;_ColorRangeVal;ColorRange Val;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-2835.491,345.3698;Inherit;True;Property;_SubTex;Sub Tex;13;0;Create;True;0;0;0;False;0;False;-1;b51cea59eeae705458cee17bc33f9605;b51cea59eeae705458cee17bc33f9605;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2534.991,351.8929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1427.58,-168.8596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1247.144,-424.7401;Inherit;False;Property;_HighStep;High Step;6;0;Create;True;0;0;0;False;0;False;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;-1293.58,-170.8596;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;54;-1632.013,656.5906;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;53;-945.3433,536.215;Inherit;False;1118.718;485.9802;Comment;9;36;44;45;48;47;46;50;49;51;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;40;-2316.642,360.7145;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;22;-1063.626,-395.8497;Inherit;False;Property;_UseCustom;Use Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1105.58,-169.8596;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-706.2264,800.1949;Inherit;False;Property;_Dissolve;Dissolve;15;0;Create;True;0;0;0;False;0;False;1;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-894.5389,93.21999;Inherit;False;Property;_BaseStep;Base Step;17;0;Create;True;0;0;0;False;0;False;0.68;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;56;-682.6151,108.1209;Inherit;False;Property;_UseCustom;Use Custom;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;48;-448.2262,797.1949;Inherit;False;Property;_UseCustom;Use Custom;16;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-895.3433,621.866;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;20;-818.1591,-321.7921;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-661.0894,247.1961;Inherit;False;Property;_ShadowStep;Shadow Step;19;0;Create;True;0;0;0;False;0;False;0.68;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-782.9982,-520.9171;Inherit;False;Property;_BaseAColor;BaseA Color;8;1;[HDR];Create;True;0;0;0;False;0;False;1,0.6487261,0.1650943,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-781.7391,-721.1198;Inherit;False;Property;_HighColor;High Color;9;1;[HDR];Create;True;0;0;0;False;0;False;1,0.7742941,0.495283,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-290.226,906.1951;Inherit;False;Property;_Smooth;Smooth;16;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;28;-390.144,-67.62773;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-490.8758,-256.4977;Inherit;False;Property;_BaseBColor;BaseB Color;10;1;[HDR];Create;True;0;0;0;False;0;False;0.3301887,0.08298262,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;49;-227.2261,798.1949;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;58;-460.7553,270.375;Inherit;False;Property;_UseCustom1;Use Custom;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;44;-644.6996,643.0618;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;23;-526.1337,-475.5882;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;-218.9021,-422.7036;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-77.22628,845.1949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;31;-176.09,126.2787;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-188.6809,-158.2859;Inherit;False;Property;_ShadowColor;Shadow Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0.4716981,0.09241393,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-444.0332,586.215;Inherit;True;Property;_DissolveTex;Dissolve Tex;12;0;Create;True;0;0;0;False;0;False;-1;510e540f101fe1b40a249ea89af8efee;510e540f101fe1b40a249ea89af8efee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;55.85696,-177.6698;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;46;-15.62486,610.4355;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;33;149.829,69.9845;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;350.5338,-154.4879;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;265.3076,503.1401;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;597.8458,-34.6096;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/SH_Exp;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;0;2;0
WireConnection;6;2;5;0
WireConnection;9;1;6;0
WireConnection;10;0;9;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;35;0;34;0
WireConnection;35;2;5;0
WireConnection;15;0;13;0
WireConnection;37;1;35;0
WireConnection;38;0;37;1
WireConnection;38;1;39;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;18;0;16;0
WireConnection;40;0;38;0
WireConnection;22;1;21;0
WireConnection;22;0;54;1
WireConnection;19;0;18;0
WireConnection;19;1;40;0
WireConnection;56;1;55;0
WireConnection;56;0;54;2
WireConnection;48;1;47;0
WireConnection;48;0;54;4
WireConnection;20;0;22;0
WireConnection;20;1;19;0
WireConnection;28;0;56;0
WireConnection;28;1;19;0
WireConnection;49;0;48;0
WireConnection;58;1;57;0
WireConnection;58;0;54;3
WireConnection;44;0;45;0
WireConnection;44;2;5;0
WireConnection;23;0;24;0
WireConnection;23;1;25;0
WireConnection;23;2;20;0
WireConnection;26;0;23;0
WireConnection;26;1;27;0
WireConnection;26;2;28;0
WireConnection;50;0;49;0
WireConnection;50;1;51;0
WireConnection;31;0;58;0
WireConnection;31;1;19;0
WireConnection;36;1;44;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;29;2;31;0
WireConnection;46;0;36;1
WireConnection;46;1;49;0
WireConnection;46;2;50;0
WireConnection;32;0;29;0
WireConnection;32;1;33;0
WireConnection;52;0;33;4
WireConnection;52;1;46;0
WireConnection;0;2;32;0
WireConnection;0;9;52;0
ASEEND*/
//CHKSM=17D228FE5403043D23DD7CEB80D9927863ED2CC1