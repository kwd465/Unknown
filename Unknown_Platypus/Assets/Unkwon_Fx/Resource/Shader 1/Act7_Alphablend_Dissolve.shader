// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alphabled_Dissolve"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_Main_Ins("Main_Ins", Range( 1 , 20)) = 1
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Opacity("Opacity", Range( 0 , 10)) = 1
		_Dissolve_Texure("Dissolve_Texure", 2D) = "white" {}
		_Dissolve_Val("Dissolve_Val", Range( -1 , 1)) = 0.4823529
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_DissolveUpanner("Dissolve Upanner", Range( -10 , 10)) = 0
		_DissolveVpanner("Dissolve Vpanner", Range( -10 , 10)) = 0
		_MainUpanner("Main Upanner", Float) = 0
		_MainVpanner("Main Vpanner", Float) = 0
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
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
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
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform sampler2D _Dissolve_Texure;
		uniform half _DissolveUpanner;
		uniform half _DissolveVpanner;
		uniform float4 _Dissolve_Texure_ST;
		uniform float _Dissolve_Val;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult34 = (half2(_MainUpanner , _MainVpanner));
			float4 uvs_Main_Texture = i.uv_texcoord;
			uvs_Main_Texture.xy = i.uv_texcoord.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			half2 panner31 = ( 1.0 * _Time.y * appendResult34 + uvs_Main_Texture.xy);
			half4 tex2DNode1 = tex2D( _Main_Texture, panner31 );
			half4 temp_cast_0 = (_Main_Pow).xxxx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch21 = i.uv_texcoord.z;
			#else
				float staticSwitch21 = _Main_Ins;
			#endif
			o.Emission = ( ( _Tint_Color * ( pow( tex2DNode1 , temp_cast_0 ) * staticSwitch21 ) ) * i.vertexColor ).rgb;
			half2 appendResult27 = (half2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_Dissolve_Texure = i.uv_texcoord;
			uvs_Dissolve_Texure.xy = i.uv_texcoord.xy * _Dissolve_Texure_ST.xy + _Dissolve_Texure_ST.zw;
			half2 panner29 = ( 1.0 * _Time.y * appendResult27 + uvs_Dissolve_Texure.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch22 = i.uv_texcoord.w;
			#else
				float staticSwitch22 = _Dissolve_Val;
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( tex2DNode1.r * ( tex2D( _Dissolve_Texure, panner29 ).r + staticSwitch22 ) ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;25;-1519.13,274.8596;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;9;0;Create;True;0;0;0;False;0;False;0;-0.1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1528.9,175.7087;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;8;0;Create;True;0;0;0;False;0;False;0;-0.1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1287.087,-199.3038;Inherit;False;Property;_MainUpanner;Main Upanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1290.087,-122.3038;Inherit;False;Property;_MainVpanner;Main Vpanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-1214.671,203.6402;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1481.986,11.44078;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1079.087,-190.3038;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;23;-957.0497,468.9832;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1313.397,-368.5781;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;29;-1083.737,27.49051;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-956.8999,252.7;Float;False;Property;_Dissolve_Val;Dissolve_Val;6;0;Create;True;0;0;0;False;0;False;0.4823529;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-845,43.5;Inherit;True;Property;_Dissolve_Texure;Dissolve_Texure;5;0;Create;True;0;0;0;False;0;False;-1;None;d2b269416a1e846f4aa2f272f7769dc0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;22;-682.761,322.0605;Float;False;Property;_Use_Custom;Use_Custom;7;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;31;-986.0874,-349.3038;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-647,-131.5;Float;False;Property;_Main_Pow;Main_Pow;3;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-341.6,-80.3;Float;False;Property;_Main_Ins;Main_Ins;2;0;Create;True;0;0;0;False;0;False;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-552,75.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-684,-345.5;Inherit;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;b1a9e91c558e1430c8fb01da2acd7310;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-346,232.5;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;1;1.64;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-338,5.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;-309,-322.5;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;21;-73.16104,-56.53952;Float;False;Property;_Use_Custom;Use_Custom;7;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-15,78.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;49,-319.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;10,-482.5;Float;False;Property;_Tint_Color;Tint_Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;7;215,-1.5;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;18;242,-201.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;262,-319.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;440,-102.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;489,-272.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;667,-362;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Alphabled_Dissolve;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;29;0;11;0
WireConnection;29;2;27;0
WireConnection;2;1;29;0
WireConnection;22;1;6;0
WireConnection;22;0;23;4
WireConnection;31;0;30;0
WireConnection;31;2;34;0
WireConnection;5;0;2;1
WireConnection;5;1;22;0
WireConnection;1;1;31;0
WireConnection;8;0;1;1
WireConnection;8;1;5;0
WireConnection;12;0;1;0
WireConnection;12;1;13;0
WireConnection;21;1;15;0
WireConnection;21;0;23;3
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;14;0;12;0
WireConnection;14;1;21;0
WireConnection;7;0;9;0
WireConnection;16;0;17;0
WireConnection;16;1;14;0
WireConnection;20;0;18;4
WireConnection;20;1;7;0
WireConnection;19;0;16;0
WireConnection;19;1;18;0
WireConnection;0;2;19;0
WireConnection;0;9;20;0
ASEEND*/
//CHKSM=9D8E3255A26502F9C6B7401E476C8F236FE3D86D