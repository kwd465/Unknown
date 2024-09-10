// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve_Ceil"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_Noise_Str("Noise_Str", Range( 0 , 1)) = 0
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,0)
		_Noise_Pow("Noise_Pow", Range( 0 , 10)) = 1
		_Ceil_Count("Ceil_Count", Range( 1 , 10)) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _Main_Texture;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Noise_Pow;
		uniform float _Noise_Str;
		uniform float4 _Main_Texture_ST;
		uniform float _Ceil_Count;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 appendResult4 = (float4(uv_TextureSample0.x , pow( uv_TextureSample0.y , _Noise_Pow ) , 0.0 , 0.0));
			float2 panner6 = ( 1.0 * _Time.y * float2( 0.1,0.15 ) + appendResult4.xy);
			float2 uv_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			float4 appendResult13 = (float4(uv_Main_Texture.x , ( uv_Main_Texture.y + i.uv2_texcoord2.z ) , 0.0 , 0.0));
			o.Emission = ( i.vertexColor * ( _Tint_Color * ( ceil( ( saturate( tex2D( _Main_Texture, ( float4( ( (UnpackNormal( tex2D( _TextureSample0, panner6 ) )).xy * _Noise_Str ), 0.0 , 0.0 ) + appendResult13 ).xy ).r ) * _Ceil_Count ) ) / _Ceil_Count ) ) ).rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;2;-3060.835,-31.90701;Float;False;Property;_Noise_Pow;Noise_Pow;6;0;Create;True;0;0;0;False;0;False;1;0.29;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-3015.936,-327.5849;Inherit;False;0;7;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;3;-2798.235,-150.2071;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2525.235,-316.6072;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;5;-2424.036,-129.4848;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0.1,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;6;-2296.836,-253.4848;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;33;-2089.19,560.3044;Inherit;True;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2002.836,152.5152;Inherit;True;0;21;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-2049.836,-245.4848;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;4f96d4ef7222cda4fbc29abb96dc4423;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1578.836,293.5152;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1808.836,-55.4848;Float;False;Property;_Noise_Str;Noise_Str;4;0;Create;True;0;0;0;False;0;False;0;0.47;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;-1762.836,-246.4848;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1336.836,-236.4848;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1383.836,183.5152;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-966.8668,-42.10385;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;21;-652.8041,194.7487;Inherit;True;Property;_Main_Texture;Main_Texture;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;-353.7036,105.6821;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-457.7036,465.6821;Float;False;Property;_Ceil_Count;Ceil_Count;7;0;Create;True;0;0;0;False;0;False;4;7.76;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-203.7036,195.6821;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;29;45.29639,113.6821;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;278.2964,235.6821;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-51.30786,-249.4402;Float;False;Property;_Tint_Color;Tint_Color;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.03475436,0.06596953,0.6698113,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;26;194.009,-390.1473;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;346.6921,-80.44022;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;34;-1707.218,590.2722;Inherit;False;Property;_UseCustom;Use Custom;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2090.601,452.6389;Float;False;Property;_Offset;Offset;1;0;Create;True;0;0;0;False;0;False;0;-0.463;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;439.009,-312.1473;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;677,-136;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve_Ceil;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;2
WireConnection;3;1;2;0
WireConnection;4;0;1;1
WireConnection;4;1;3;0
WireConnection;6;0;4;0
WireConnection;6;2;5;0
WireConnection;7;1;6;0
WireConnection;12;0;8;2
WireConnection;12;1;33;3
WireConnection;11;0;7;0
WireConnection;14;0;11;0
WireConnection;14;1;10;0
WireConnection;13;0;8;1
WireConnection;13;1;12;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;21;1;15;0
WireConnection;32;0;21;1
WireConnection;28;0;32;0
WireConnection;28;1;31;0
WireConnection;29;0;28;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;25;0;24;0
WireConnection;25;1;30;0
WireConnection;34;1;33;3
WireConnection;34;0;9;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;0;2;27;0
WireConnection;0;9;26;4
ASEEND*/
//CHKSM=52D3699A2AF4C38B7E06B697E8BC69B4DEE3D927