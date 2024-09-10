// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Water Mesh"
{
	Properties
	{
		_NoiseTexA("Noise Tex A", 2D) = "white" {}
		_NoiseAUpanner("Noise A Upanner", Float) = 0
		_NoiseAVpanner("Noise A Vpanner", Float) = -0.5
		[HDR]_NoiseColorA("Noise Color A", Color) = (0.08036668,0.472275,0.8113208,0)
		_NoiseAIns("Noise A Ins", Float) = 1
		_Thinkness_Out("Thinkness_Out", Float) = 0.34
		_NoiseTexB("Noise Tex B", 2D) = "white" {}
		_NoiseVal("Noise Val", Float) = 0.35
		_NoiseBUpanner("Noise B Upanner", Float) = 0
		_NoiseBVpanner("Noise B Vpanner", Float) = -0.25
		[HDR]_NoiseColorB("Noise Color B", Color) = (1,0,0,0)
		_NoiseBIns("Noise B Ins", Float) = 0.25
		_Thinkness_In("Thinkness_In", Float) = 0.57
		_HeadNoiseTex("Head Noise Tex", 2D) = "bump" {}
		_HeadNoiseUpanner("Head Noise Upanner", Float) = 0
		_HeadNoiseVpanner("Head Noise Vpanner", Float) = 0
		_StepA("Step A", Float) = 1
		_StepB("Step B", Float) = 0.61
		[HDR]_ColorA("Color A", Color) = (0,0.3767396,0.9528302,1)
		[HDR]_ColorB("Color B", Color) = (1,1,1,1)
		_ShadowOffset("Shadow Offset", Float) = 0.09
		_Shadow("Shadow", Float) = 0.98
		_ShadowColorA("Shadow Color A", Color) = (1,1,1,0)
		_ShadowColorB("Shadow Color B", Color) = (0.5754717,0.5754717,0.5754717,0)
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		_EdgeMaskPow("Edge Mask Pow", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 0
		[Enum(Defult,2,Always,6)]_ZTestMode("ZTest Mode", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USECUSTOM_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float _Dst_BlendMode;
		uniform float _CullMode;
		uniform float _Src_BlendMode;
		uniform float _ZTestMode;
		uniform float4 _ShadowColorA;
		uniform float4 _ShadowColorB;
		uniform float _Shadow;
		uniform sampler2D _HeadNoiseTex;
		uniform float _HeadNoiseUpanner;
		uniform float _HeadNoiseVpanner;
		uniform float4 _HeadNoiseTex_ST;
		uniform float _NoiseVal;
		uniform float _ShadowOffset;
		uniform float4 _ColorB;
		uniform float4 _ColorA;
		uniform float _StepA;
		uniform float _StepB;
		uniform float4 _NoiseColorA;
		uniform float _Thinkness_Out;
		uniform sampler2D _NoiseTexA;
		uniform float _NoiseAUpanner;
		uniform float _NoiseAVpanner;
		uniform float4 _NoiseTexA_ST;
		uniform float _NoiseAIns;
		uniform float4 _NoiseColorB;
		uniform float _Thinkness_In;
		uniform sampler2D _NoiseTexB;
		uniform float _NoiseBUpanner;
		uniform float _NoiseBVpanner;
		uniform float4 _NoiseTexB_ST;
		uniform float _NoiseBIns;
		uniform sampler2D _DissolveTex;
		uniform float _DissolveUpanner;
		uniform float _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform float _Dissolve;
		uniform float _EdgeMaskPow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult88 = (float2(_HeadNoiseUpanner , _HeadNoiseVpanner));
			float4 uvs_HeadNoiseTex = i.uv_texcoord;
			uvs_HeadNoiseTex.xy = i.uv_texcoord.xy * _HeadNoiseTex_ST.xy + _HeadNoiseTex_ST.zw;
			float2 panner89 = ( 1.0 * _Time.y * appendResult88 + uvs_HeadNoiseTex.xy);
			float temp_output_37_0 = (( ( (UnpackNormal( tex2D( _HeadNoiseTex, panner89 ) )).xy * _NoiseVal ) + i.uv_texcoord.xy )).y;
			float temp_output_81_0 = ( temp_output_37_0 - _ShadowOffset );
			float4 lerpResult77 = lerp( _ShadowColorA , _ShadowColorB , step( _Shadow , ( ( temp_output_81_0 * ( 1.0 - temp_output_81_0 ) ) * 4.0 ) ));
			float4 lerpResult40 = lerp( _ColorB , _ColorA , step( temp_output_37_0 , _StepA ));
			float temp_output_43_0 = step( temp_output_37_0 , _StepB );
			float4 temp_cast_0 = (_Thinkness_Out).xxxx;
			float2 appendResult12 = (float2(_NoiseAUpanner , _NoiseAVpanner));
			float4 uvs_NoiseTexA = i.uv_texcoord;
			uvs_NoiseTexA.xy = i.uv_texcoord.xy * _NoiseTexA_ST.xy + _NoiseTexA_ST.zw;
			float2 panner11 = ( 1.0 * _Time.y * appendResult12 + uvs_NoiseTexA.xy);
			float4 temp_cast_1 = (_Thinkness_In).xxxx;
			float2 appendResult51 = (float2(_NoiseBUpanner , _NoiseBVpanner));
			float4 uvs_NoiseTexB = i.uv_texcoord;
			uvs_NoiseTexB.xy = i.uv_texcoord.xy * _NoiseTexB_ST.xy + _NoiseTexB_ST.zw;
			float2 panner52 = ( 1.0 * _Time.y * appendResult51 + uvs_NoiseTexB.xy);
			o.Emission = ( i.vertexColor * ( lerpResult77 * ( ( lerpResult40 + ( 1.0 - temp_output_43_0 ) ) + saturate( ( ( _NoiseColorA * ( step( temp_cast_0 , tex2D( _NoiseTexA, panner11 ) ) * _NoiseAIns ) ) + ( _NoiseColorB * ( step( temp_cast_1 , tex2D( _NoiseTexB, panner52 ) ) * _NoiseBIns ) ) ) ) ) ) ).rgb;
			float2 appendResult116 = (float2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner113 = ( 1.0 * _Time.y * appendResult116 + uvs_DissolveTex.xy);
			#ifdef _USECUSTOM_ON
				float staticSwitch125 = i.uv_texcoord.z;
			#else
				float staticSwitch125 = _Dissolve;
			#endif
			float temp_output_28_0 = pow( ( ( ( 1.0 - i.uv_texcoord.xy.x ) * i.uv_texcoord.xy.x ) * 4.0 ) , _EdgeMaskPow );
			o.Alpha = ( i.vertexColor.a * ( ( ( temp_output_43_0 * step( ( 1.0 - temp_output_37_0 ) , 0.92 ) ) * step( 1.0 , ( tex2D( _DissolveTex, panner113 ).r + staticSwitch125 ) ) ) * saturate( temp_output_28_0 ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;107;-4721.271,-1337.765;Inherit;False;3767.128;1908.756;Color;36;111;110;109;43;108;45;44;77;75;78;79;76;74;73;68;81;82;86;84;85;89;88;87;99;103;104;105;101;46;40;42;38;41;39;37;123;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4647.271,-602.4921;Inherit;False;Property;_HeadNoiseVpanner;Head Noise Vpanner;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-4641.412,-690.8935;Inherit;False;Property;_HeadNoiseUpanner;Head Noise Upanner;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-4434.271,-661.4921;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-4651.245,-869.0153;Inherit;False;0;85;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;89;-4314.271,-759.4921;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3471.395,-2641.798;Inherit;False;2470.765;1199.955;Noise;10;60;59;70;69;71;64;66;72;61;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-3413.659,-2591.798;Inherit;False;1260.794;569.4784;Noise A;9;12;11;10;9;48;49;8;13;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-3421.395,-1987.058;Inherit;False;1260.794;527.0488;Noise B;9;51;52;53;54;55;57;58;56;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;85;-4071.146,-766.7023;Inherit;True;Property;_HeadNoiseTex;Head Noise Tex;13;0;Create;True;0;0;0;False;0;False;-1;ca13f4c0cd8f4eb4fb22f7b62e6e0d7e;ca13f4c0cd8f4eb4fb22f7b62e6e0d7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-3343.926,-2137.32;Inherit;False;Property;_NoiseAVpanner;Noise A Vpanner;2;0;Create;True;0;0;0;False;0;False;-0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3811.803,-480.0161;Inherit;False;Property;_NoiseVal;Noise Val;7;0;Create;True;0;0;0;False;0;False;0.35;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;99;-3749.576,-768.4566;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3351.662,-1575.009;Inherit;False;Property;_NoiseBVpanner;Noise B Vpanner;9;0;Create;True;0;0;0;False;0;False;-0.25;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3336.751,-2268.276;Inherit;False;Property;_NoiseAUpanner;Noise A Upanner;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3345.487,-1705.965;Inherit;False;Property;_NoiseBUpanner;Noise B Upanner;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-3371.395,-1869.211;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-3363.659,-2431.523;Inherit;False;0;13;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;51;-3150.743,-1666.499;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-3143.007,-2228.81;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-3584.053,-492.0554;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-3481.054,-754.055;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;122;-3132.77,672.8438;Inherit;False;1452.164;582.1392;Dissolve;11;113;114;116;115;112;117;118;119;121;120;125;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;52;-3001.847,-1795.661;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-3185.849,-649.2266;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-2994.111,-2357.972;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;35;-3248.12,1412.117;Inherit;False;1606.132;728.7659;Edge Mssk;13;34;22;23;26;27;28;25;24;29;30;31;32;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;13;-2780.635,-2383.087;Inherit;True;Property;_NoiseTexA;Noise Tex A;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-2649.858,-1937.058;Inherit;False;Property;_Thinkness_In;Thinkness_In;12;0;Create;True;0;0;0;False;0;False;0.57;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-3079.292,1139.983;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;37;-2915.527,-644.6174;Inherit;True;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-2788.371,-1820.776;Inherit;True;Property;_NoiseTexB;Noise Tex B;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-2664.245,-2503.695;Inherit;False;Property;_Thinkness_Out;Thinkness_Out;5;0;Create;True;0;0;0;False;0;False;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2857.219,185.5968;Inherit;False;Property;_ShadowOffset;Shadow Offset;20;0;Create;True;0;0;0;False;0;False;0.09;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-3082.77,1053.624;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-3075.867,865.4731;Inherit;False;0;117;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-2578.447,103.1168;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2412.376,-1575.804;Inherit;False;Property;_NoiseBIns;Noise B Ins;11;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-3174.859,1505.366;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-2381.4,-2146.718;Inherit;False;Property;_NoiseAIns;Noise A Ins;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-2810.856,1110.306;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;55;-2467.601,-1830.439;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;48;-2434.57,-2391.521;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2252.376,-1832.804;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2630.082,1113.356;Inherit;False;Property;_Dissolve;Dissolve;26;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;-2243.422,-2571.816;Inherit;False;Property;_NoiseColorA;Noise Color A;3;1;[HDR];Create;True;0;0;0;False;0;False;0.08036668,0.472275,0.8113208,0;0.08036668,0.472275,0.8113208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-2283.831,-589.0431;Inherit;False;Property;_StepB;Step B;17;0;Create;True;0;0;0;False;0;False;0.61;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2338.773,-793.0287;Inherit;False;Property;_StepA;Step A;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-2913.855,1462.117;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-2225.045,-2035.749;Inherit;False;Property;_NoiseColorB;Noise Color B;10;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-2218.185,-2383.012;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;113;-2691.182,900.9453;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;68;-2321.531,158.278;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;126;-2595.832,1201.582;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-2492.582,873.908;Inherit;True;Property;_DissolveTex;Dissolve Tex;24;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;125;-2280.398,1163.889;Inherit;False;Property;_UseCustom;Use Custom;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-2106.204,-1101.711;Inherit;False;Property;_ColorA;Color A;18;1;[HDR];Create;True;0;0;0;False;0;False;0,0.3767396,0.9528302,1;0,0.3767396,0.9528302,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1897.368,-1827.135;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1882.053,-2379.54;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;42;-2112.547,-1287.765;Inherit;False;Property;_ColorB;Color B;19;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;43;-2045.144,-633.8321;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;108;-2397.005,-354.1731;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2098.334,98.9488;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2756.855,1484.117;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-2376.742,-120.2281;Inherit;False;Constant;_Float4;Float 4;28;0;Create;True;0;0;0;False;0;False;0.92;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-2121.004,-915.6557;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2087.824,722.8438;Inherit;False;Constant;_Float6;Float 6;32;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1869.79,102.5099;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-1761.579,-921.9984;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;109;-2150.167,-346.8051;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-1741.152,-636.0421;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-2154.707,885.4396;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2523.855,1481.117;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1573.138,-2004.011;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1773.622,-14.34835;Inherit;False;Property;_Shadow;Shadow;21;0;Create;True;0;0;0;False;0;False;0.98;0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2457.352,1742.235;Inherit;False;Property;_EdgeMaskPow;Edge Mask Pow;29;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1752.208,-365.2263;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;75;-1625.278,100.307;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;120;-1915.606,898.3674;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1416.956,-856.4562;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;28;-2296.855,1485.117;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-1499.165,-98.37749;Inherit;False;Property;_ShadowColorA;Shadow Color A;22;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;60;-1339.172,-1962.741;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;79;-1492.795,314.3478;Inherit;False;Property;_ShadowColorB;Shadow Color B;23;0;Create;True;0;0;0;False;0;False;0.5754717,0.5754717,0.5754717,0;0.5754717,0.5754717,0.5754717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1453.876,-386.4159;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;-1806.988,1722.119;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-1277.792,111.0276;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-708.0368,-1437.683;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-478.4978,-890.8746;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-822.2881,-348.3586;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;93;-303.9358,-1044.364;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;5;359.7397,-371.444;Inherit;False;264.7773;454.3536;Auto ;4;2;3;1;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;410.517,-224.3742;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;31;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;415.1447,-125.9728;Inherit;False;Property;_CullMode;Cull Mode;32;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;409.7397,-321.4437;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;30;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-68.17179,-904.8069;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-26.37716,-469.173;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2801.12,1887.883;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;31;-2308.075,1886.322;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2548.825,1883.133;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3198.12,1873.883;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;24;-2962.12,1842.883;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;414.7274,-34.20417;Inherit;False;Property;_ZTestMode;ZTest Mode;33;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2038.627,1722.102;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;386.0575,-874.0937;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Water Mesh;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;True;_ZTestMode;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;True;_Src_BlendMode;10;True;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;89;0;84;0
WireConnection;89;2;88;0
WireConnection;85;1;89;0
WireConnection;99;0;85;0
WireConnection;51;0;54;0
WireConnection;51;1;53;0
WireConnection;12;0;9;0
WireConnection;12;1;10;0
WireConnection;104;0;99;0
WireConnection;104;1;101;0
WireConnection;52;0;58;0
WireConnection;52;2;51;0
WireConnection;103;0;104;0
WireConnection;103;1;105;0
WireConnection;11;0;8;0
WireConnection;11;2;12;0
WireConnection;13;1;11;0
WireConnection;37;0;103;0
WireConnection;57;1;52;0
WireConnection;81;0;37;0
WireConnection;81;1;82;0
WireConnection;116;0;115;0
WireConnection;116;1;114;0
WireConnection;55;0;56;0
WireConnection;55;1;57;0
WireConnection;48;0;49;0
WireConnection;48;1;13;0
WireConnection;64;0;55;0
WireConnection;64;1;65;0
WireConnection;23;0;22;1
WireConnection;66;0;48;0
WireConnection;66;1;67;0
WireConnection;113;0;112;0
WireConnection;113;2;116;0
WireConnection;68;0;81;0
WireConnection;117;1;113;0
WireConnection;125;1;119;0
WireConnection;125;0;126;3
WireConnection;70;0;72;0
WireConnection;70;1;64;0
WireConnection;69;0;71;0
WireConnection;69;1;66;0
WireConnection;43;0;37;0
WireConnection;43;1;44;0
WireConnection;108;0;37;0
WireConnection;73;0;81;0
WireConnection;73;1;68;0
WireConnection;26;0;23;0
WireConnection;26;1;22;1
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;74;0;73;0
WireConnection;40;0;42;0
WireConnection;40;1;41;0
WireConnection;40;2;38;0
WireConnection;109;0;108;0
WireConnection;109;1;110;0
WireConnection;45;0;43;0
WireConnection;118;0;117;1
WireConnection;118;1;125;0
WireConnection;27;0;26;0
WireConnection;59;0;69;0
WireConnection;59;1;70;0
WireConnection;111;0;43;0
WireConnection;111;1;109;0
WireConnection;75;0;76;0
WireConnection;75;1;74;0
WireConnection;120;0;121;0
WireConnection;120;1;118;0
WireConnection;46;0;40;0
WireConnection;46;1;45;0
WireConnection;28;0;27;0
WireConnection;28;1;32;0
WireConnection;60;0;59;0
WireConnection;123;0;111;0
WireConnection;123;1;120;0
WireConnection;34;0;28;0
WireConnection;77;0;78;0
WireConnection;77;1;79;0
WireConnection;77;2;75;0
WireConnection;50;0;46;0
WireConnection;50;1;60;0
WireConnection;80;0;77;0
WireConnection;80;1;50;0
WireConnection;124;0;123;0
WireConnection;124;1;34;0
WireConnection;94;0;93;0
WireConnection;94;1;80;0
WireConnection;96;0;93;4
WireConnection;96;1;124;0
WireConnection;29;0;24;0
WireConnection;29;1;25;2
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;30;0;29;0
WireConnection;24;0;25;2
WireConnection;33;0;28;0
WireConnection;33;1;31;0
WireConnection;0;2;94;0
WireConnection;0;9;96;0
ASEEND*/
//CHKSM=FF0AB751F44903D3C82D2A4C5ABFFABA4F0C6E73