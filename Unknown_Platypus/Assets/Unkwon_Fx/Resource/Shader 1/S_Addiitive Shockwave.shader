// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/ Additive_Shockwave"
{
	Properties
	{
		_T_NosiseNomal("T_Nosise Nomal", 2D) = "bump" {}
		_T_GartexClamp("T_Gartex Clamp", 2D) = "white" {}
		_NomalScale("Nomal Scale", Range( 0 , 1)) = 1
		_VOffset("VOffset", Range( -1 , 1)) = 0.22
		_NoiseUpanner("Noise Upanner", Float) = 0.1
		_NoiseVpanner("Noise Vpanner", Float) = 0.1
		_GraPow("Gra Pow", Range( 1 , 10)) = 2
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_GratexIns("Gratex Ins", Range( 1 , 20)) = 0
		[HDR]_GraColor("Gra Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform sampler2D _T_GartexClamp;
		uniform sampler2D _T_NosiseNomal;
		uniform float _NoiseUpanner;
		uniform float _NoiseVpanner;
		uniform float4 _T_NosiseNomal_ST;
		uniform float _NomalScale;
		uniform float4 _T_GartexClamp_ST;
		uniform float _VOffset;
		uniform float _GraPow;
		uniform float _GratexIns;
		uniform float4 _GraColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult27 = (float2(_NoiseUpanner , _NoiseVpanner));
			float2 uv_T_NosiseNomal = i.uv_texcoord * _T_NosiseNomal_ST.xy + _T_NosiseNomal_ST.zw;
			float2 panner24 = ( 1.0 * _Time.y * appendResult27 + uv_T_NosiseNomal);
			float2 uv_T_GartexClamp = i.uv_texcoord * _T_GartexClamp_ST.xy + _T_GartexClamp_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch32 = i.uv2_texcoord2.x;
			#else
				float staticSwitch32 = _VOffset;
			#endif
			float2 appendResult17 = (float2(( ( uv_T_GartexClamp.x + 0.0 ) * 1.0 ) , ( ( uv_T_GartexClamp.y + staticSwitch32 ) * 1.0 )));
			float4 temp_output_33_0 = saturate( ( ( pow( tex2D( _T_GartexClamp, ( ( (UnpackNormal( tex2D( _T_NosiseNomal, panner24 ) )).xy * _NomalScale ) + appendResult17 ) ).r , _GraPow ) * _GratexIns ) * _GraColor ) );
			o.Emission = ( i.vertexColor * temp_output_33_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;25;-2463.128,-285.0666;Float;False;Property;_NoiseUpanner;Noise Upanner;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2462.128,-200.0664;Float;False;Property;_NoiseVpanner;Noise Vpanner;6;0;Create;True;0;0;0;False;0;False;0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2471.128,-462.7793;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;27;-2297.127,-279.0667;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;31;-2207.213,270.7975;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-2249.237,185.1907;Float;False;Property;_VOffset;VOffset;4;0;Create;True;0;0;0;False;0;False;0.22;0.16;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2189.384,-75.56171;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;32;-1973.953,248.1882;Float;False;Property;_UseCustom;Use Custom;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-2214.127,-437.0667;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1822.694,60.50496;Float;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1910.185,116.8383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1908.385,-36.36164;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-2018.216,-397.0315;Inherit;True;Property;_T_NosiseNomal;T_Nosise Nomal;1;0;Create;True;0;0;0;False;0;False;-1;ef47ab26c4c074c4c91599d6ccc24911;ef47ab26c4c074c4c91599d6ccc24911;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1756.961,-184.1419;Float;False;Property;_NomalScale;Nomal Scale;3;0;Create;True;0;0;0;False;0;False;1;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-1710.63,-408.0022;Inherit;True;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1697.986,-56.96173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1705.386,102.4383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1544.986,5.038404;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1429.358,-357.8794;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1204.209,-219.6527;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-962.4516,-8.519283;Float;False;Property;_GraPow;Gra Pow;7;0;Create;True;0;0;0;False;0;False;2;3.99;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-971.2546,-210.7539;Inherit;True;Property;_T_GartexClamp;T_Gartex Clamp;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;19;-651.3566,-208.3181;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-654.244,21.87596;Float;False;Property;_GratexIns;Gratex Ins;9;0;Create;True;0;0;0;False;0;False;0;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-359.9629,-190.2963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-336.2703,36.59515;Float;False;Property;_GraColor;Gra Color;10;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.7137255,0.9490196,1.223529,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-107.0941,-183.1835;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;33;122.7698,-183.5467;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-16.60177,263.0584;Float;True;Property;_Opacity;Opacity;11;0;Create;True;0;0;0;False;0;False;0;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;34;63.80437,-360.4851;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;241.1956,175.7506;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;305.5517,-247.181;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;457.8993,101.8581;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;703.7114,-83.02489;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/ Additive_Shockwave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;32;1;18;0
WireConnection;32;0;31;1
WireConnection;24;0;23;0
WireConnection;24;2;27;0
WireConnection;14;0;12;2
WireConnection;14;1;32;0
WireConnection;13;0;12;1
WireConnection;10;1;24;0
WireConnection;22;0;10;0
WireConnection;15;0;13;0
WireConnection;15;1;29;0
WireConnection;16;0;14;0
WireConnection;16;1;29;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;28;0;22;0
WireConnection;28;1;21;0
WireConnection;36;0;28;0
WireConnection;36;1;17;0
WireConnection;11;1;36;0
WireConnection;19;0;11;1
WireConnection;19;1;20;0
WireConnection;38;0;19;0
WireConnection;38;1;39;0
WireConnection;40;0;38;0
WireConnection;40;1;41;0
WireConnection;33;0;40;0
WireConnection;42;0;33;0
WireConnection;42;1;43;0
WireConnection;35;0;34;0
WireConnection;35;1;33;0
WireConnection;44;0;34;4
WireConnection;44;1;42;0
WireConnection;0;2;35;0
ASEEND*/
//CHKSM=19B5B9215A5423EBA9E29C0A8AB9F4981AEB3B77