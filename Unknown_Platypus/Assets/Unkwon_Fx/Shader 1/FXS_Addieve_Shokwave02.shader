// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve_Shokewave02"
{
	Properties
	{
		_FXT_GraTex01_Clamp("FXT_GraTex01_Clamp", 2D) = "white" {}
		_Gra_Offset("Gra_Offset", Range( -1 , 1)) = 0
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_Noise_Str("Noise_Str", Range( 0 , 1)) = 0
		_GraTex_Pow("GraTex_Pow", Range( 1 , 10)) = 2
		_GraTex_Ins("GraTex_Ins", Range( 1 , 10)) = 0
		[HDR]_Tint_Color("Tint_Color", Color) = (0,0,0,0)
		_Noise_UPanner("Noise_UPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector1("Vector 1", Vector) = (0,-0.05,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _TextureSample0;
		uniform float2 _Vector1;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _FXT_GraTex01_Clamp;
		uniform sampler2D _Noise_Tex;
		uniform float _Noise_UPanner;
		uniform float _Noise_VPanner;
		uniform float4 _Noise_Tex_ST;
		uniform float _Noise_Str;
		uniform float4 _FXT_GraTex01_Clamp_ST;
		uniform float _Gra_Offset;
		uniform float _GraTex_Pow;
		uniform float _GraTex_Ins;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_TextureSample0 = i.uv_texcoord;
			uvs_TextureSample0.xy = i.uv_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 panner64 = ( 1.0 * _Time.y * _Vector1 + uvs_TextureSample0.xy);
			float4 temp_cast_0 = (8.0).xxxx;
			float2 appendResult29 = (float2(_Noise_UPanner , _Noise_VPanner));
			float4 uvs_Noise_Tex = i.uv_texcoord;
			uvs_Noise_Tex.xy = i.uv_texcoord.xy * _Noise_Tex_ST.xy + _Noise_Tex_ST.zw;
			float2 panner28 = ( 1.0 * _Time.y * appendResult29 + uvs_Noise_Tex.xy);
			float4 uvs_FXT_GraTex01_Clamp = i.uv_texcoord;
			uvs_FXT_GraTex01_Clamp.xy = i.uv_texcoord.xy * _FXT_GraTex01_Clamp_ST.xy + _FXT_GraTex01_Clamp_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch33 = i.uv_texcoord.z;
			#else
				float staticSwitch33 = _Gra_Offset;
			#endif
			float2 appendResult3 = (float2(uvs_FXT_GraTex01_Clamp.xy.x , ( uvs_FXT_GraTex01_Clamp.xy.y + staticSwitch33 )));
			float temp_output_19_0 = pow( tex2D( _FXT_GraTex01_Clamp, ( ( (tex2D( _Noise_Tex, panner28 )).rga * _Noise_Str ) + float3( appendResult3 ,  0.0 ) ).xy ).r , _GraTex_Pow );
			#ifdef _USE_CUSTOM_ON
				float staticSwitch34 = i.uv_texcoord.w;
			#else
				float staticSwitch34 = _GraTex_Ins;
			#endif
			o.Emission = ( ( _Tint_Color * ( ( ( ( pow( tex2D( _TextureSample0, panner64 ) , temp_cast_0 ) * 20.0 ) + temp_output_19_0 ) * temp_output_19_0 ) * staticSwitch34 ) ) * i.vertexColor ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ( i.uv_texcoord.xy.y * ( 1.0 - i.uv_texcoord.xy.y ) ) * 4.0 ) , 4.0 ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;31;-1755.82,-435.1007;Float;False;Property;_Noise_VPanner;Noise_VPanner;9;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1756.82,-514.1007;Float;False;Property;_Noise_UPanner;Noise_UPanner;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1580.82,-490.1007;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1727,-717.5;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;28;-1402.82,-588.1007;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;32;-1169.095,170.8144;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1316.6,-8.69999;Float;False;Property;_Gra_Offset;Gra_Offset;2;0;Create;True;0;0;0;False;0;False;0;-0.87;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;33;-959.0954,89.81442;Float;False;Property;_Use_Custom;Use_Custom;10;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1171,-709.5;Inherit;True;Property;_Noise_Tex;Noise_Tex;3;0;Create;True;0;0;0;False;0;False;-1;None;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1103.6,-354.7;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-688.3381,-1068.527;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-863,-473.5;Float;False;Property;_Noise_Str;Noise_Str;4;0;Create;True;0;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;65;-644.8051,-885.7253;Float;False;Property;_Vector1;Vector 1;13;0;Create;True;0;0;0;False;0;False;0,-0.05;0,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-708.4001,-76.19998;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-852,-677.5;Inherit;True;True;True;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-559,-513.5;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;64;-425.8051,-1030.725;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-530.5995,-292.3;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;168.4844,-592.1308;Float;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3.192017,-845.5896;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;74761a463678e4f52a5551e56e3e25b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-221.5,-390.8;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;267.6024,501.371;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;55;361.1083,-822.1977;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;10.72253,3.321716;Float;True;Property;_GraTex_Pow;GraTex_Pow;5;0;Create;True;0;0;0;False;0;False;2;1.47;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;5,-277.5;Inherit;True;Property;_FXT_GraTex01_Clamp;FXT_GraTex01_Clamp;1;0;Create;True;0;0;0;False;0;False;-1;1caf87650664dee449f17bbe81f7f58e;42ce479d312017844bb356fb92789c7f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;311.6619,-581.5275;Float;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;571.2969,653.7594;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;451.8797,-561.0441;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;19;337.7225,-144.6783;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;753.2969,531.7594;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;304.7225,116.3217;Float;False;Property;_GraTex_Ins;GraTex_Ins;6;0;Create;True;0;0;0;False;0;False;0;1.09;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;572.251,-408.0637;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;35;327.5046,284.0144;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;751.1938,-206.7947;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;948.2969,529.7594;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;34;659.5046,181.0144;Float;True;Property;_Use_Custom;Use_Custom;10;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;51;1149.297,531.7594;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;25;1322.742,-209.5969;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;52;1372.297,537.7594;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;1520.053,-248.3165;Inherit;False;1425.847;544.1461;Mask;7;17;42;41;13;44;38;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1119.115,76.04504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;60;-197.3381,-793.5275;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;61;-382.3381,-700.5275;Float;False;Constant;_Vector0;Vector 0;14;0;Create;True;0;0;0;False;0;False;10,10;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1273.204,-257.9106;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;1588.2,-199.2945;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;41;2168.051,21.21385;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;17;2666.676,-140.3436;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;2398.42,-192.8061;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;1706.203,-41.21378;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;1819.232,-156.8658;Inherit;True;Property;_Mask_Noise;Mask_Noise;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;2505.39,22.54796;Float;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1503.239,-560.6393;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve_Shokewave02;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;;0;False;_ZTest_Mode;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;8;5;False;;1;False;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;24;899.069,-476.0284;Float;False;Property;_Tint_Color;Tint_Color;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;1163.592,-330.7136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;966.069,-222.0285;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;28;0;10;0
WireConnection;28;2;29;0
WireConnection;33;1;5;0
WireConnection;33;0;32;3
WireConnection;6;1;28;0
WireConnection;4;0;2;2
WireConnection;4;1;33;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;64;0;59;0
WireConnection;64;2;65;0
WireConnection;3;0;2;1
WireConnection;3;1;4;0
WireConnection;54;1;64;0
WireConnection;11;0;8;0
WireConnection;11;1;3;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;1;1;11;0
WireConnection;49;0;47;2
WireConnection;57;0;55;0
WireConnection;57;1;58;0
WireConnection;19;0;1;1
WireConnection;19;1;20;0
WireConnection;48;0;47;2
WireConnection;48;1;49;0
WireConnection;62;0;57;0
WireConnection;62;1;19;0
WireConnection;63;0;62;0
WireConnection;63;1;19;0
WireConnection;50;0;48;0
WireConnection;34;1;22;0
WireConnection;34;0;35;4
WireConnection;51;0;50;0
WireConnection;52;0;51;0
WireConnection;53;0;25;4
WireConnection;53;1;52;0
WireConnection;60;0;64;0
WireConnection;60;1;61;0
WireConnection;26;0;23;0
WireConnection;26;1;25;0
WireConnection;41;0;38;1
WireConnection;41;1;13;2
WireConnection;17;0;42;0
WireConnection;17;1;44;0
WireConnection;42;0;41;0
WireConnection;42;1;13;2
WireConnection;38;1;45;0
WireConnection;0;2;26;0
WireConnection;0;9;53;0
WireConnection;23;0;24;0
WireConnection;23;1;21;0
WireConnection;21;0;63;0
WireConnection;21;1;34;0
ASEEND*/
//CHKSM=11F7778DB6C97584D19EB941FF991971B2B79ABA