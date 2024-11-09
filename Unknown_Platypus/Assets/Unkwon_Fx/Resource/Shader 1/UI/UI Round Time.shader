// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/UI Round Time"
{
	Properties
	{
		_TimeTex("Time Tex", 2D) = "white" {}
		_TimeScale("Time Scale", Float) = 0.5
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USENOISE_ON
		#pragma shader_feature_local _STEPKEY_ON
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform half4 _MaskColor;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform half _MaskIns;
		uniform half _MaskPow;
		uniform sampler2D _NoiseTex;
		uniform half _NoiseUpanner;
		uniform half _NoiseVpanner;
		uniform float4 _NoiseTex_ST;
		uniform half _NoiseVal;
		uniform sampler2D _TimeTex;
		uniform float4 _TimeTex_ST;
		uniform half _TimeScale;
		uniform sampler2D _DissolveTex;
		uniform half _DissolveUpanner;
		uniform half _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform half _Dissolve;
		uniform half _Step;
		uniform half _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			half4 tex2DNode16 = tex2D( _MaskTex, uvs_MaskTex.xy );
			half4 temp_cast_0 = (_MaskPow).xxxx;
			half4 temp_output_27_0 = pow( ( tex2DNode16 * _MaskIns ) , temp_cast_0 );
			half2 appendResult51 = (half2(_NoiseUpanner , _NoiseVpanner));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			half2 panner52 = ( 1.0 * _Time.y * appendResult51 + uvs_NoiseTex.xy);
			half4 tex2DNode48 = tex2D( _NoiseTex, panner52 );
			#ifdef _USENOISE_ON
				half4 staticSwitch58 = ( ( tex2DNode48.r * _NoiseVal ) * temp_output_27_0 );
			#else
				half4 staticSwitch58 = temp_output_27_0;
			#endif
			float4 uvs_TimeTex = i.uv_texcoord;
			uvs_TimeTex.xy = i.uv_texcoord.xy * _TimeTex_ST.xy + _TimeTex_ST.zw;
			half mulTime3 = _Time.y * _TimeScale;
			float cos15 = cos( mulTime3 );
			float sin15 = sin( mulTime3 );
			half2 rotator15 = mul( uvs_TimeTex.xy - float2( 0.5,0.5 ) , float2x2( cos15 , -sin15 , sin15 , cos15 )) + float2( 0.5,0.5 );
			half4 tex2DNode2 = tex2D( _TimeTex, rotator15 );
			o.Emission = ( i.vertexColor * ( ( _MaskColor * saturate( staticSwitch58 ) ) * tex2DNode2.r ) ).rgb;
			half2 appendResult34 = (half2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			half2 panner35 = ( 1.0 * _Time.y * appendResult34 + uvs_DissolveTex.xy);
			#ifdef _USE_CUSTOM_ON
				half staticSwitch42 = i.uv_texcoord.z;
			#else
				half staticSwitch42 = _Dissolve;
			#endif
			half temp_output_41_0 = saturate( ( tex2D( _DissolveTex, panner35 ).r + staticSwitch42 ) );
			#ifdef _STEPKEY_ON
				half staticSwitch40 = step( _Step , temp_output_41_0 );
			#else
				half staticSwitch40 = temp_output_41_0;
			#endif
			o.Alpha = ( i.vertexColor.a * ( ( ( tex2DNode48.r * tex2DNode16.r * tex2DNode2.r ) * staticSwitch40 ) * saturate( _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
2050;69;1658;791;2226.195;658.7656;1.375574;True;False
Node;AmplifyShaderEditor.RangedFloatNode;50;-3004.876,-939.0135;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3008.876,-1011.014;Inherit;False;Property;_NoiseUpanner;Noise Upanner;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-2121.077,-774.4652;Inherit;False;1480;567.9999;Mask;11;17;16;23;24;26;27;28;29;30;58;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2784.876,-987.0134;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2910.876,-1185.014;Inherit;False;0;48;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-2347.703,622.8842;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2374.277,531.3698;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;52;-2649.876,-1075.014;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2217.89,-604.3985;Inherit;False;0;16;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2295.981,346.3234;Inherit;False;0;21;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2108.011,535.717;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-1966.724,416.1687;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1742.216,673.4524;Inherit;False;Property;_Dissolve;Dissolve;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;66;-1737.883,762.8837;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-1990.617,-601.8302;Inherit;True;Property;_MaskTex;Mask Tex;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1709.891,-347.3987;Inherit;False;Property;_MaskIns;Mask Ins;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-2421.876,-1107.014;Inherit;True;Property;_NoiseTex;Noise Tex;13;0;Create;True;0;0;0;False;0;False;-1;74761a463678e4f52a5551e56e3e25b2;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1796.195,408.8438;Inherit;True;Property;_DissolveTex;Dissolve Tex;6;0;Create;True;0;0;0;False;0;False;-1;74761a463678e4f52a5551e56e3e25b2;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;42;-1465.114,664.4903;Inherit;False;Property;_Use_Custom;Use_Custom;10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1400.891,-313.3986;Inherit;False;Property;_MaskPow;Mask Pow;4;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1509.891,-558.3985;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;53;-2123.875,-1104.014;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2084.875,-877.0134;Inherit;False;Property;_NoiseVal;Noise Val;16;0;Create;True;0;0;0;False;0;False;0.98;0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1927.53,74.16272;Inherit;False;Property;_TimeScale;Time Scale;1;0;Create;True;0;0;0;False;0;False;0.5;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1841.876,-1088.014;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-1267.891,-542.3985;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1766.53,78.16272;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1806.821,-188.2988;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1403.554,397.011;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-1163.733,400.0923;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1272.551,-765.4612;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;15;-1468.53,-80.83728;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1104.397,646.7781;Inherit;False;Property;_Step;Step;11;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;58;-1133.974,-694.611;Inherit;False;Property;_UseNoise;Use Noise;17;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;38;-930.5358,412.1043;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1119.659,-59.52942;Inherit;True;Property;_TimeTex;Time Tex;0;0;Create;True;0;0;0;False;0;False;-1;3dfca3f969fef4158a21381474973a0c;3dfca3f969fef4158a21381474973a0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-241.8029,459.4899;Inherit;False;Property;_Opacity;Opacity;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-841.6713,-801.7449;Inherit;False;Property;_MaskColor;Mask Color;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;40;-633.3395,467.7785;Inherit;False;Property;_StepKey;Step Key;12;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-834.8111,-564.9852;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-624.4382,-4.431641;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-394.5775,177.6499;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-649.8111,-556.9852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;63;-50.30645,359.5048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;61;-224.4643,-352.8173;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-461.7866,-221.6894;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-179.0551,86.43286;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-3.236572,204.1747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-6.37473,-70.3988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;287.6176,-116.1054;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/UI Round Time;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;52;0;47;0
WireConnection;52;2;51;0
WireConnection;34;0;33;0
WireConnection;34;1;5;0
WireConnection;35;0;22;0
WireConnection;35;2;34;0
WireConnection;16;1;17;0
WireConnection;48;1;52;0
WireConnection;21;1;35;0
WireConnection;42;1;37;0
WireConnection;42;0;66;3
WireConnection;23;0;16;0
WireConnection;23;1;24;0
WireConnection;53;0;48;1
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;27;0;23;0
WireConnection;27;1;26;0
WireConnection;3;0;4;0
WireConnection;36;0;21;1
WireConnection;36;1;42;0
WireConnection;41;0;36;0
WireConnection;65;0;54;0
WireConnection;65;1;27;0
WireConnection;15;0;1;0
WireConnection;15;2;3;0
WireConnection;58;1;27;0
WireConnection;58;0;65;0
WireConnection;38;0;39;0
WireConnection;38;1;41;0
WireConnection;2;1;15;0
WireConnection;40;1;41;0
WireConnection;40;0;38;0
WireConnection;28;0;58;0
WireConnection;68;0;48;1
WireConnection;68;1;16;1
WireConnection;68;2;2;1
WireConnection;46;0;68;0
WireConnection;46;1;40;0
WireConnection;29;0;30;0
WireConnection;29;1;28;0
WireConnection;63;0;62;0
WireConnection;19;0;29;0
WireConnection;19;1;2;1
WireConnection;67;0;46;0
WireConnection;67;1;63;0
WireConnection;64;0;61;4
WireConnection;64;1;67;0
WireConnection;59;0;61;0
WireConnection;59;1;19;0
WireConnection;0;2;59;0
WireConnection;0;9;64;0
ASEEND*/
//CHKSM=743F51C00C6AAF25AE6ECFAE437346A6598D3D3A