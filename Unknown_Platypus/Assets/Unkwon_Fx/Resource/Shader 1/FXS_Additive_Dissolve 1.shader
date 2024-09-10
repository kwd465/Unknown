// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KUPAFX/Additive_Dissolve"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_Main_Ins("Main_Ins", Range( 1 , 20)) = 1
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Dissolve_Texure("Dissolve_Texure", 2D) = "white" {}
		_Dissolve_Val("Dissolve_Val", Range( -1 , 1)) = 1
		_Dissolve_UPanner("Dissolve_UPanner", Float) = 0
		_Dissolve_VPanner("Dissolve_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Noise_Texture("Noise_Texture", 2D) = "bump" {}
		_Noise_Str("Noise_Str", Float) = 0
		_Noise_UPanner("Noise_UPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0
		_WorldPostion("World Postion", Float) = 4
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
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _Main_Texture;
		uniform float4 _Main_Texture_ST;
		uniform sampler2D _Dissolve_Texure;
		uniform float _Dissolve_UPanner;
		uniform float _Dissolve_VPanner;
		uniform sampler2D _Noise_Texture;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float4 _Noise_Texture_ST;
		uniform float _Noise_Str;
		uniform float4 _Dissolve_Texure_ST;
		uniform float _Dissolve_Val;
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform float _WorldPostion;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_Main_Texture = i.uv_texcoord;
			uvs_Main_Texture.xy = i.uv_texcoord.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			half2 appendResult28 = (half2(_Dissolve_UPanner , _Dissolve_VPanner));
			half2 appendResult38 = (half2(_Noise_UPanner , _Noise_VPanner));
			float4 uvs_Noise_Texture = i.uv_texcoord;
			uvs_Noise_Texture.xy = i.uv_texcoord.xy * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			half2 panner35 = ( 1.0 * _Time.y * appendResult38 + uvs_Noise_Texture.xy);
			float4 uvs_Dissolve_Texure = i.uv_texcoord;
			uvs_Dissolve_Texure.xy = i.uv_texcoord.xy * _Dissolve_Texure_ST.xy + _Dissolve_Texure_ST.zw;
			half2 panner25 = ( 1.0 * _Time.y * appendResult28 + ( ( (UnpackNormal( tex2D( _Noise_Texture, panner35 ) )).xy * _Noise_Str ) + uvs_Dissolve_Texure.xy ));
			#ifdef _USE_CUSTOM_ON
				float staticSwitch5 = i.uv_texcoord.w;
			#else
				float staticSwitch5 = _Dissolve_Val;
			#endif
			half4 temp_cast_0 = (_Main_Pow).xxxx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch14 = i.uv_texcoord.z;
			#else
				float staticSwitch14 = _Main_Ins;
			#endif
			o.Emission = ( ( _Tint_Color * ( pow( ( tex2D( _Main_Texture, uvs_Main_Texture.xy ) * saturate( ( tex2D( _Dissolve_Texure, panner25 ).r + staticSwitch5 ) ) ) , temp_cast_0 ) * staticSwitch14 ) ) * i.vertexColor ).rgb;
			float3 ase_worldPos = i.worldPos;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ase_worldPos.y + 0.17 ) , _WorldPostion ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
385;110;1698;964;145.2485;495.8617;1.245102;True;True
Node;AmplifyShaderEditor.RangedFloatNode;36;-2602.922,-370.8883;Float;False;Property;_Noise_UPanner;Noise_UPanner;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2606.922,-284.8883;Float;False;Property;_Noise_VPanner;Noise_VPanner;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-2633.922,-551.8883;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2331.922,-361.8883;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-2270.922,-467.8883;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;29;-2069.922,-507.8883;Inherit;True;Property;_Noise_Texture;Noise_Texture;10;0;Create;True;0;0;0;False;0;False;-1;None;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1702.922,-256.8883;Float;False;Property;_Noise_Str;Noise_Str;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;30;-1771.922,-494.8883;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1719.43,-58.005;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1523.922,-367.8883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1535.369,203.4067;Float;False;Property;_Dissolve_VPanner;Dissolve_VPanner;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1532.369,108.4067;Float;False;Property;_Dissolve_UPanner;Dissolve_UPanner;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1329.369,91.40674;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1356.922,-196.8883;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-1149.98,275.6782;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;25;-1158.369,-53.59326;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1186.53,186.495;Float;False;Property;_Dissolve_Val;Dissolve_Val;6;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;5;-817.9908,170.2555;Float;False;Property;_Use_Custom;Use_Custom;9;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-943.8297,-157.205;Inherit;True;Property;_Dissolve_Texure;Dissolve_Texure;5;0;Create;True;0;0;0;False;0;False;-1;e91647048de9833439e2635e67ce1714;710f0ecf3a70db046b1d6dc37fef65ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-611.3298,-56.80496;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-839.7905,-494.5933;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;24;-370.369,-54.59332;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-572.9297,-480.7048;Inherit;True;Property;_Main_Texture;Main_Texture;1;0;Create;True;0;0;0;False;0;False;-1;090812a83c6751c48b53b57d3a44514f;cc31e3aea9a3e654d926d38245865ad0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;42;500.3331,-44.9552;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-206.0861,-456.8935;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-145.5299,-71.60498;Float;False;Property;_Main_Ins;Main_Ins;3;0;Create;True;0;0;0;False;0;False;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;590.3331,141.0448;Float;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0.17;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-158.6299,-184.005;Float;False;Property;_Main_Pow;Main_Pow;4;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;771.3331,59.0448;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;850.3331,290.0448;Float;False;Property;_WorldPostion;World Postion;15;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;50.0701,-411.8049;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;14;242.9091,-138.8445;Float;False;Property;_Use_Custom;Use_Custom;8;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;271.0701,-418.8049;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;324.0701,-598.8049;Float;False;Property;_Tint_Color;Tint_Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;45;1016.333,113.0448;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;533.0701,-458.8049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;47;1260.333,150.0448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;521.0701,-301.805;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;382.3331,164.0448;Float;False;Property;_Depth_Distance;Depth_Distance;14;0;Create;True;0;0;0;False;0;False;0;0.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;39;572.3331,234.0448;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;882.3331,-110.9552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;707.0701,-408.805;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1100.64,-397.8731;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KUPAFX/Additive_Dissolve;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;36;0
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
WireConnection;5;1;3;0
WireConnection;5;0;2;4
WireConnection;6;1;25;0
WireConnection;10;0;6;1
WireConnection;10;1;5;0
WireConnection;24;0;10;0
WireConnection;9;1;23;0
WireConnection;22;0;9;0
WireConnection;22;1;24;0
WireConnection;43;0;42;2
WireConnection;43;1;44;0
WireConnection;12;0;22;0
WireConnection;12;1;8;0
WireConnection;14;1;7;0
WireConnection;14;0;2;3
WireConnection;16;0;12;0
WireConnection;16;1;14;0
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;18;0;1;0
WireConnection;18;1;16;0
WireConnection;47;0;45;0
WireConnection;39;0;40;0
WireConnection;41;0;19;4
WireConnection;41;1;47;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;0;2;20;0
WireConnection;0;9;41;0
ASEEND*/
//CHKSM=50A37291F184EE55103AB0F134FFE22D23562774