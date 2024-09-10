// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alpha Helix"
{
	Properties
	{
		_Offset("Offset", Range( -1 , 1)) = 1
		_Upanner("Upanner", Float) = 0
		_Vpanner("Vpanner", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_MainIns("Main Ins", Range( 1 , 20)) = 1
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_MainPow("Main Pow", Range( 1 , 30)) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 5
		[Enum(Defult,2,Always,6)]_ZTest_Mode("ZTest_Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite Off
		ZTest [_ZTest_Mode]
		Blend SrcAlpha [_Dst_BlendMode]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform half _Src_BlendMode;
		uniform half _Dst_BlendMode;
		uniform half _Cull_Mode;
		uniform half _ZTest_Mode;
		uniform half _MainIns;
		uniform half4 _MainColor;
		uniform sampler2D _TextureSample0;
		uniform half _Upanner;
		uniform half _Vpanner;
		uniform half _Offset;
		uniform half _MainPow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult10 = (half2(_Upanner , _Vpanner));
			#ifdef _USECUSTOM_ON
				half staticSwitch28 = i.uv_texcoord.z;
			#else
				half staticSwitch28 = _Offset;
			#endif
			half2 appendResult6 = (half2(( i.uv_texcoord.xy.x + staticSwitch28 ) , i.uv_texcoord.xy.y));
			half2 panner7 = ( 1.0 * _Time.y * appendResult10 + appendResult6);
			o.Emission = ( ( i.vertexColor * ( _MainIns * ( _MainColor * pow( tex2D( _TextureSample0, panner7 ).r , _MainPow ) ) ) ) * saturate( pow( ( ( ( 1.0 - i.uv_texcoord.xy.x ) * i.uv_texcoord.xy.x ) * 4.0 ) , 2.0 ) ) ).rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;3;-3141.268,-255.3596;Inherit;False;Property;_Offset;Offset;0;0;Create;True;0;0;0;False;0;False;1;-0.11;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-3125.317,-67.1627;Inherit;True;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;28;-2809.475,-241.36;Inherit;False;Property;_UseCustom;Use Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3110.68,171.8547;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-2479.017,272.4787;Inherit;False;Property;_Upanner;Upanner;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-2689.996,-72.4127;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2493.401,375.7833;Inherit;False;Property;_Vpanner;Vpanner;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2400.557,18.79398;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-2271.1,322.1695;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-2119.411,30.56262;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-2264.801,563.4725;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-1724.399,270.2018;Inherit;False;Property;_MainPow;Main Pow;8;0;Create;True;0;0;0;False;0;False;0;1;1;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1932.311,431.4196;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1814.059,39.10583;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;6b40868a5461b406a88b91b209486e84;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1562.092,813.4297;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1397.299,-234.2187;Inherit;False;Property;_MainColor;Main Color;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.8679245,0.3170954,0.1678533,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;29;-1508.351,58.75092;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1705.934,584.6953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1316.851,846.4427;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1127.209,-1.266811;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1235.245,-215.6501;Inherit;False;Property;_MainIns;Main Ins;6;0;Create;True;0;0;0;False;0;False;1;8.5;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1401.742,603.56;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;-1113.03,608.2762;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;16;-724.8732,-207.54;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-868.937,-31.65189;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;26;-846.9933,600.2657;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-481.3159,-69.664;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-315.043,173.9039;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Alpha Helix;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;;0;True;_ZTest_Mode;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;8;5;False;_Src_BlendMode;1;True;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;True;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-84.23828,504.1716;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;9;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-77.74589,617.7863;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;12;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-100.4688,702.1857;Inherit;False;Property;_Cull_Mode;Cull_Mode;11;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-68.00757,822.2928;Inherit;True;Property;_ZTest_Mode;ZTest_Mode;10;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;0;2;0;0;0;1;FLOAT;0
WireConnection;28;1;3;0
WireConnection;28;0;1;3
WireConnection;2;0;4;1
WireConnection;2;1;28;0
WireConnection;6;0;2;0
WireConnection;6;1;4;2
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;7;0;6;0
WireConnection;7;2;10;0
WireConnection;19;0;18;1
WireConnection;11;1;7;0
WireConnection;29;0;11;1
WireConnection;29;1;30;0
WireConnection;20;0;19;0
WireConnection;20;1;18;1
WireConnection;12;0;13;0
WireConnection;12;1;29;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;24;0;21;0
WireConnection;24;1;25;0
WireConnection;14;0;15;0
WireConnection;14;1;12;0
WireConnection;26;0;24;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;27;0;17;0
WireConnection;27;1;26;0
WireConnection;0;2;27;0
WireConnection;0;9;16;4
ASEEND*/
//CHKSM=4BD73E7436AE8E8E9002864EBEF8EF2B10E3DF23