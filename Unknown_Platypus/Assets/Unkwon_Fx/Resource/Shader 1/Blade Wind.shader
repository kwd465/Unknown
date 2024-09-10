// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Blade Wind"
{
	Properties
	{
		_MainPow("Main Pow", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MainIns("Main Ins", Float) = 1
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_RotatorSpeed("Rotator Speed", Float) = 0
		_Float0("Float 0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform half4 _MainColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform half _RotatorSpeed;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform half _Float0;
		uniform half _MainPow;
		uniform half _MainIns;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float cos60 = cos( ( _RotatorSpeed * _Time.z ) );
			float sin60 = sin( ( _RotatorSpeed * _Time.z ) );
			half2 rotator60 = mul( uv_TextureSample0 - float2( 0.5,0.5 ) , float2x2( cos60 , -sin60 , sin60 , cos60 )) + float2( 0.5,0.5 );
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			half4 tex2DNode6 = tex2D( _TextureSample0, ( rotator60 + pow( tex2D( _NoiseTex, uv_NoiseTex ).r , _Float0 ) ) );
			half4 temp_cast_0 = (_MainPow).xxxx;
			half4 temp_output_9_0 = ( _MainColor * ( pow( tex2DNode6 , temp_cast_0 ) * _MainIns ) );
			o.Emission = ( temp_output_9_0 * i.vertexColor ).rgb;
			o.Alpha = ( temp_output_9_0 * ( ( tex2DNode6.a * _MainColor.a ) * i.vertexColor.a ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-3610.964,537.5787;Inherit;False;0;26;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;63;-3330.354,94.95442;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-3364.775,-41.94007;Inherit;False;Property;_RotatorSpeed;Rotator Speed;6;0;Create;True;0;0;0;False;0;False;0;-6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2898.212,755.9669;Inherit;False;Property;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-3238.423,-400.4086;Inherit;True;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-3126.534,-8.477031;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-3080.477,518.8426;Inherit;True;Property;_NoiseTex;Noise Tex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;70;-2730.561,532.4321;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;60;-2774.611,-125.5972;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-2480.087,180.133;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-2272.819,-166.0571;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-1253.509,-209.7404;Inherit;False;Property;_MainColor;Main Color;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.8941177,1.960784,3.32549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1976.603,73.3144;Inherit;False;Property;_MainPow;Main Pow;1;0;Create;True;0;0;0;False;0;False;1;0.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1624.014,173.2623;Inherit;False;Property;_MainIns;Main Ins;3;0;Create;True;0;0;0;False;0;False;1;1.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-1569.681,599.0094;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.VertexColorNode;33;-679.8245,-39.54285;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;5;-1841.621,-155.7038;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;54;-1592.349,346.6642;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1463.013,-88.73764;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;56;-1506.217,828.6888;Inherit;True;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1255.382,514.3906;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-968.2819,605.0535;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1041.502,-79.04482;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-404.2839,-112.3841;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-693.5059,329.2763;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-3969.601,804.6937;Inherit;False;Property;_RotatorSpeed01;Rotator Speed01;7;0;Create;True;0;0;0;False;0;False;0;-6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;75;-3379.437,721.0366;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-3731.36,838.1567;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;73;-3935.18,941.5881;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Blade Wind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;64;0;61;0
WireConnection;64;1;63;3
WireConnection;26;1;27;0
WireConnection;70;0;26;1
WireConnection;70;1;71;0
WireConnection;60;0;18;0
WireConnection;60;2;64;0
WireConnection;69;0;60;0
WireConnection;69;1;70;0
WireConnection;6;1;69;0
WireConnection;55;0;10;0
WireConnection;5;0;6;0
WireConnection;5;1;4;0
WireConnection;54;0;6;0
WireConnection;7;0;5;0
WireConnection;7;1;8;0
WireConnection;56;0;33;4
WireConnection;57;0;54;3
WireConnection;57;1;55;3
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;9;0;10;0
WireConnection;9;1;7;0
WireConnection;16;0;9;0
WireConnection;16;1;33;0
WireConnection;36;0;9;0
WireConnection;36;1;58;0
WireConnection;75;0;27;0
WireConnection;75;2;74;0
WireConnection;74;0;72;0
WireConnection;74;1;73;2
WireConnection;0;2;16;0
WireConnection;0;9;36;0
ASEEND*/
//CHKSM=DA78068E864F63165606200A8A296597EDD2810C