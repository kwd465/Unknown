// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Ice FX"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_Ins("Ins", Range( 1 , 10)) = 1
		_FresnelColor("Fresnel Color", Color) = (0,0,0,0)
		_FresnelIns("Fresnel Ins", Range( 1 , 10)) = 0
		_FresnelScale("Fresnel Scale", Range( 0 , 2)) = 1
		_FresnelPow("Fresnel Pow", Range( 1 , 5)) = 2
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 2.0
		#pragma surface surf Unlit keepalpha 
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			float2 uv_texcoord;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform float4 _FresnelColor;
		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform float _NormalScale;
		uniform float _FresnelScale;
		uniform float _FresnelPow;
		uniform float _FresnelIns;
		uniform float _Ins;
		uniform float4 _BaseColor;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV6 = dot( mul(ase_tangentToWorldFast,UnpackScaleNormal( tex2D( _NormalTexture, uv_NormalTexture ), _NormalScale )), ase_worldViewDir );
			float fresnelNode6 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV6, _FresnelPow ) );
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			o.Emission = ( i.vertexColor * ( ( ( _FresnelColor * saturate( fresnelNode6 ) ) * _FresnelIns ) + ( _Ins * ( _BaseColor * tex2D( _MainTexture, uv_MainTexture ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;16;-1623.176,-872.0621;Inherit;False;1553.905;496.4211;Fresnel;11;11;13;12;10;9;7;8;14;15;6;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1543.662,-814.1005;Inherit;False;0;14;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1564.176,-698.2974;Float;False;Property;_NormalScale;Normal Scale;13;0;Create;True;0;0;0;False;0;False;0;2.94;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1274.542,-510.9285;Float;False;Property;_FresnelPow;Fresnel Pow;11;0;Create;True;0;0;0;False;0;False;2;3.153;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-1285.451,-794.334;Inherit;True;Property;_NormalTexture;Normal Texture;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1272.542,-585.9284;Float;False;Property;_FresnelScale;Fresnel Scale;10;0;Create;True;0;0;0;False;0;False;1;0.872;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;6;-956.8507,-632.641;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-858.306,-67.07721;Inherit;True;Property;_MainTexture;Main Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;40;-499.4761,-3.68197;Inherit;False;773.412;303.5165;Dissolve;4;35;37;38;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;9;-816.0758,-822.0621;Float;False;Property;_FresnelColor;Fresnel Color;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.5801887,0.874786,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-845.0601,-326.0865;Float;False;Property;_BaseColor;Base Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.6944642,0.8645145,0.9622642,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-704.8507,-633.641;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-484.0784,-823.764;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-567.6807,-259.9529;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-618.6011,96.46352;Float;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;0;False;0;False;0;0.676;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;45;-591.6361,172.0627;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-477.2715,-572.3503;Float;False;Property;_FresnelIns;Fresnel Ins;9;0;Create;True;0;0;0;False;0;False;0;1.63;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-592.963,-327.2627;Float;False;Property;_Ins;Ins;3;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-2005.55,-384.6881;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;44;-349.4187,106.9468;Float;False;Property;_UseParticle;Use Particle;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-1766.746,-385.9058;Inherit;True;Property;_NoiseTexutre;Noise Texutre;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-245.2716,-809.3503;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-320.7118,-277.6013;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-119.9981,-94.17041;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-130.021,46.31805;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;108.6879,-127.4003;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;42;13.13723,-601.1436;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-16.83252,-346.7341;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;340.6164,-285.6087;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;296.7504,-486.0259;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;38;81.136,35.13454;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1433.379,57.15973;Float;False;Property;_MainUPanner;Main UPanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1726.269,-185.1216;Float;False;Property;_ParallaxH;Parallax H;15;0;Create;True;0;0;0;False;0;False;1;1.205882;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;28;-1712.875,-40.4882;Float;True;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-1720.269,-124.5216;Float;False;Property;_ParallaxOffset;Parallax Offset;16;0;Create;True;0;0;0;False;0;False;1;4.71;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1459.269,-346.1216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1389.935,-64.91754;Inherit;False;0;14;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;27;-1362.271,-224.8954;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;20;-1104.392,8.636141;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1431.379,131.1599;Float;False;Property;_MainVPanner;Main VPanner;7;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1239.379,73.15979;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1133.47,-289.1824;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;506.9333,-468.5259;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Ice FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;1;24;0
WireConnection;14;5;15;0
WireConnection;6;0;14;0
WireConnection;6;2;7;0
WireConnection;6;3;8;0
WireConnection;11;0;6;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;44;1;37;0
WireConnection;44;0;45;3
WireConnection;29;1;33;0
WireConnection;12;0;10;0
WireConnection;12;1;13;0
WireConnection;4;0;5;0
WireConnection;4;1;3;0
WireConnection;35;0;29;1
WireConnection;35;1;44;0
WireConnection;26;0;25;0
WireConnection;18;0;12;0
WireConnection;18;1;4;0
WireConnection;43;0;42;4
WireConnection;43;1;26;0
WireConnection;41;0;42;0
WireConnection;41;1;18;0
WireConnection;38;0;35;0
WireConnection;30;0;29;1
WireConnection;30;1;31;0
WireConnection;27;0;30;0
WireConnection;27;1;32;0
WireConnection;27;2;28;0
WireConnection;20;0;34;0
WireConnection;20;2;23;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;34;0;27;0
WireConnection;34;1;19;0
WireConnection;0;2;41;0
ASEEND*/
//CHKSM=00E334D2A96495CBDCE5F77F9C61380CBA30DE0D