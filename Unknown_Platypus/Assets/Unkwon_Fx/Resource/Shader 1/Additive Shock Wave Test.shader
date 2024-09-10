// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additive Shock Wave Test"
{
	Properties
	{
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Gratex("Gratex", 2D) = "white" {}
		_NormalScale("Normal Scale", Float) = 0.5
		_GraPow("Gra Pow", Float) = 1
		_U_Offset("U_Offset", Float) = 0.01
		_NoiseUpanner("Noise Upanner", Float) = 0
		_NoiseVpanner("Noise Vpanner", Float) = 0
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_GraIns("Gra Ins", Float) = 1
		[HDR]_GraColor("Gra Color", Color) = (1,0.04245281,0.04245281,0)
		_WorldPosition("World Position", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float3 worldPos;
		};

		uniform half4 _GraColor;
		uniform sampler2D _Gratex;
		uniform sampler2D _NoiseTex;
		uniform half _NoiseUpanner;
		uniform half _NoiseVpanner;
		uniform half _NormalScale;
		uniform half _U_Offset;
		uniform half _GraPow;
		uniform half _GraIns;
		uniform half _WorldPosition;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult6 = (half2(_NoiseUpanner , _NoiseVpanner));
			half2 panner7 = ( 1.0 * _Time.y * appendResult6 + i.uv_texcoord.xy);
			#ifdef _USECUSTOM_ON
				half staticSwitch31 = i.uv_texcoord.z;
			#else
				half staticSwitch31 = _U_Offset;
			#endif
			half2 appendResult16 = (half2(i.uv_texcoord.xy.x , ( i.uv_texcoord.xy.y + staticSwitch31 )));
			o.Emission = ( i.vertexColor * ( _GraColor * ( saturate( pow( tex2D( _Gratex, ( ( (tex2D( _NoiseTex, panner7 )).rg * _NormalScale ) + appendResult16 ) ).r , _GraPow ) ) * _GraIns ) ) ).rgb;
			float3 ase_worldPos = i.worldPos;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ase_worldPos.y + 0.0 ) , _WorldPosition ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;53;2560;1251;4120.688;1376.518;1.98179;True;True
Node;AmplifyShaderEditor.CommentaryNode;39;-3207.51,-639.4118;Inherit;False;1492;502.0001;Noise;9;2;3;1;6;7;8;13;11;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-3127.51,-270.4118;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-3130.51,-355.4117;Inherit;False;Property;_NoiseUpanner;Noise Upanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2844.51,-355.4117;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-3157.51,-508.4117;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-2733.51,-454.4117;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2577.43,158.8412;Inherit;False;Property;_U_Offset;U_Offset;4;0;Create;True;0;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;30;-2664.408,291.038;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2426.529,-37.44182;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;31;-2413.408,277.038;Inherit;False;Property;_UseCustom;Use Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-2529.51,-589.4118;Inherit;True;Property;_NoiseTex;Noise Tex;0;0;Create;True;0;0;0;False;0;False;-1;4d785d85ff63c4d368cdc3f9d80426ab;4d785d85ff63c4d368cdc3f9d80426ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;11;-2203.51,-536.4118;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2185.51,-292.4118;Inherit;False;Property;_NormalScale;Normal Scale;2;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-2183.529,82.55823;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1979.53,-21.44184;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1950.511,-390.4117;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1672.53,-130.4418;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1321.029,273.4044;Inherit;False;982;447.0001;World;5;33;35;34;36;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1332.252,83.5752;Inherit;False;Property;_GraPow;Gra Pow;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1453.252,-133.4248;Inherit;True;Property;_Gratex;Gratex;1;0;Create;True;0;0;0;False;0;False;-1;ba41bb3d40bb14f4da0ac08c76b56a62;91d796be7933f5d43b3f50c69279567b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-1271.029,345.4045;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;20;-1119.252,-106.4248;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-931.0293,605.4045;Inherit;False;Property;_WorldPosition;World Position;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1048.029,341.4044;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-932.1534,148.1911;Inherit;False;Property;_GraIns;Gra Ins;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-891.1534,-104.8089;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-702.1534,-104.8089;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;34;-801.0293,332.4044;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-678.2371,-328.9053;Inherit;False;Property;_GraColor;Gra Color;9;1;[HDR];Create;True;0;0;0;False;0;False;1,0.04245281,0.04245281,0;1,0.04245281,0.04245281,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;-537.0293,323.4044;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;29;-401.8148,-346.5837;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-464.4907,-111.9448;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-231.4606,-105.5164;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-210.0292,203.4044;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;83.38685,-64.32905;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additive Shock Wave Test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;10;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;2;0
WireConnection;6;1;3;0
WireConnection;7;0;1;0
WireConnection;7;2;6;0
WireConnection;31;1;17;0
WireConnection;31;0;30;3
WireConnection;8;1;7;0
WireConnection;11;0;8;0
WireConnection;15;0;14;2
WireConnection;15;1;31;0
WireConnection;16;0;14;1
WireConnection;16;1;15;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;18;0;12;0
WireConnection;18;1;16;0
WireConnection;19;1;18;0
WireConnection;20;0;19;1
WireConnection;20;1;21;0
WireConnection;33;0;32;2
WireConnection;22;0;20;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;36;0;34;0
WireConnection;25;0;26;0
WireConnection;25;1;23;0
WireConnection;27;0;29;0
WireConnection;27;1;25;0
WireConnection;37;0;29;4
WireConnection;37;1;36;0
WireConnection;0;2;27;0
WireConnection;0;9;37;0
ASEEND*/
//CHKSM=25CB3850C8A2D05D7D7D44EEC3365E6CD0070968