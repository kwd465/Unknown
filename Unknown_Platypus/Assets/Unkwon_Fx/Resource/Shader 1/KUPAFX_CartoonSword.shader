// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/CartoonSword"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 20)) = 1
		_Sword_Tex("Sword_Tex", 2D) = "white" {}
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_MainColor("Main Color", Color) = (0,0,0,0)
		_Main_Tex_UPanner("Main_Tex_UPanner", Float) = 0.15
		_Main_Tex_VPanner("Main_Tex_VPanner", Float) = 0
		_Sword_Offset("Sword_Offset", Range( -1 , 1)) = -0.02044457
		[HDR]_Edge_Color("Edge_Color", Color) = (0,0,0,0)
		_Vertex_Tex("Vertex_Tex", 2D) = "white" {}
		_Vertex_Val("Vertex_Val", Range( 0 , 5)) = 0
		_Vertex_Tex_UPanner("Vertex_Tex_UPanner", Float) = 0
		_Vertex_Tex_VPanner("Vertex_Tex_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Emi_Offset("Emi_Offset", Range( -1 , 1)) = -0.2705882
		[HDR]_Emi_Color("Emi_Color", Color) = (1,0,0,1)
		_NoiseTex01("NoiseTex01", 2D) = "white" {}
		_Dissolve_Tex("Dissolve_Tex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		_UV_Noise_Tex("UV_Noise_Tex", 2D) = "bump" {}
		_Noise_Val("Noise_Val", Range( 0 , 1)) = 0
		_UV_Noise_Tex_UPanner("UV_Noise_Tex_UPanner", Float) = -0.15
		_UV_Noise_Tex_VPanner("UV_Noise_Tex_VPanner", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform sampler2D _Vertex_Tex;
		uniform float _Vertex_Tex_UPanner;
		uniform float _Vertex_Tex_VPanner;
		uniform float _Vertex_Val;
		uniform sampler2D _Sword_Tex;
		uniform float4 _Sword_Tex_ST;
		uniform float _Sword_Offset;
		uniform float4 _Edge_Color;
		uniform float4 _Emi_Color;
		uniform float _Emi_Offset;
		uniform sampler2D _NoiseTex01;
		uniform float4 _MainColor;
		uniform sampler2D _Main_Tex;
		uniform float _Main_Tex_UPanner;
		uniform float _Main_Tex_VPanner;
		uniform sampler2D _TextureSample1;
		uniform float _UV_Noise_Tex_UPanner;
		uniform float _UV_Noise_Tex_VPanner;
		uniform sampler2D _UV_Noise_Tex;
		uniform float4 _UV_Noise_Tex_ST;
		uniform float _Noise_Val;
		uniform float4 _Main_Tex_ST;
		uniform sampler2D _Dissolve_Tex;
		uniform float4 _Dissolve_Tex_ST;
		uniform float _Dissolve;
		uniform float _Opacity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult35 = (float2(_Vertex_Tex_UPanner , _Vertex_Tex_VPanner));
			float2 panner32 = ( 1.0 * _Time.y * appendResult35 + v.texcoord.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch73 = v.texcoord1.y;
			#else
				float staticSwitch73 = _Vertex_Val;
			#endif
			float3 temp_cast_0 = (( (ase_vertex3Pos).x * ( tex2Dlod( _Vertex_Tex, float4( panner32, 0, 0.0) ).r * staticSwitch73 ) )).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Sword_Tex = i.uv_texcoord * _Sword_Tex_ST.xy + _Sword_Tex_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch72 = i.uv2_texcoord2.x;
			#else
				float staticSwitch72 = _Sword_Offset;
			#endif
			float2 appendResult21 = (float2(( ( uv_Sword_Tex.x + staticSwitch72 ) * 1.0 ) , ( ( uv_Sword_Tex.y + 0.0 ) * 1.0 )));
			float4 tex2DNode1 = tex2D( _Sword_Tex, appendResult21 );
			float2 uv_TexCoord41 = i.uv_texcoord * float2( 1,1 );
			#ifdef _USE_CUSTOM_ON
				float staticSwitch77 = i.uv2_texcoord2.z;
			#else
				float staticSwitch77 = _Emi_Offset;
			#endif
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 0.5,2 );
			float2 appendResult40 = (float2(_Main_Tex_UPanner , _Main_Tex_VPanner));
			float2 appendResult124 = (float2(_UV_Noise_Tex_UPanner , _UV_Noise_Tex_VPanner));
			float2 uv_UV_Noise_Tex = i.uv_texcoord * _UV_Noise_Tex_ST.xy + _UV_Noise_Tex_ST.zw;
			float2 panner126 = ( 1.0 * _Time.y * appendResult124 + uv_UV_Noise_Tex);
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float2 panner37 = ( 1.0 * _Time.y * appendResult40 + ( ( (UnpackNormal( tex2D( _TextureSample1, panner126 ) )).xy * _Noise_Val ) + uv_Main_Tex ));
			float4 temp_output_104_0 = ( ( ( ( saturate( ( i.uv_texcoord.y + -0.9 ) ) * 39.74 ) * tex2DNode1.r ) * _Edge_Color ) + ( ( _Emi_Color * ( ( pow( saturate( ( ( 1.0 - uv_TexCoord41.x ) + staticSwitch77 ) ) , 8.0 ) * tex2D( _NoiseTex01, uv_TexCoord58 ).r ) * 45.0 ) ) + ( _MainColor * tex2D( _Main_Tex, panner37 ) ) ) );
			o.Emission = ( i.vertexColor * temp_output_104_0 ).rgb;
			float2 uv_Dissolve_Tex = i.uv_texcoord * _Dissolve_Tex_ST.xy + _Dissolve_Tex_ST.zw;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch116 = i.uv2_texcoord2.w;
			#else
				float staticSwitch116 = _Dissolve;
			#endif
			float temp_output_108_0 = ( pow( tex2D( _Dissolve_Tex, uv_Dissolve_Tex ).r , 2.0 ) + staticSwitch116 );
			float2 uv_TexCoord90 = i.uv_texcoord * float2( 0.25,2 );
			float temp_output_83_0 = pow( ( ( ( 1.0 - i.uv_texcoord.x ) * i.uv_texcoord.x ) * 4.0 ) , 4.0 );
			o.Alpha = ( i.vertexColor.a * saturate( ( ( ( tex2DNode1.r * saturate( step( 0.1 , temp_output_108_0 ) ) ) * saturate( ( ( tex2D( _NoiseTex01, uv_TexCoord90 ).r + temp_output_83_0 ) * temp_output_83_0 ) ) ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;69;-2163.245,-591.6752;Inherit;False;2059.646;676.8237;Comment;18;125;124;126;122;40;38;39;120;62;36;65;66;37;59;61;146;144;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-1917.804,-1566.42;Inherit;False;1885.012;773.4511;Emi;16;56;41;43;45;42;46;58;57;64;54;63;53;49;48;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1167.76,1044.233;Inherit;False;1623.128;621.0046;Mas_tEX;11;84;83;82;80;87;93;92;89;90;81;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-2435.638,-363.0562;Float;False;Property;_UV_Noise_Tex_UPanner;UV_Noise_Tex_UPanner;20;0;Create;True;0;0;0;False;0;False;-0.15;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-2261.968,-248.754;Float;False;Property;_UV_Noise_Tex_VPanner;UV_Noise_Tex_VPanner;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;56;-1867.804,-1419.185;Float;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-1117.76,1240.744;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;68;-1380.23,119.9855;Inherit;False;1272.787;430.9325;Comment;11;22;23;16;25;18;17;19;20;21;1;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;-2156.294,-369.0717;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;125;-2282.3,-521.9607;Inherit;False;0;120;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;115;-585.3958,581.7457;Inherit;False;1122;438.0001;Dissolve_Tex;10;110;107;112;109;111;108;116;128;148;149;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1091.229,501.9852;Float;False;Property;_Sword_Offset;Sword_Offset;6;0;Create;True;0;0;0;False;0;False;-0.02044457;-0.239;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;78;-1797.858,-1027.544;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1659.638,-1429.835;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;71;-1824.56,455.1664;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-535.3958,631.7457;Inherit;False;0;107;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1798.732,-1163.577;Float;False;Property;_Emi_Offset;Emi_Offset;12;0;Create;True;0;0;0;False;0;False;-0.2705882;0.333;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;126;-2011.3,-509.9607;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;81;-757.9265,1094.233;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-1446.582,-1400.142;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;107;-323.2021,645.1093;Inherit;True;Property;_Dissolve_Tex;Dissolve_Tex;16;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;144;-1994.851,-370.544;Inherit;True;Property;_TextureSample1;Texture Sample 1;23;0;Create;True;0;0;0;False;0;False;-1;be09a8cd50a86a0458240d4279757fa9;be09a8cd50a86a0458240d4279757fa9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-705.0453,1275.953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1330.23,169.9852;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1119.996,434.9178;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;77;-1531.47,-1121.689;Float;False;Property;_Use_Custom;Use_Custom;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;72;-748.9485,412.3472;Float;False;Property;_Use_Custom;Use_Custom;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-409.3958,829.7458;Float;False;Property;_Dissolve;Dissolve;17;0;Create;True;0;0;0;False;0;False;0;0.778;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-68.39577,803.7457;Float;False;Constant;_Float8;Float 8;18;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-843.2291,202.9854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;146;-1699.705,-271.3109;Inherit;True;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-825.2291,298.9851;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-445.6881,1526.38;Float;False;Constant;_Float5;Float 5;16;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-955.2291,355.9851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;110;-13.39575,669.7457;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-513.0448,1280.953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-1328.946,-1300.034;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;88;-2201.919,-782.6299;Float;True;Property;_NoiseTex01;NoiseTex01;14;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;62;-1578.245,-347.675;Float;False;Property;_Noise_Val;Noise_Val;19;0;Create;True;0;0;0;False;0;False;0;0.041;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;119;156.8159,-1190.823;Inherit;False;1317.37;554.6667;Edge;9;94;95;106;97;99;100;103;98;96;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-588.2675,1060.54;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.25,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;116;-152.9762,912.4847;Float;False;Property;_Use_Custom;Use_Custom;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;83;-317.4749,1275.953;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1082.375,-1461.75;Float;False;Constant;_Float0;Float 0;25;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;321.1261,-752.1559;Float;False;Constant;_Float6;Float 6;15;0;Create;True;0;0;0;False;0;False;-0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-684.2289,334.9851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-322.8629,1087.748;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;108;135.6042,667.7457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1256.162,-406.0692;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1493.247,-28.11597;Float;False;Property;_Main_Tex_VPanner;Main_Tex_VPanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-1117.905,-1338.42;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1494.917,-108.4182;Float;False;Property;_Main_Tex_UPanner;Main_Tex_UPanner;4;0;Create;True;0;0;0;False;0;False;0.15;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;152.6301,926.8623;Float;False;Constant;_Float1;Float 1;28;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;206.8159,-1016.478;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1255.138,-194.1111;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-692.2288,184.9853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1421.379,-1015.872;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;67;-785.4817,1704.426;Inherit;False;1274;678.0004;Comment;12;34;33;31;35;32;29;28;26;27;30;73;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;57;-1040.766,-1073.267;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;ed1120ebec2ac9c4d8f70e0b003dfec2;ed1120ebec2ac9c4d8f70e0b003dfec2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;148;341.1072,759.3407;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-4.268215,1152.54;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-563.2289,211.9853;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1012.815,-351.6166;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;64;-922.0217,-1379.952;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;451.0409,-975.5426;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1285.573,-73.4337;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-735.4817,2184.428;Float;False;Property;_Vertex_Tex_UPanner;Vertex_Tex_UPanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;37;-900.9741,-100.8691;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-646.101,-1335.16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-731.4817,2266.428;Float;False;Property;_Vertex_Tex_VPanner;Vertex_Tex_VPanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;106;652.9218,-966.8271;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;113;550.6853,702.7728;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-730.4885,-1103.865;Float;True;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-394.8252,173.5162;Inherit;True;Property;_Sword_Tex;Sword_Tex;1;0;Create;True;0;0;0;False;0;False;-1;4afb851ce3144434a8c0db5ca021c1da;4afb851ce3144434a8c0db5ca021c1da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;98;588.3203,-766.1191;Float;False;Constant;_Float7;Float 7;15;0;Create;True;0;0;0;False;0;False;39.74;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;22.73166,1362.54;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;-510.6859,-449.5021;Float;False;Property;_MainColor;Main Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.270282,0.9099494,1.95504,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;35;-489.4817,2167.428;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-592.4816,2028.428;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-375.2418,-1217.11;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-573.3036,-246.3519;Inherit;True;Property;_Main_Tex;Main_Tex;2;0;Create;True;0;0;0;False;0;False;-1;ed1120ebec2ac9c4d8f70e0b003dfec2;ed1120ebec2ac9c4d8f70e0b003dfec2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;847.4779,-949.6465;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;87;245.6417,1122.464;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-493.006,-1521.523;Float;False;Property;_Emi_Color;Emi_Color;13;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;0.3174618,0.7735849,0.6475509,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;688.0286,486.2889;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;103;949.424,-1140.823;Float;False;Property;_Edge_Color;Edge_Color;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1.624575,2.897891,2.429545,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-265.5994,-308.2961;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;892.4288,484.9251;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;905.9166,727.6434;Float;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;0;False;0;False;1;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;1043.849,-942.3766;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-154.3811,-1344.756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;32;-373.4815,2105.428;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-306.0406,2247.811;Float;False;Property;_Vertex_Val;Vertex_Val;9;0;Create;True;0;0;0;False;0;False;0;0.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;514.8935,-234.1015;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;73;40.26527,2240.616;Float;False;Property;_Use_Custom;Use_Custom;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1239.186,-940.5896;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-177.4816,2031.428;Inherit;True;Property;_Vertex_Tex;Vertex_Tex;8;0;Create;True;0;0;0;False;0;False;-1;9f929de5b036eef4b885dc47b839f226;9f929de5b036eef4b885dc47b839f226;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;1269.153,414.8013;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;26;-133.4814,1761.427;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;132;95.60864,1767.9;Inherit;True;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;1015.935,-100.1006;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;127;1602.767,383.3575;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;74;2010.652,-341.4279;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;141;1702.71,554.9103;Inherit;False;1265.604;448.5886;DIS;5;137;135;136;138;139;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;215.9353,2028.405;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-1641.3,-538.9607;Inherit;True;Property;_UV_Noise_Tex;UV_Noise_Tex;18;0;Create;True;0;0;0;False;0;False;-1;None;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1850.873,136.5994;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;128;346.0674,554.6749;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;1752.71,803.8788;Float;False;Property;_Normal_Scale;Normal_Scale;24;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;2282.156,220.9347;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CeilOpNode;147;345.9968,366.5563;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;333.9552,1767.256;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;2504.638,-128.4724;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;135;2058.314,604.9103;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;137;2597.314,649.9103;Float;False;Global;_GrabScreen0;Grab Screen 0;25;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;138;2004.079,773.4989;Inherit;True;Property;_FXT_Noise_Normal;FXT_Noise_Normal;22;0;Create;True;0;0;0;False;0;False;-1;be09a8cd50a86a0458240d4279757fa9;be09a8cd50a86a0458240d4279757fa9;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;136;2370.314,683.9103;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2792.4,-166.8513;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/CartoonSword;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;41;0;56;0
WireConnection;126;0;125;0
WireConnection;126;2;124;0
WireConnection;81;0;79;1
WireConnection;43;0;41;1
WireConnection;107;1;112;0
WireConnection;144;1;126;0
WireConnection;80;0;81;0
WireConnection;80;1;79;1
WireConnection;77;1;45;0
WireConnection;77;0;78;3
WireConnection;72;1;22;0
WireConnection;72;0;71;1
WireConnection;17;0;16;1
WireConnection;17;1;72;0
WireConnection;146;0;144;0
WireConnection;18;0;16;2
WireConnection;18;1;23;0
WireConnection;110;0;107;1
WireConnection;110;1;111;0
WireConnection;82;0;80;0
WireConnection;42;0;43;0
WireConnection;42;1;77;0
WireConnection;116;1;109;0
WireConnection;116;0;71;4
WireConnection;83;0;82;0
WireConnection;83;1;84;0
WireConnection;20;0;18;0
WireConnection;20;1;25;0
WireConnection;89;0;88;0
WireConnection;89;1;90;0
WireConnection;108;0;110;0
WireConnection;108;1;116;0
WireConnection;61;0;146;0
WireConnection;61;1;62;0
WireConnection;46;0;42;0
WireConnection;19;0;17;0
WireConnection;19;1;25;0
WireConnection;57;0;88;0
WireConnection;57;1;58;0
WireConnection;148;0;149;0
WireConnection;148;1;108;0
WireConnection;92;0;89;1
WireConnection;92;1;83;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;59;0;61;0
WireConnection;59;1;36;0
WireConnection;64;0;46;0
WireConnection;64;1;131;0
WireConnection;95;0;94;2
WireConnection;95;1;96;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;37;0;59;0
WireConnection;37;2;40;0
WireConnection;63;0;64;0
WireConnection;63;1;57;1
WireConnection;106;0;95;0
WireConnection;113;0;148;0
WireConnection;1;1;21;0
WireConnection;93;0;92;0
WireConnection;93;1;83;0
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;53;0;63;0
WireConnection;53;1;54;0
WireConnection;5;1;37;0
WireConnection;97;0;106;0
WireConnection;97;1;98;0
WireConnection;87;0;93;0
WireConnection;114;0;1;1
WireConnection;114;1;113;0
WireConnection;65;0;66;0
WireConnection;65;1;5;0
WireConnection;86;0;114;0
WireConnection;86;1;87;0
WireConnection;99;0;97;0
WireConnection;99;1;1;1
WireConnection;48;0;49;0
WireConnection;48;1;53;0
WireConnection;32;0;31;0
WireConnection;32;2;35;0
WireConnection;50;0;48;0
WireConnection;50;1;65;0
WireConnection;73;1;28;0
WireConnection;73;0;71;2
WireConnection;100;0;99;0
WireConnection;100;1;103;0
WireConnection;29;1;32;0
WireConnection;117;0;86;0
WireConnection;117;1;118;0
WireConnection;132;0;26;0
WireConnection;104;0;100;0
WireConnection;104;1;50;0
WireConnection;127;0;117;0
WireConnection;27;0;29;1
WireConnection;27;1;73;0
WireConnection;120;1;126;0
WireConnection;76;0;74;4
WireConnection;76;1;127;0
WireConnection;128;0;108;0
WireConnection;143;0;104;0
WireConnection;143;1;137;0
WireConnection;147;0;108;0
WireConnection;30;0;132;0
WireConnection;30;1;27;0
WireConnection;75;0;74;0
WireConnection;75;1;104;0
WireConnection;137;0;136;0
WireConnection;138;5;139;0
WireConnection;136;0;135;0
WireConnection;136;1;138;0
WireConnection;0;2;75;0
WireConnection;0;9;76;0
WireConnection;0;11;30;0
ASEEND*/
//CHKSM=C21587758A284FD14A3095953D35B26C061E5E78