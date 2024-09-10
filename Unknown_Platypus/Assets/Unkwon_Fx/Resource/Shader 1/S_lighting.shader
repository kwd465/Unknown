// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve Lighting"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_MainPow("Main Pow", Range( 1 , 10)) = 3.329412
		_MainIns("Main Ins", Range( 1 , 20)) = 1
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 1
		[Toggle(_USECUSTOMDATAXY_ON)] _UseCustomDataXY("Use Custom Data XY", Float) = 0
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
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOMDATAXY_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _MainPow;
		uniform float _MainIns;
		uniform sampler2D _DissolveTexture;
		uniform float4 _DissolveTexture_ST;
		uniform float _Dissolve;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MainTexture = i.uv_texcoord;
			uvs_MainTexture.xy = i.uv_texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
			#ifdef _USECUSTOMDATAXY_ON
				float staticSwitch20 = i.uv_texcoord.w;
			#else
				float staticSwitch20 = _MainIns;
			#endif
			float4 uvs_DissolveTexture = i.uv_texcoord;
			uvs_DissolveTexture.xy = i.uv_texcoord.xy * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
			#ifdef _USECUSTOMDATAXY_ON
				float staticSwitch19 = i.uv_texcoord.z;
			#else
				float staticSwitch19 = _Dissolve;
			#endif
			o.Emission = ( i.vertexColor * ( ( _TintColor * ( pow( tex2D( _MainTexture, uvs_MainTexture.xy ).r , _MainPow ) * staticSwitch20 ) ) * saturate( ( tex2D( _DissolveTexture, uvs_DissolveTexture.xy ).r + staticSwitch19 ) ) ) ).rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1628.931,-503.8849;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1247.731,-114.6849;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1359,-477.0999;Inherit;True;Property;_MainTexture;Main Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;18;-1162.065,147.0293;Inherit;True;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1158.41,66.1965;Float;False;Property;_Dissolve;Dissolve;6;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1243.732,-209.9086;Float;False;Property;_MainIns;Main Ins;3;0;Create;True;0;0;0;False;0;False;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1322,-276.1;Float;False;Property;_MainPow;Main Pow;2;0;Create;True;0;0;0;False;0;False;3.329412;3.329412;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;19;-881.0557,148.8146;Float;True;Property;_UseCustomDataXY;Use Custom Data XY;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2;-1045,-469.0999;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1006.41,-106.8035;Inherit;True;Property;_DissolveTexture;Dissolve Texture;5;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;20;-965.031,-226.2585;Float;False;Property;_UseCustomDataXY;Use Custom Data XY;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-687.4097,-75.80348;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-796.2255,-640.0157;Float;False;Property;_TintColor;Tint Color;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2.433572,1.974888,0.3694952,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-796,-471.0999;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-539.0254,-482.8156;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-489.4097,-77.80348;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;9;-259.435,-726.5757;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-269.2935,-323.1949;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-14.83501,-493.7756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;375.7,-593.3;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve Lighting;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;1;15;0
WireConnection;19;1;13;0
WireConnection;19;0;18;3
WireConnection;2;0;1;1
WireConnection;2;1;4;0
WireConnection;11;1;16;0
WireConnection;20;1;6;0
WireConnection;20;0;18;4
WireConnection;12;0;11;1
WireConnection;12;1;19;0
WireConnection;5;0;2;0
WireConnection;5;1;20;0
WireConnection;8;0;7;0
WireConnection;8;1;5;0
WireConnection;14;0;12;0
WireConnection;17;0;8;0
WireConnection;17;1;14;0
WireConnection;10;0;9;0
WireConnection;10;1;17;0
WireConnection;0;2;10;0
WireConnection;0;9;9;4
ASEEND*/
//CHKSM=ED8703CEA38D50192A7CD5A40372F07563B8211C