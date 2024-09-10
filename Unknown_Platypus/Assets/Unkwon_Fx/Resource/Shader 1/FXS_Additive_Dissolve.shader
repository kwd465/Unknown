// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additive_Dissolve"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_MainUpanner("Main Upanner", Float) = 0
		_MainVpanner("Main Vpanner", Float) = 0
		_Main_Ins("Main_Ins", Range( 1 , 20)) = 1
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Dissolve_Texure("Dissolve_Texure", 2D) = "white" {}
		_Dissolve_Val("Dissolve_Val", Range( -1 , 1)) = 1
		_Dissolve_UPanner("Dissolve_UPanner", Float) = 0
		_Dissolve_VPanner("Dissolve_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Noise_Str("Noise_Str", Float) = 0
		_NoiseUpanner("Noise Upanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0
		_Opacity("Opacity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _Main_Texture;
		uniform half _MainUpanner;
		uniform half _MainVpanner;
		uniform float4 _Main_Texture_ST;
		uniform sampler2D _Dissolve_Texure;
		uniform float _Dissolve_UPanner;
		uniform float _Dissolve_VPanner;
		uniform sampler2D _Noise_Texture;
		uniform half _NoiseUpanner;
		uniform float _Noise_VPanner;
		uniform float4 _Noise_Texture_ST;
		uniform float _Noise_Str;
		uniform float4 _Dissolve_Texure_ST;
		uniform float _Dissolve_Val;
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform half _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult51 = (half2(_MainUpanner , _MainVpanner));
			float4 uvs_Main_Texture = i.uv_texcoord;
			uvs_Main_Texture.xy = i.uv_texcoord.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			half2 panner52 = ( 1.0 * _Time.y * appendResult51 + uvs_Main_Texture.xy);
			half2 appendResult28 = (half2(_Dissolve_UPanner , _Dissolve_VPanner));
			half2 appendResult38 = (half2(_NoiseUpanner , _Noise_VPanner));
			float4 uvs_Noise_Texture = i.uv_texcoord;
			uvs_Noise_Texture.xy = i.uv_texcoord.xy * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			half2 panner35 = ( 1.0 * _Time.y * appendResult38 + uvs_Noise_Texture.xy);
			float4 uvs_Dissolve_Texure = i.uv_texcoord;
			uvs_Dissolve_Texure.xy = i.uv_texcoord.xy * _Dissolve_Texure_ST.xy + _Dissolve_Texure_ST.zw;
			half2 panner25 = ( 1.0 * _Time.y * appendResult28 + ( ( (tex2D( _Noise_Texture, panner35 )).rga * _Noise_Str ) + half3( uvs_Dissolve_Texure.xy ,  0.0 ) ).xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch5 = i.uv_texcoord.w;
			#else
				float staticSwitch5 = _Dissolve_Val;
			#endif
			half4 temp_cast_2 = (_Main_Pow).xxxx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch14 = i.uv_texcoord.z;
			#else
				float staticSwitch14 = _Main_Ins;
			#endif
			o.Emission = ( ( _Tint_Color * ( pow( ( tex2D( _Main_Texture, panner52 ) * saturate( ( tex2D( _Dissolve_Texure, panner25 ).r + staticSwitch5 ) ) ) , temp_cast_2 ) * staticSwitch14 ) ) * i.vertexColor ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( _Opacity ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
91;76;1658;796;388.5789;630.8887;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;37;-2606.922,-284.8883;Float;False;Property;_Noise_VPanner;Noise_VPanner;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2606.216,-367.9516;Inherit;False;Property;_NoiseUpanner;Noise Upanner;14;0;Create;True;0;0;0;False;0;False;0;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-2633.922,-551.8883;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2331.922,-361.8883;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-2270.922,-467.8883;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;29;-2069.922,-507.8883;Inherit;True;Property;_Noise_Texture;Noise_Texture;12;0;Create;True;0;0;0;False;0;False;-1;None;6d49859cdbcc742baacdea968a94e133;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1702.922,-256.8883;Float;False;Property;_Noise_Str;Noise_Str;13;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;30;-1771.922,-494.8883;Inherit;False;True;True;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1719.43,-58.005;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1523.922,-367.8883;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1535.369,203.4067;Float;False;Property;_Dissolve_VPanner;Dissolve_VPanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1532.369,108.4067;Float;False;Property;_Dissolve_UPanner;Dissolve_UPanner;9;0;Create;True;0;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1329.369,91.40674;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1356.922,-196.8883;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1131.231,-428.6994;Inherit;False;Property;_MainUpanner;Main Upanner;3;0;Create;True;0;0;0;False;0;False;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1120.979,-337.4622;Inherit;False;Property;_MainVpanner;Main Vpanner;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;25;-1158.369,-53.59326;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1186.53,186.495;Float;False;Property;_Dissolve_Val;Dissolve_Val;8;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-1149.98,275.6782;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-943.8297,-157.205;Inherit;True;Property;_Dissolve_Texure;Dissolve_Texure;7;0;Create;True;0;0;0;False;0;False;-1;None;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;51;-873.9211,-383.5934;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1030.466,-594.032;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;5;-817.9908,170.2555;Float;False;Property;_Use_Custom;Use_Custom;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;52;-775.5081,-528.1378;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-611.3298,-56.80496;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-370.369,-54.59332;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-572.9297,-480.7048;Inherit;True;Property;_Main_Texture;Main_Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;5a58c78efb6df4ae2959ab7acb60bdbf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-206.0861,-456.8935;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-158.6299,-184.005;Float;False;Property;_Main_Pow;Main_Pow;6;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-193.5762,-99.50283;Float;False;Property;_Main_Ins;Main_Ins;5;0;Create;True;0;0;0;False;0;False;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;50.0701,-411.8049;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;14;242.9091,-138.8445;Float;False;Property;_Use_Custom;Use_Custom;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;271.0701,-418.8049;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;324.0701,-598.8049;Float;False;Property;_Tint_Color;Tint_Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;538.3211,-25.08868;Inherit;False;Property;_Opacity;Opacity;18;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;521.0701,-301.805;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;533.0701,-458.8049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;54;667.0212,-48.48872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;1631.488,334.6282;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;1052.633,132.1448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;1710.488,565.6282;Float;False;Property;_WorldPostion;World Postion;17;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;2120.488,425.6282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;707.0701,-408.805;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;39;1432.488,509.6282;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;45;1876.488,388.6282;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1450.488,416.6282;Float;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0.17;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;1360.488,230.6282;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;40;1242.488,439.6282;Float;False;Property;_Depth_Distance;Depth_Distance;16;0;Create;True;0;0;0;False;0;False;0;0.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;813.9212,-142.0887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1100.64,-397.8731;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additive_Dissolve;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;48;0
WireConnection;38;1;37;0
WireConnection;35;0;34;0
WireConnection;35;2;38;0
WireConnection;29;1;35;0
WireConnection;30;0;29;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;31;0;32;0
WireConnection;31;1;4;0
WireConnection;25;0;31;0
WireConnection;25;2;28;0
WireConnection;6;1;25;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;5;1;3;0
WireConnection;5;0;2;4
WireConnection;52;0;23;0
WireConnection;52;2;51;0
WireConnection;10;0;6;1
WireConnection;10;1;5;0
WireConnection;24;0;10;0
WireConnection;9;1;52;0
WireConnection;22;0;9;0
WireConnection;22;1;24;0
WireConnection;12;0;22;0
WireConnection;12;1;8;0
WireConnection;14;1;7;0
WireConnection;14;0;2;3
WireConnection;16;0;12;0
WireConnection;16;1;14;0
WireConnection;18;0;1;0
WireConnection;18;1;16;0
WireConnection;54;0;53;0
WireConnection;43;0;42;2
WireConnection;43;1;44;0
WireConnection;47;0;45;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;39;0;40;0
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;55;0;19;4
WireConnection;55;1;54;0
WireConnection;0;2;20;0
WireConnection;0;9;55;0
ASEEND*/
//CHKSM=33685D2CE418ABFCBE70B8832F284259B383A7DB