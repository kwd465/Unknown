// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Ice Smoke"
{
	Properties
	{
		_T_Icesmoke("T_Icesmoke", 2D) = "white" {}
		_MainIns("Main Ins", Range( 1 , 50)) = 1
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = -0.04948299
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_IcePow("Ice Pow", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		CGPROGRAM
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _TintColor;
		uniform float _MainIns;
		uniform sampler2D _T_Icesmoke;
		uniform float4 _T_Icesmoke_ST;
		uniform float _IcePow;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Dissolve;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_T_Icesmoke = i.uv_texcoord;
			uvs_T_Icesmoke.xy = i.uv_texcoord.xy * _T_Icesmoke_ST.xy + _T_Icesmoke_ST.zw;
			float4 uvs_TextureSample0 = i.uv_texcoord;
			uvs_TextureSample0.xy = i.uv_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch16 = i.uv_texcoord.z;
			#else
				float staticSwitch16 = _Dissolve;
			#endif
			o.Emission = ( i.vertexColor * ( _TintColor * ( _MainIns * ( ( tex2D( _T_Icesmoke, uvs_T_Icesmoke.xy ).r * _IcePow ) * saturate( ( tex2D( _TextureSample0, uvs_TextureSample0.xy ).r + staticSwitch16 ) ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TexCoordVertexDataNode;17;-5077.045,-166.3519;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-5350.002,-480.6732;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-5109.204,-248.1352;Float;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;0;False;0;False;-0.04948299;-0.04948299;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-5247.103,-672.6733;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;16;-4823.763,-227.7043;Float;False;Property;_UseCustom;Use Custom;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-5081,-454.0276;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;31dd6346a4b918b4bbbcae43aab91051;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-4584.21,-382.5196;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4841.989,-752.1661;Float;False;Property;_IcePow;Ice Pow;7;0;Create;True;0;0;0;False;0;False;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-5014.018,-679;Inherit;True;Property;_T_Icesmoke;T_Icesmoke;1;0;Create;True;0;0;0;False;0;False;-1;bd31a3b66e7f02b41a69f84503f92754;b1d2b54960a9ff14089a97666ea6286f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-4653.489,-597.4664;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-4384.017,-369.0634;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4487.563,-713.8932;Float;False;Property;_MainIns;Main Ins;2;0;Create;True;0;0;0;False;0;False;1;1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-4413.19,-594.1596;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-4209.405,-600.9346;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-4192.908,-802.3421;Float;False;Property;_TintColor;Tint Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;7;-3977.054,-789.012;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3972.851,-610.3965;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-3767.226,-713.72;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3618.659,-756.9005;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Ice Smoke;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;1;11;0
WireConnection;16;0;17;3
WireConnection;9;1;15;0
WireConnection;10;0;9;1
WireConnection;10;1;16;0
WireConnection;1;1;14;0
WireConnection;18;0;1;1
WireConnection;18;1;19;0
WireConnection;12;0;10;0
WireConnection;13;0;18;0
WireConnection;13;1;12;0
WireConnection;2;0;4;0
WireConnection;2;1;13;0
WireConnection;3;0;5;0
WireConnection;3;1;2;0
WireConnection;6;0;7;0
WireConnection;6;1;3;0
WireConnection;0;2;6;0
ASEEND*/
//CHKSM=3E6D55DA36367D733856D7636DFDE688480CA7A4