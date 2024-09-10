// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Fresnel Shpere"
{
	Properties
	{
		_Fresnel_Scale("Fresnel_Scale", Float) = 1
		_Fresnel_Pow("Fresnel_Pow", Range( 0 , 20)) = 6.235294
		[HDR]_Fresnel_Color("Fresnel_Color", Color) = (1,1,1,0)
		[HDR]_Fresnel_OutColor("Fresnel_OutColor", Color) = (1,0,0,0)
		_MainTex_VPanner("MainTex_VPanner", Float) = 0.15
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_Chromatic("Chromatic", Range( 0 , 0.1)) = 0
		_Noise_Tex("Noise_Tex", 2D) = "bump" {}
		_Noise_Val("Noise_Val", Range( 0 , 1)) = 2.32
		_Depth_Fresnel_Scale("Depth_Fresnel_Scale", Range( 0 , 1)) = 1
		_Depth_Fresnel_Pow("Depth_Fresnel_Pow", Range( 1 , 10)) = 2.058824
		[HDR]_Main_Color("Main_Color", Color) = (0,0,0,0)
		_Opactiy("Opactiy", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Noise_Tex;
		uniform float _MainTex_VPanner;
		uniform float4 _Noise_Tex_ST;
		uniform float _Noise_Val;
		uniform float _Fresnel_Scale;
		uniform float _Fresnel_Pow;
		uniform float4 _Fresnel_Color;
		uniform sampler2D _Main_Texture;
		uniform float4 _Main_Texture_ST;
		uniform float _Chromatic;
		uniform float4 _Main_Color;
		uniform float4 _Fresnel_OutColor;
		uniform float _Depth_Fresnel_Scale;
		uniform float _Depth_Fresnel_Pow;
		uniform float _Opactiy;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult20 = (float2(0.0 , _MainTex_VPanner));
			float2 uv_Noise_Tex = i.uv_texcoord * _Noise_Tex_ST.xy + _Noise_Tex_ST.zw;
			float2 panner36 = ( 1.0 * _Time.y * appendResult20 + uv_Noise_Tex);
			float4 screenColor44 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( UnpackScaleNormal( tex2D( _Noise_Tex, panner36 ), _Noise_Val ) , 0.0 ) ).xy);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV28 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode28 = ( 0.0 + _Fresnel_Scale * pow( 1.0 - fresnelNdotV28, _Fresnel_Pow ) );
			float4 temp_output_37_0 = ( saturate( fresnelNode28 ) * _Fresnel_Color );
			float2 uv_Main_Texture = i.uv_texcoord * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			float2 panner22 = ( 1.0 * _Time.y * appendResult20 + uv_Main_Texture);
			float2 temp_cast_2 = (_Chromatic).xx;
			float3 appendResult38 = (float3(tex2D( _Main_Texture, ( panner22 + _Chromatic ) ).r , tex2D( _Main_Texture, panner22 ).g , tex2D( _Main_Texture, ( panner22 - temp_cast_2 ) ).b));
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( 0.0 + _Depth_Fresnel_Scale * pow( 1.0 - fresnelNdotV1, _Depth_Fresnel_Pow ) );
			float4 lerpResult5 = lerp( ( screenColor44 + ( temp_output_37_0 * ( temp_output_37_0 + ( float4( appendResult38 , 0.0 ) * _Main_Color ) ) ) ) , _Fresnel_OutColor , saturate( fresnelNode1 ));
			o.Emission = ( i.vertexColor * lerpResult5 ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( _Opactiy ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
91;76;1658;796;999.0437;699.4879;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-2246.496,-549.83;Inherit;False;Property;_MainTex_VPanner;MainTex_VPanner;4;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2221.893,-640.7502;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-2033.635,-620.4269;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2209.242,-806.3368;Inherit;False;0;27;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;22;-1795.133,-705.501;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1910.427,-432.2731;Inherit;False;Property;_Chromatic;Chromatic;6;0;Create;True;0;0;0;False;0;False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1505.869,-1128.816;Inherit;False;Property;_Fresnel_Pow;Fresnel_Pow;1;0;Create;True;0;0;0;False;0;False;6.235294;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;27;-1534.774,-542.748;Inherit;True;Property;_Main_Texture;Main_Texture;5;0;Create;True;0;0;0;False;0;False;None;45a56c040a16d44cf876d5a5d8ac9fa5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;21;-1521.869,-1212.816;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;0;0;Create;True;0;0;0;False;0;False;1;1.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-1433.427,-273.2731;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1442.427,-786.2731;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;32;-1175.774,-780.748;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-1181.774,-286.748;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;28;-1203.659,-1270.724;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2015.583,-1530.156;Inherit;False;0;40;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1179.774,-539.748;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-755.8768,-427.5178;Inherit;False;Property;_Main_Color;Main_Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;-965.8687,-956.8158;Inherit;False;Property;_Fresnel_Color;Fresnel_Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0.564638,0.1764706,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;35;-912.8687,-1265.816;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-771.2614,-656.284;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1530.901,-1461.751;Inherit;False;Property;_Noise_Val;Noise_Val;8;0;Create;True;0;0;0;False;0;False;2.32;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;36;-1763.382,-1519.757;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;40;-1167.714,-1551.241;Inherit;True;Property;_Noise_Tex;Noise_Tex;7;0;Create;True;0;0;0;False;0;False;-1;4f96d4ef7222cda4fbc29abb96dc4423;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-705.9951,-1267.278;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-530.678,-650.6312;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;39;-1047.474,-1794.106;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-546.474,-1531.106;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-441.5588,-899.6033;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-903.9011,212.7784;Inherit;False;Property;_Depth_Fresnel_Pow;Depth_Fresnel_Pow;10;0;Create;True;0;0;0;False;0;False;2.058824;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-908.9011,126.7784;Inherit;False;Property;_Depth_Fresnel_Scale;Depth_Fresnel_Scale;9;0;Create;True;0;0;0;False;0;False;1;0.268;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-619.9009,78.77834;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-175.1385,-1043.428;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;44;-310.474,-1568.106;Inherit;False;Global;_GrabScreen0;Grab Screen 0;10;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-91.50528,-251.3644;Inherit;False;Property;_Fresnel_OutColor;Fresnel_OutColor;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;3.482202,1.291171,0.312084,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;45;158.2706,-1042.995;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;4;-335.9008,75.77834;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;121.5563,59.71213;Inherit;False;Property;_Opactiy;Opactiy;12;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;280.1563,63.61214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;49;422.8779,-465.0712;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;5;363.3951,-267.9965;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;643.3173,-440.385;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;515.4563,-5.287867;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;843.9756,-311.4728;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Fresnel Shpere;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;17;0
WireConnection;20;1;18;0
WireConnection;22;0;19;0
WireConnection;22;2;20;0
WireConnection;29;0;22;0
WireConnection;29;1;24;0
WireConnection;26;0;22;0
WireConnection;26;1;24;0
WireConnection;32;0;27;0
WireConnection;32;1;26;0
WireConnection;34;0;27;0
WireConnection;34;1;29;0
WireConnection;28;2;21;0
WireConnection;28;3;23;0
WireConnection;33;0;27;0
WireConnection;33;1;22;0
WireConnection;35;0;28;0
WireConnection;38;0;32;1
WireConnection;38;1;33;2
WireConnection;38;2;34;3
WireConnection;36;0;25;0
WireConnection;36;2;20;0
WireConnection;40;1;36;0
WireConnection;40;5;31;0
WireConnection;37;0;35;0
WireConnection;37;1;30;0
WireConnection;46;0;38;0
WireConnection;46;1;48;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;42;0;37;0
WireConnection;42;1;46;0
WireConnection;1;2;2;0
WireConnection;1;3;3;0
WireConnection;43;0;37;0
WireConnection;43;1;42;0
WireConnection;44;0;41;0
WireConnection;45;0;44;0
WireConnection;45;1;43;0
WireConnection;4;0;1;0
WireConnection;52;0;51;0
WireConnection;5;0;45;0
WireConnection;5;1;8;0
WireConnection;5;2;4;0
WireConnection;50;0;49;0
WireConnection;50;1;5;0
WireConnection;53;0;49;4
WireConnection;53;1;52;0
WireConnection;0;2;50;0
WireConnection;0;9;53;0
ASEEND*/
//CHKSM=808EC496F268BE2290270E755A44BDC2A958B48A