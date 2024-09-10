// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/UI Mask Panner Time"
{
	Properties
	{
		_TimeTex("Time Tex", 2D) = "white" {}
		_TimeScale("Time Scale", Float) = 0.5
		_TimeTexPow("Time Tex Pow", Float) = 0
		_TimeTexIns("Time Tex Ins", Float) = 0
		_MaskTex("Mask Tex", 2D) = "white" {}
		_MaskIns("Mask Ins", Float) = 1
		_MaskPow("Mask Pow", Float) = 1
		[HDR]_MaskColor("Mask Color", Color) = (1,1,1,1)
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		_Dissolve("Dissolve", Float) = 1
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Step("Step", Float) = 0.4
		[Toggle(_STEPKEY_ON)] _StepKey("Step Key", Float) = 1
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_NoiseUpanner("Noise Upanner", Float) = 0
		_NoiseVpanner("Noise Vpanner", Float) = 0
		_NoiseVal("Noise Val", Float) = 0.98
		[Toggle(_USENOISE_ON)] _UseNoise("Use Noise", Float) = 1
		_Opacity("Opacity", Float) = 1
		_MaskUpanner("Mask Upanner", Float) = 0
		_MaskVpanner("Mask Vpanner", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USENOISE_ON
		#pragma shader_feature_local _STEPKEY_ON
		#pragma shader_feature_local _USE_CUSTOM_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _MaskColor;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform float _MaskIns;
		uniform float _MaskPow;
		uniform sampler2D _NoiseTex;
		uniform float _NoiseUpanner;
		uniform float _NoiseVpanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseVal;
		uniform sampler2D _TimeTex;
		uniform float _TimeScale;
		uniform float _MaskUpanner;
		uniform float _MaskVpanner;
		uniform float4 _TimeTex_ST;
		uniform float _TimeTexPow;
		uniform float _TimeTexIns;
		uniform sampler2D _DissolveTex;
		uniform float _DissolveUpanner;
		uniform float _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform float _Dissolve;
		uniform float _Step;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float4 temp_cast_0 = (_MaskPow).xxxx;
			float4 temp_output_27_0 = pow( ( tex2D( _MaskTex, uvs_MaskTex.xy ) * _MaskIns ) , temp_cast_0 );
			float2 appendResult51 = (float2(_NoiseUpanner , _NoiseVpanner));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner52 = ( 1.0 * _Time.y * appendResult51 + uvs_NoiseTex.xy);
			#ifdef _USENOISE_ON
				float4 staticSwitch58 = ( ( tex2D( _NoiseTex, panner52 ).r * _NoiseVal ) * temp_output_27_0 );
			#else
				float4 staticSwitch58 = temp_output_27_0;
			#endif
			float mulTime3 = _Time.y * _TimeScale;
			float2 appendResult70 = (float2(_MaskUpanner , _MaskVpanner));
			float4 uvs_TimeTex = i.uv_texcoord;
			uvs_TimeTex.xy = i.uv_texcoord.xy * _TimeTex_ST.xy + _TimeTex_ST.zw;
			float2 panner67 = ( mulTime3 * appendResult70 + uvs_TimeTex.xy);
			float2 appendResult34 = (float2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner35 = ( 1.0 * _Time.y * appendResult34 + uvs_DissolveTex.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch42 = i.uv_texcoord.z;
			#else
				float staticSwitch42 = _Dissolve;
			#endif
			float temp_output_41_0 = saturate( ( tex2D( _DissolveTex, panner35 ).r + staticSwitch42 ) );
			#ifdef _STEPKEY_ON
				float staticSwitch40 = step( _Step , temp_output_41_0 );
			#else
				float staticSwitch40 = temp_output_41_0;
			#endif
			o.Emission = ( i.vertexColor * ( ( ( _MaskColor * saturate( staticSwitch58 ) ) * ( pow( tex2D( _TimeTex, panner67 ).r , _TimeTexPow ) * _TimeTexIns ) ) * staticSwitch40 ) ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( _Opacity ) );
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
Version=18935
143;143;1640;680;1397.651;641.3177;2.059671;True;False
Node;AmplifyShaderEditor.RangedFloatNode;49;-2926.271,-926.3449;Inherit;False;Property;_NoiseUpanner;Noise Upanner;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2922.271,-854.3444;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-2121.077,-774.4652;Inherit;False;1480;567.9999;Mask;11;17;16;23;24;26;27;28;29;30;58;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2828.271,-1100.345;Inherit;False;0;48;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2702.271,-902.3444;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;52;-2567.271,-990.3449;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2217.89,-604.3985;Inherit;False;0;16;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-2339.271,-1022.345;Inherit;True;Property;_NoiseTex;Noise Tex;15;0;Create;True;0;0;0;False;0;False;-1;74761a463678e4f52a5551e56e3e25b2;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-2085.17,526.1133;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2058.596,617.6277;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1990.617,-601.8302;Inherit;True;Property;_MaskTex;Mask Tex;4;0;Create;True;0;0;0;False;0;False;-1;None;377483ef954504ac68bf4e1a25393813;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1709.891,-347.3987;Inherit;False;Property;_MaskIns;Mask Ins;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1826.253,118.6256;Inherit;False;Property;_TimeScale;Time Scale;1;0;Create;True;0;0;0;False;0;False;0.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1932.415,42.83558;Inherit;False;Property;_MaskVpanner;Mask Vpanner;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1400.891,-313.3986;Inherit;False;Property;_MaskPow;Mask Pow;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1509.891,-558.3985;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;53;-2041.27,-1019.345;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2002.271,-792.3444;Inherit;False;Property;_NoiseVal;Noise Val;18;0;Create;True;0;0;0;False;0;False;0.98;0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2006.875,341.0669;Inherit;False;0;21;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1818.904,530.4606;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1937.356,-38.67971;Inherit;False;Property;_MaskUpanner;Mask Upanner;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1759.272,-1003.345;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-1716.276,-25.09387;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;66;-1448.777,757.6272;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-1453.11,668.1959;Inherit;False;Property;_Dissolve;Dissolve;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1665.253,121.6156;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1806.821,-188.2988;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-1677.618,410.9122;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;27;-1267.891,-542.3985;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1272.551,-765.4612;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;42;-1176.008,659.2338;Inherit;False;Property;_Use_Custom;Use_Custom;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-1507.089,403.5873;Inherit;True;Property;_DissolveTex;Dissolve Tex;8;0;Create;True;0;0;0;False;0;False;-1;74761a463678e4f52a5551e56e3e25b2;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;67;-1437.439,-64.87503;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;58;-1133.974,-694.611;Inherit;False;Property;_UseNoise;Use Noise;19;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1200.659,-71.52942;Inherit;True;Property;_TimeTex;Time Tex;0;0;Create;True;0;0;0;False;0;False;-1;3dfca3f969fef4158a21381474973a0c;3dfca3f969fef4158a21381474973a0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-996.2268,167.649;Inherit;False;Property;_TimeTexPow;Time Tex Pow;2;0;Create;True;0;0;0;False;0;False;0;0.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1114.448,391.7545;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-874.6266,394.8358;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-815.2908,641.5216;Inherit;False;Property;_Step;Step;13;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-771.2268,101.649;Inherit;False;Property;_TimeTexIns;Time Tex Ins;3;0;Create;True;0;0;0;False;0;False;0;0.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-834.8111,-564.9852;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;71;-851.2268,-58.35095;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-841.6713,-801.7449;Inherit;False;Property;_MaskColor;Mask Color;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-686.2268,-64.35095;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-641.4299,406.8478;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-649.8111,-556.9852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;40;-412.5676,467.7785;Inherit;False;Property;_StepKey;Step Key;14;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-226.0335,441.0923;Inherit;False;Property;_Opacity;Opacity;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-461.7866,-221.6894;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-238.2578,38.76288;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;63;-50.30645,359.5048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;61;-224.4643,-352.8173;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-6.37473,-70.3988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-3.236572,204.1747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;287.6176,-116.1054;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/UI Mask Panner Time;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;52;0;47;0
WireConnection;52;2;51;0
WireConnection;48;1;52;0
WireConnection;16;1;17;0
WireConnection;23;0;16;0
WireConnection;23;1;24;0
WireConnection;53;0;48;1
WireConnection;34;0;33;0
WireConnection;34;1;5;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;3;0;4;0
WireConnection;35;0;22;0
WireConnection;35;2;34;0
WireConnection;27;0;23;0
WireConnection;27;1;26;0
WireConnection;65;0;54;0
WireConnection;65;1;27;0
WireConnection;42;1;37;0
WireConnection;42;0;66;3
WireConnection;21;1;35;0
WireConnection;67;0;1;0
WireConnection;67;2;70;0
WireConnection;67;1;3;0
WireConnection;58;1;27;0
WireConnection;58;0;65;0
WireConnection;2;1;67;0
WireConnection;36;0;21;1
WireConnection;36;1;42;0
WireConnection;41;0;36;0
WireConnection;28;0;58;0
WireConnection;71;0;2;1
WireConnection;71;1;72;0
WireConnection;73;0;71;0
WireConnection;73;1;74;0
WireConnection;38;0;39;0
WireConnection;38;1;41;0
WireConnection;29;0;30;0
WireConnection;29;1;28;0
WireConnection;40;1;41;0
WireConnection;40;0;38;0
WireConnection;19;0;29;0
WireConnection;19;1;73;0
WireConnection;46;0;19;0
WireConnection;46;1;40;0
WireConnection;63;0;62;0
WireConnection;59;0;61;0
WireConnection;59;1;46;0
WireConnection;64;0;61;4
WireConnection;64;1;63;0
WireConnection;0;2;59;0
WireConnection;0;9;64;0
ASEEND*/
//CHKSM=6B6E8713F30D5B4FCCC8F94D032DFE2AE5A12D37