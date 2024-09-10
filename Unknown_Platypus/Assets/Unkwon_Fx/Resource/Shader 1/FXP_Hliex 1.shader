// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alpha_Helix"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (1.741101,1.741101,1.741101,0)
		_Opacity("Opacity", Range( 1 , 20)) = 0
		_Offset("Offset", Range( -1 , 1)) = 0
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_MainPow("MainPow", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 2.0
		#pragma shader_feature_local _KEYWORD0_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform half _Offset;
		uniform half _MainPow;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_TextureSample0 = i.uv_texcoord;
			uvs_TextureSample0.xy = i.uv_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			#ifdef _KEYWORD0_ON
				half staticSwitch27 = i.uv_texcoord.z;
			#else
				half staticSwitch27 = _Offset;
			#endif
			half4 appendResult6 = (half4(( uvs_TextureSample0.xy.x + staticSwitch27 ) , ( uvs_TextureSample0.xy.y + 0.0 ) , 0.0 , 0.0));
			half4 tex2DNode1 = tex2D( _TextureSample0, appendResult6.xy );
			o.Emission = ( i.vertexColor * ( _Color0 * pow( tex2DNode1.r , _MainPow ) ) ).rgb;
			float4 uvs_TextureSample1 = i.uv_texcoord;
			uvs_TextureSample1.xy = i.uv_texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Alpha = ( i.vertexColor.a * ( ( ( tex2DNode1.r * saturate( pow( ( ( ( 1.0 - i.uv_texcoord.xy.x ) * i.uv_texcoord.xy.x ) * 4.0 ) , 2.0 ) ) ) * UnpackNormal( tex2D( _TextureSample1, uvs_TextureSample1.xy ) ) ) * _Opacity ) ).x;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;20;-1339.872,337.7145;Inherit;False;1293.268;452.6621;Comment;8;22;18;16;19;13;17;15;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1313.238,460.4061;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1074.207,262.626;Inherit;False;Property;_Offset;Offset;4;0;Create;True;0;0;0;False;0;False;0;-0.51;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;9;-1059.033,87.71339;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-1099.238,423.4061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1108.238,549.4059;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;27;-793.1368,135.1461;Inherit;False;Property;_Keyword0;Keyword 0;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1109.028,-224.2586;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-953.2379,455.4061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-811.2379,456.4061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-828.2379,553.4061;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-713.2277,-126.7839;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-720.2277,2.216088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-455.8524,557.7037;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-546.2277,-88.78393;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;22;-217.7026,547.4084;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-511.4854,830.8769;Inherit;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-403.4816,-118.5685;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;29293a114026f2c4e9520f2e8e1c442e;065962b2abfde4f6fa3aaaad7a4a7fab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-144.2925,105.3531;Inherit;False;Property;_MainPow;MainPow;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-266.2997,825.1304;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;be09a8cd50a86a0458240d4279757fa9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;152.877,37.42858;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-2,-304.5;Float;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;1.741101,1.741101,1.741101,0;1.741101,1.741101,1.741101,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;28;7.228436,-115.4681;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;335.1403,381.7246;Float;True;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;0;7.16;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;203.0009,445.8587;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;328,-185.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;10;295,-371.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;499.4338,119.2772;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;580.572,-128.7586;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;500,-264.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;836.194,-216.6386;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Alpha_Helix;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;12;1
WireConnection;27;1;26;0
WireConnection;27;0;9;3
WireConnection;13;0;15;0
WireConnection;13;1;12;1
WireConnection;16;0;13;0
WireConnection;16;1;17;0
WireConnection;5;0;4;1
WireConnection;5;1;27;0
WireConnection;7;0;4;2
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;22;0;18;0
WireConnection;1;1;6;0
WireConnection;31;1;30;0
WireConnection;21;0;1;1
WireConnection;21;1;22;0
WireConnection;28;0;1;1
WireConnection;28;1;29;0
WireConnection;32;0;21;0
WireConnection;32;1;31;0
WireConnection;2;0;3;0
WireConnection;2;1;28;0
WireConnection;24;0;32;0
WireConnection;24;1;25;0
WireConnection;23;0;10;4
WireConnection;23;1;24;0
WireConnection;11;0;10;0
WireConnection;11;1;2;0
WireConnection;0;2;11;0
WireConnection;0;9;23;0
ASEEND*/
//CHKSM=6223A22D3F65481B58349E437E49085D4FEA5D3B