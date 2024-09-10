// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additive_Glow_Depthfade"
{
	Properties
	{
		_Glow_Ins("Glow_Ins", Range( 1 , 10)) = 1
		_Glow_Pow("Glow_Pow", Range( 1 , 10)) = 1.81
		_Depth_Fade_Val("Depth_Fade_Val", Range( 0 , 10)) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		[Toggle(_DEPTH_FADE_ON)] _Depth_Fade("Depth_Fade", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _DEPTH_FADE_ON
		#pragma surface surf Unlit keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _Glow_Pow;
		uniform float _Glow_Ins;
		uniform float4 _Color0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth_Fade_Val;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth15 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth15 = abs( ( screenDepth15 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth_Fade_Val ) );
			float4 temp_cast_0 = (distanceDepth15).xxxx;
			float4 blendOpSrc34 = temp_cast_0;
			float4 blendOpDest34 = ( ( pow( tex2D( _Texture0, uv_Texture0 ).r , _Glow_Pow ) * _Glow_Ins ) * _Color0 );
			#ifdef _DEPTH_FADE_ON
				float4 staticSwitch53 = ( saturate( ( blendOpSrc34 * blendOpDest34 ) ));
			#else
				float4 staticSwitch53 = ( ( ( pow( tex2D( _Texture0, uv_Texture0 ).r , _Glow_Pow ) * _Glow_Ins ) * _Color0 ) * saturate( pow( saturate( ( ase_worldPos.y + 0.0 ) ) , 2.0 ) ) );
			#endif
			o.Emission = ( staticSwitch53 * i.vertexColor ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;22;-1249.328,-593.3323;Inherit;False;2050.361;770.9681;보편적으로 문제없이 어디서는 사용가능합니다. 그냥 이거 쓰세요;13;46;52;47;44;42;43;51;49;1;50;28;33;54;World_Position_Depth Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-274.027,-120.1248;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;33;-1074.83,-427.9997;Float;True;Property;_Texture0;Texture 0;4;0;Create;True;0;0;0;False;0;False;c1f4ec2f109e335449b8def2d8417183;c1f4ec2f109e335449b8def2d8417183;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;37;-639.2717,-1077.092;Inherit;False;1447.002;457.7605;뎁스페이드 사용시 유의사항 : 맵 환경이 구축되어 있지 않다면(예: 포그로 배경을 처리)이상하게 나올 가능성이 큽니다.;9;32;15;17;34;27;26;6;9;7;Depth fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;32;-564.5296,-915.68;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;c1f4ec2f109e335449b8def2d8417183;c1f4ec2f109e335449b8def2d8417183;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-35.69724,-131.6852;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-701.0295,-379.4456;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;c1f4ec2f109e335449b8def2d8417183;c1f4ec2f109e335449b8def2d8417183;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-592.1138,-705.5089;Float;False;Property;_Glow_Pow;Glow_Pow;2;0;Create;True;0;0;0;False;0;False;1.81;3.11;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;49;-370.3484,-358.8776;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-235.6352,-918.5383;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;18.62553,73.3834;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-262.1575,-699.2753;Float;False;Property;_Glow_Ins;Glow_Ins;1;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;54;155.7908,-118.1041;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-628.8389,-1015.909;Float;False;Property;_Depth_Fade_Val;Depth_Fade_Val;3;0;Create;True;0;0;0;False;0;False;1;2.35;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-91.31195,-526.596;Float;False;Property;_Color0;Color 0;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;6.017189,3.649314,3.604637,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;2.624664,-914.2204;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;297.0301,-93.65928;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-102.2108,-357.2767;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;529.26,-95.01697;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;192.9919,-351.1443;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;15;167.0211,-1043.56;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;232.64,-917.595;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;34;509.3994,-942.5128;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;582.2244,-350.3347;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;53;842.9743,-655.9001;Float;False;Property;_Depth_Fade;Depth_Fade;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;13;897.5899,-328.1746;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1079.594,-613.5457;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1306.834,-620.6022;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additive_Glow_Depthfade;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;33;0
WireConnection;44;0;42;2
WireConnection;1;0;33;0
WireConnection;49;0;1;1
WireConnection;49;1;7;0
WireConnection;6;0;32;1
WireConnection;6;1;7;0
WireConnection;54;0;44;0
WireConnection;26;0;6;0
WireConnection;26;1;9;0
WireConnection;47;0;54;0
WireConnection;47;1;46;0
WireConnection;50;0;49;0
WireConnection;50;1;9;0
WireConnection;52;0;47;0
WireConnection;51;0;50;0
WireConnection;51;1;28;0
WireConnection;15;0;17;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;34;0;15;0
WireConnection;34;1;27;0
WireConnection;43;0;51;0
WireConnection;43;1;52;0
WireConnection;53;1;43;0
WireConnection;53;0;34;0
WireConnection;30;0;53;0
WireConnection;30;1;13;0
WireConnection;0;2;30;0
ASEEND*/
//CHKSM=CE5E0D4833ED73729B6A1B207287072FD6F67DA0