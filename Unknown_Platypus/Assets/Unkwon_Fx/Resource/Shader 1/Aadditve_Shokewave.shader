// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve_Shokwave"
{
	Properties
	{
		_FXT_Noise_Normal("FXT_Noise_Normal", 2D) = "white" {}
		_FXT_GraTex_Clamp("FXT_GraTex_Clamp", 2D) = "white" {}
		_Normal_Scale("Normal_Scale", Range( 0 , 1)) = 0.5529412
		_GraTex_Pow("GraTex_Pow", Range( 1 , 30)) = 2.14
		_UOffset("UOffset", Range( -1 , 1)) = 0.22
		_Noise_UPanner("Noise_UPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = -0.1
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_GraTex_Ins("GraTex_Ins", Range( 1 , 10)) = 0
		[HDR]_GraTex_Color("GraTex_Color", Color) = (0,0,0,0)
		_WorldPostion("World Postion", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _FXT_GraTex_Clamp;
		uniform sampler2D _FXT_Noise_Normal;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float4 _FXT_Noise_Normal_ST;
		uniform float _Normal_Scale;
		uniform float4 _FXT_GraTex_Clamp_ST;
		uniform float _UOffset;
		uniform float _GraTex_Pow;
		uniform float _GraTex_Ins;
		uniform float4 _GraTex_Color;
		uniform half _WorldPostion;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult21 = (half2(_Noise_UPanner , _Noise_VPanner));
			float4 uvs_FXT_Noise_Normal = i.uv_texcoord;
			uvs_FXT_Noise_Normal.xy = i.uv_texcoord.xy * _FXT_Noise_Normal_ST.xy + _FXT_Noise_Normal_ST.zw;
			half2 panner18 = ( 1.0 * _Time.y * appendResult21 + uvs_FXT_Noise_Normal.xy);
			float4 uvs_FXT_GraTex_Clamp = i.uv_texcoord;
			uvs_FXT_GraTex_Clamp.xy = i.uv_texcoord.xy * _FXT_GraTex_Clamp_ST.xy + _FXT_GraTex_Clamp_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch24 = i.uv_texcoord.z;
			#else
				float staticSwitch24 = _UOffset;
			#endif
			half2 appendResult9 = (half2(uvs_FXT_GraTex_Clamp.xy.x , ( uvs_FXT_GraTex_Clamp.xy.y + staticSwitch24 )));
			o.Emission = ( i.vertexColor * ( ( saturate( pow( tex2D( _FXT_GraTex_Clamp, ( ( (tex2D( _FXT_Noise_Normal, panner18 )).rg * _Normal_Scale ) + appendResult9 ) ).r , _GraTex_Pow ) ) * _GraTex_Ins ) * _GraTex_Color ) ).rgb;
			float3 ase_worldPos = i.worldPos;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ase_worldPos.y + 0.0 ) , _WorldPostion ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;20;-1408.405,-194.7142;Float;False;Property;_Noise_VPanner;Noise_VPanner;7;0;Create;True;0;0;0;False;0;False;-0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1411.405,-277.7142;Float;False;Property;_Noise_UPanner;Noise_UPanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1250.405,-280.7142;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1442.405,-479.7142;Inherit;False;0;13;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-1171.405,-407.7142;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1446.3,513.4;Float;False;Property;_UOffset;UOffset;5;0;Create;True;0;0;0;False;0;False;0.22;0.23;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;23;-1290.233,398.3128;Inherit;True;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-924.405,-492.7143;Inherit;True;Property;_FXT_Noise_Normal;FXT_Noise_Normal;0;0;Create;True;0;0;0;False;0;False;-1;504f848a04ec0a04085719cdb37da448;504f848a04ec0a04085719cdb37da448;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-910.0999,32.1;Inherit;True;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;24;-997.4329,384.3129;Float;False;Property;_Use_Custom;Use_Custom;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-862.6643,-176.2497;Float;False;Property;_Normal_Scale;Normal_Scale;2;0;Create;True;0;0;0;False;0;False;0.5529412;0.225;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;-613.1584,-358.4861;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-652.3,121.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-499.3999,55.69999;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-467.5615,-203.4118;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-329.4846,3.283117;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-245.5287,281.4211;Float;False;Property;_GraTex_Pow;GraTex_Pow;4;0;Create;True;0;0;0;False;0;False;2.14;3.8;1;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-184,-3;Inherit;True;Property;_FXT_GraTex_Clamp;FXT_GraTex_Clamp;1;0;Create;True;0;0;0;False;0;False;-1;e1360499a340b594ba5c36a4d0fae212;8114901cd6272254f9794a61e1c327a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;11;27.47131,61.42111;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;38;-62.00978,439.0189;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;251.23,303.9239;Float;False;Property;_GraTex_Ins;GraTex_Ins;9;0;Create;True;0;0;0;False;0;False;0;1.65;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;264.1091,62.43817;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;149.6461,463.9194;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;254.2863,681.4255;Inherit;False;Property;_WorldPostion;World Postion;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;422.8299,-80.37611;Float;False;Property;_GraTex_Color;GraTex_Color;10;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1.611693,0.5476636,0.1140349,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;496.23,129.9239;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;36;448.2151,474.1759;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;659.5301,95.02388;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;27;500.4532,-285.6021;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;41;688.0323,478.7031;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;772.2834,-202.1883;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;920.2557,302.5723;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1086.9,-105.2;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve_Shokwave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;18.3;10;25;False;0.5;False;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;3;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;18;0;17;0
WireConnection;18;2;21;0
WireConnection;13;1;18;0
WireConnection;24;1;10;0
WireConnection;24;0;23;3
WireConnection;15;0;13;0
WireConnection;6;0;4;2
WireConnection;6;1;24;0
WireConnection;9;0;4;1
WireConnection;9;1;6;0
WireConnection;22;0;15;0
WireConnection;22;1;14;0
WireConnection;16;0;22;0
WireConnection;16;1;9;0
WireConnection;3;1;16;0
WireConnection;11;0;3;1
WireConnection;11;1;12;0
WireConnection;34;0;11;0
WireConnection;39;0;38;2
WireConnection;30;0;34;0
WireConnection;30;1;31;0
WireConnection;36;0;39;0
WireConnection;36;1;37;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;41;0;36;0
WireConnection;29;0;27;0
WireConnection;29;1;32;0
WireConnection;42;0;27;4
WireConnection;42;1;41;0
WireConnection;0;2;29;0
WireConnection;0;9;42;0
ASEEND*/
//CHKSM=BB2E17F9A78645E0CC41568CEE4E952BF86450AA