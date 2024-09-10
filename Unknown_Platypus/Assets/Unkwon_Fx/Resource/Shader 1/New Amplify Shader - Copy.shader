// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Toon Master "
{
	Properties
	{
		_ColorTex("Color Tex", 2D) = "white" {}
		_ColorPow("Color Pow", Float) = 1
		_ColorIns("Color Ins", Float) = 1
		_ColorU("Color U", Float) = 2
		_ColorV("Color V", Float) = 2
		_AlphaColorUpanner("Alpha Color Upanner", Float) = 0
		_AlphaColorVpanner("Alpha Color Vpanner", Float) = 0
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_NoiseControl("Noise Control", Float) = 0.1
		_NoiseU("Noise U", Float) = 2
		_NoiseV("Noise V", Float) = 2
		_NoiseUpanner("Noise Upanner", Float) = 0
		_NoiseVpanner("Noise Vpanner", Float) = 0.1
		_AlphaTex("Alpha Tex", 2D) = "white" {}
		_AlphaPow("Alpha Pow", Float) = 1
		_AlphaIns("Alpha Ins", Float) = 1
		_AlphaU("Alpha U", Float) = 2
		_AlphaV("Alpha V", Float) = 2
		_AlphaUpanner("Alpha Upanner", Float) = 0
		_AlphaVpanner("Alpha Vpanner", Float) = 0
		_DissolveTexRange("Dissolve Tex Range", Float) = 0.41
		_DissolveControl("Dissolve Control", Range( 0 , 1)) = 1
		_DissolveShap("Dissolve Shap", Range( 0 , 1)) = 1
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		[HDR]_MainColor01("Main Color 01", Color) = (1,1,1,1)
		[HDR]_MainColor02("Main Color 02", Color) = (1,0,0,1)
		_GradaitionIns("Gradaition Ins", Float) = 1
		_UseGradaition("Use Gradaition", Range( 0 , 1)) = 1
		[Toggle(_USEGRADITION_ON)] _UseGradition("Use Gradition", Float) = 0
		_WpoMin("Wpo Min", Float) = 0
		_WpoMax("Wpo Max", Float) = 1.41
		_WpoScale("Wpo Scale", Float) = 0.92
		[Toggle(_USEVERTEXOFFSET_ON)] _UseVertexOffset("Use Vertex Offset", Float) = 0
		[Toggle(_USEFRESNEL_ON)] _UseFresnel("Use Fresnel", Float) = 0
		_FresnelScale("Fresnel Scale", Float) = 0
		_FresnelPow("Fresnel Pow", Float) = 0
		[Toggle(_USEDEPTHFADE_ON)] _UseDepthfade("Use Depth fade", Float) = 0
		_DepthFadeDistens("Depth Fade Distens", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_BlendMode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 1
		[Enum(Defualt,2,Always,6)]_ZTest_Mode("ZTest_Mode", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USEVERTEXOFFSET_ON
		#pragma shader_feature_local _USEGRADITION_ON
		#pragma shader_feature_local _USEFRESNEL_ON
		#pragma shader_feature_local _USEDEPTHFADE_ON
		#pragma shader_feature_local _USECUSTOM_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		uniform float _Src_BlendMode;
		uniform float _Dst_BlendMode;
		uniform float _ZTest_Mode;
		uniform float _Cull_Mode;
		uniform float _WpoMin;
		uniform float _WpoMax;
		uniform sampler2D _NoiseTex;
		uniform float _NoiseUpanner;
		uniform float _NoiseVpanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseU;
		uniform float _NoiseV;
		uniform float _NoiseControl;
		uniform float _WpoScale;
		uniform float4 _MainColor01;
		uniform float4 _MainColor02;
		uniform float _UseGradaition;
		uniform float _GradaitionIns;
		uniform sampler2D _ColorTex;
		uniform float _AlphaColorUpanner;
		uniform float _AlphaColorVpanner;
		uniform float4 _ColorTex_ST;
		uniform float _ColorU;
		uniform float _ColorV;
		uniform float _ColorPow;
		uniform float _ColorIns;
		uniform float _FresnelScale;
		uniform float _FresnelPow;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistens;
		uniform sampler2D _AlphaTex;
		uniform float _AlphaUpanner;
		uniform float _AlphaVpanner;
		uniform float4 _AlphaTex_ST;
		uniform float _AlphaU;
		uniform float _AlphaV;
		uniform float _AlphaPow;
		uniform float _AlphaIns;
		uniform float _DissolveTexRange;
		uniform float _DissolveControl;
		uniform float _DissolveShap;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_cast_0 = (1.0).xxx;
			float2 appendResult38 = (float2(_NoiseUpanner , _NoiseVpanner));
			float4 uvs_NoiseTex = v.texcoord;
			uvs_NoiseTex.xy = v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 appendResult34 = (float2(_NoiseU , _NoiseV));
			float2 panner39 = ( 1.0 * _Time.y * appendResult38 + ( uvs_NoiseTex.xy * appendResult34 ));
			float4 temp_output_44_0 = ( tex2Dlod( _NoiseTex, float4( panner39, 0, 0.0) ) * _NoiseControl );
			float lerpResult74 = lerp( _WpoMin , _WpoMax , ( temp_output_44_0 - float4( 0,0,0,0 ) ).r);
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _USEVERTEXOFFSET_ON
				float3 staticSwitch81 = ( lerpResult74 * ( _WpoScale * ase_vertexNormal ) );
			#else
				float3 staticSwitch81 = temp_cast_0;
			#endif
			v.normal = staticSwitch81;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_cast_0 = (1.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV21 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode21 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV21, 5.0 ) );
			float lerpResult20 = lerp( fresnelNode21 , i.uv_texcoord.xy.y , _UseGradaition);
			float4 lerpResult26 = lerp( _MainColor01 , _MainColor02 , saturate( ( lerpResult20 * _GradaitionIns ) ));
			#ifdef _USEGRADITION_ON
				float4 staticSwitch29 = lerpResult26;
			#else
				float4 staticSwitch29 = temp_cast_0;
			#endif
			float2 appendResult8 = (float2(_AlphaColorUpanner , _AlphaColorVpanner));
			float4 uvs_ColorTex = i.uv_texcoord;
			uvs_ColorTex.xy = i.uv_texcoord.xy * _ColorTex_ST.xy + _ColorTex_ST.zw;
			float2 appendResult3 = (float2(_ColorU , _ColorV));
			float2 panner5 = ( 1.0 * _Time.y * appendResult8 + ( uvs_ColorTex.xy * appendResult3 ));
			float2 appendResult38 = (float2(_NoiseUpanner , _NoiseVpanner));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 appendResult34 = (float2(_NoiseU , _NoiseV));
			float2 panner39 = ( 1.0 * _Time.y * appendResult38 + ( uvs_NoiseTex.xy * appendResult34 ));
			float4 temp_output_44_0 = ( tex2D( _NoiseTex, panner39 ) * _NoiseControl );
			float4 temp_cast_3 = (_ColorPow).xxxx;
			o.Emission = ( staticSwitch29 * ( ( pow( tex2D( _ColorTex, ( float4( panner5, 0.0 , 0.0 ) + temp_output_44_0 ).rg ) , temp_cast_3 ) * _ColorIns ) * i.vertexColor ) ).rgb;
			float fresnelNdotV92 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode92 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV92, _FresnelPow ) );
			#ifdef _USEFRESNEL_ON
				float staticSwitch95 = fresnelNode92;
			#else
				float staticSwitch95 = 1.0;
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth99 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth99 = abs( ( screenDepth99 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistens ) );
			#ifdef _USEDEPTHFADE_ON
				float staticSwitch101 = distanceDepth99;
			#else
				float staticSwitch101 = 1.0;
			#endif
			float2 appendResult52 = (float2(_AlphaUpanner , _AlphaVpanner));
			float4 uvs_AlphaTex = i.uv_texcoord;
			uvs_AlphaTex.xy = i.uv_texcoord.xy * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
			float2 appendResult53 = (float2(_AlphaU , _AlphaV));
			float2 panner55 = ( 1.0 * _Time.y * appendResult52 + ( uvs_AlphaTex.xy * appendResult53 ));
			float4 temp_cast_7 = (_AlphaPow).xxxx;
			#ifdef _USECUSTOM_ON
				float staticSwitch107 = i.uv_texcoord.z;
			#else
				float staticSwitch107 = _DissolveControl;
			#endif
			float lerpResult66 = lerp( _DissolveTexRange , 1.0 , staticSwitch107);
			float smoothstepResult68 = smoothstep( ( 1.0 - temp_output_44_0 ).r , 1.0 , lerpResult66);
			o.Alpha = saturate( ( staticSwitch95 * ( staticSwitch101 * ( ( i.vertexColor.a * ( pow( tex2D( _AlphaTex, ( temp_output_44_0 + float4( panner55, 0.0 , 0.0 ) ).rg ) , temp_cast_7 ) * _AlphaIns ) ) * saturate( ( smoothstepResult68 / _DissolveShap ) ) ) ) ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
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
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
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
Node;AmplifyShaderEditor.CommentaryNode;46;-2343.154,867.3815;Inherit;False;1688.115;665.3549;Noise;13;35;39;36;37;38;32;33;34;40;42;44;45;85;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2256.163,1041.983;Inherit;False;Property;_NoiseU;Noise U;9;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2252.269,1180.214;Inherit;False;Property;_NoiseV;Noise V;10;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2028.376,1094.55;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;62;-2318.191,1657.944;Inherit;False;1602.144;586.4441;Alpha;14;47;48;49;51;50;52;53;54;55;57;61;59;58;60;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2252.27,1417.736;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;12;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2271.739,1306.762;Inherit;False;Property;_NoiseUpanner;Noise Upanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2293.154,917.3815;Inherit;False;0;42;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1987.49,1328.178;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1839.525,1022.514;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2268.191,1863.912;Inherit;False;Property;_AlphaU;Alpha U;16;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2260.841,1946.475;Inherit;False;Property;_AlphaV;Alpha V;17;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2254.428,1707.944;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;53;-2047.979,1861.264;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-1512.445,1115.966;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2262.904,2129.388;Inherit;False;Property;_AlphaVpanner;Alpha Vpanner;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2363.69,117.3196;Inherit;False;1767.302;623.4352;Alpha Color;10;10;9;5;11;12;14;13;15;16;41;Alpha Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2267.555,2037.959;Inherit;False;Property;_AlphaUpanner;Alpha Upanner;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1124.943,1263.013;Inherit;False;Property;_NoiseControl;Noise Control;8;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1874.979,1742.264;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-2005.979,1989.264;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;42;-1309.966,1061.022;Inherit;True;Property;_NoiseTex;Noise Tex;7;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;10;-2313.69,167.3196;Inherit;False;576.9133;263.7607;Color;4;3;4;1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-540.0863,1845.559;Inherit;False;1290.458;529.453;Dissolve;10;64;65;63;66;67;68;69;70;71;86;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-589.5138,2154.711;Inherit;False;Property;_DissolveControl;Dissolve Control;21;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;9;-2305.322,473.6457;Inherit;False;477.1514;267.1092;Color Speed;3;6;7;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;55;-1743.979,1836.264;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;106;-572.2705,2256.392;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-887.2043,1062.351;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2263.69,316.0804;Inherit;False;Property;_ColorV;Color V;4;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-2256.994,229.0369;Inherit;False;Property;_ColorU;Color U;3;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-490.0865,1895.56;Inherit;False;Property;_DissolveTexRange;Dissolve Tex Range;20;0;Create;True;0;0;0;False;0;False;0.41;0.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2255.322,523.6454;Inherit;False;Property;_AlphaColorUpanner;Alpha Color Upanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-477.2284,2024.138;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;107;-331.9719,2291.492;Inherit;False;Property;_UseCustom;Use Custom;23;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-1012.432,1377.682;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2253.648,625.7544;Inherit;False;Property;_AlphaColorVpanner;Alpha Color Vpanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-2376.565,-769.1765;Inherit;False;1805.055;786.9089;Gradaition;13;18;19;20;21;22;23;24;25;26;27;28;30;29;Gradaition;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;86;-569.3467,2199.845;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2283.939,123.0655;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;3;-2059.473,257.4934;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;67;-131.2129,2144.243;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-2326.565,-238.6094;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;66;-59.33904,1908.415;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1401.476,2000.267;Inherit;False;Property;_AlphaPow;Alpha Pow;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1527.354,1774.294;Inherit;True;Property;_AlphaTex;Alpha Tex;13;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1989.171,550.4282;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1898.777,217.3196;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;102;-289.7612,1153.787;Inherit;False;823;282;Depth Fade;4;98;99;100;101;;1,0,0,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;193.5378,2124.86;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;58;-1216.452,1783.393;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2125.859,-129.776;Inherit;False;Property;_UseGradaition;Use Gradaition;27;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;-1676.147,229.037;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;70;122.2527,2260.012;Inherit;False;Property;_DissolveShap;Dissolve Shap;22;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;21;-2213.491,-436.4894;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-2072.149,-230.1293;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1167.919,1994.201;Inherit;False;Property;_AlphaIns;Alpha Ins;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-239.7612,1311.787;Inherit;False;Property;_DepthFadeDistens;Depth Fade Distens;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-1861.549,-327.6556;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;69;409.9834,2127.002;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1349.427,470.7291;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;97;-289.1586,759.9632;Inherit;False;778.9152;361.2316;Fresnel;5;93;94;96;95;92;;1,0,0,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;89;-570.9338,608.6349;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-951.0463,1790.977;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1780.985,-97.26738;Inherit;False;Property;_GradaitionIns;Gradaition Ins;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;552.372,2031.338;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-226.6423,1541.802;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-235.1539,982.1664;Inherit;False;Property;_FresnelPow;Fresnel Pow;35;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1455.757,173.7975;Inherit;True;Property;_ColorTex;Color Tex;0;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;-240.4935,883.3834;Inherit;False;Property;_FresnelScale;Fresnel Scale;34;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;54.2388,1203.787;Inherit;False;Constant;_Float4;Float 4;37;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;99;20.2388,1302.787;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1573.211,-320.5887;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1269.953,374.6666;Inherit;False;Property;_ColorPow;Color Pow;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-571.4313,2503.006;Inherit;False;1323.305;546.1035;Vertex Nolmal;10;73;78;80;82;81;77;79;74;75;76;Vertex Nolmall;1,0,0,1;0;0
Node;AmplifyShaderEditor.PowerNode;13;-1075.779,175.4712;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-284.8096,2792.109;Inherit;False;Property;_WpoScale;Wpo Scale;31;0;Create;True;0;0;0;False;0;False;0.92;0.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-1503.955,-532.6041;Inherit;False;Property;_MainColor02;Main Color 02;25;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-521.4313,2760.307;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-312.9631,2641.085;Inherit;False;Property;_WpoMax;Wpo Max;30;0;Create;True;0;0;0;False;0;False;1.41;1.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;83.88837,825.9819;Inherit;False;Constant;_Float3;Float 3;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-311.8581,2564.721;Inherit;False;Property;_WpoMin;Wpo Min;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;788.8447,1733.085;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;92;-17.46308,920.8673;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-1503.955,-719.1765;Inherit;False;Property;_MainColor01;Main Color 01;24;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1066.562,386.0581;Inherit;False;Property;_ColorIns;Color Ins;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;-1339.996,-327.6561;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;79;-299.8098,2865.109;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;101;300.2388,1266.787;Inherit;False;Property;_UseDepthfade;Use Depth fade;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;95;264.101,916.7565;Inherit;False;Property;_UseFresnel;Use Fresnel;33;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-831.3876,178.819;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1023.39,-529.7773;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;-86.8156,2553.006;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-38.80946,2796.109;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;26;-1092.073,-409.2613;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;723.6001,1182.205;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;82;322.2248,2627.019;Inherit;False;Constant;_Float1;Float 1;33;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;876.6756,924.5898;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;230.5728,2740.795;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;29;-825.5102,-428.0104;Inherit;False;Property;_UseGradition;Use Gradition;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-344.3647,161.2084;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;108;1422.994,680.5842;Inherit;False;Property;_Src_BlendMode;Src_BlendMode;39;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;1457.617,846.1707;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;40;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-87.20535,-249.8549;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;81;472.8739,2717.619;Inherit;False;Property;_UseVertexOffset;Use Vertex Offset;32;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;105;1096.955,915.256;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;110;1427.51,1059.928;Inherit;False;Property;_ZTest_Mode;ZTest_Mode;41;1;[Enum];Create;True;0;2;Defualt;2;Always;6;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;1419.984,942.512;Inherit;False;Property;_Cull_Mode;Cull_Mode;38;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1358.105,52.90699;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Toon Master ;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;True;_ZTest_Mode;False;0;False;;0;False;;False;0;Transparent;0.27;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;True;_Src_BlendMode;10;True;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;35;0;40;0
WireConnection;35;1;34;0
WireConnection;53;0;48;0
WireConnection;53;1;49;0
WireConnection;39;0;35;0
WireConnection;39;2;38;0
WireConnection;54;0;47;0
WireConnection;54;1;53;0
WireConnection;52;0;51;0
WireConnection;52;1;50;0
WireConnection;42;1;39;0
WireConnection;55;0;54;0
WireConnection;55;2;52;0
WireConnection;44;0;42;0
WireConnection;44;1;45;0
WireConnection;107;1;65;0
WireConnection;107;0;106;3
WireConnection;85;0;44;0
WireConnection;85;1;55;0
WireConnection;86;0;44;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;67;0;86;0
WireConnection;66;0;63;0
WireConnection;66;1;64;0
WireConnection;66;2;107;0
WireConnection;57;1;85;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;4;0;41;0
WireConnection;4;1;3;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;58;0;57;0
WireConnection;58;1;59;0
WireConnection;5;0;4;0
WireConnection;5;2;8;0
WireConnection;19;0;18;2
WireConnection;20;0;21;0
WireConnection;20;1;19;0
WireConnection;20;2;22;0
WireConnection;69;0;68;0
WireConnection;69;1;70;0
WireConnection;12;0;5;0
WireConnection;12;1;44;0
WireConnection;60;0;58;0
WireConnection;60;1;61;0
WireConnection;71;0;69;0
WireConnection;90;0;89;4
WireConnection;90;1;60;0
WireConnection;11;1;12;0
WireConnection;99;0;98;0
WireConnection;23;0;20;0
WireConnection;23;1;24;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;73;0;44;0
WireConnection;91;0;90;0
WireConnection;91;1;71;0
WireConnection;92;2;93;0
WireConnection;92;3;94;0
WireConnection;25;0;23;0
WireConnection;101;1;100;0
WireConnection;101;0;99;0
WireConnection;95;1;96;0
WireConnection;95;0;92;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;74;0;75;0
WireConnection;74;1;76;0
WireConnection;74;2;73;0
WireConnection;78;0;77;0
WireConnection;78;1;79;0
WireConnection;26;0;27;0
WireConnection;26;1;28;0
WireConnection;26;2;25;0
WireConnection;103;0;101;0
WireConnection;103;1;91;0
WireConnection;104;0;95;0
WireConnection;104;1;103;0
WireConnection;80;0;74;0
WireConnection;80;1;78;0
WireConnection;29;1;30;0
WireConnection;29;0;26;0
WireConnection;88;0;15;0
WireConnection;88;1;89;0
WireConnection;87;0;29;0
WireConnection;87;1;88;0
WireConnection;81;1;82;0
WireConnection;81;0;80;0
WireConnection;105;0;104;0
WireConnection;0;2;87;0
WireConnection;0;9;105;0
WireConnection;0;12;81;0
ASEEND*/
//CHKSM=4178C289BE080A58E197971BB9A52658AC6EE7DB