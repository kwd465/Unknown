// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alphablend_ToonSmoke"
{
	Properties
	{
		_FXT_smoke01_seq("FXT_smoke01_seq", 2D) = "white" {}
		_Smoke_Pow("Smoke_Pow", Range( 1 , 10)) = 1
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_Rot_Time("Rot_Time", Float) = 0
		_Opacity("Opacity", Range( 0 , 10)) = 1
		_Dissolve_Texture("Dissolve_Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = -0.5294118
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _FXT_smoke01_seq;
		uniform float4 _FXT_smoke01_seq_ST;
		uniform float _Smoke_Pow;
		uniform sampler2D _Dissolve_Texture;
		uniform float4 _Dissolve_Texture_ST;
		uniform float _Rot_Time;
		uniform float _Dissolve;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_FXT_smoke01_seq = i.uv_texcoord;
			uvs_FXT_smoke01_seq.xy = i.uv_texcoord.xy * _FXT_smoke01_seq_ST.xy + _FXT_smoke01_seq_ST.zw;
			float4 tex2DNode1 = tex2D( _FXT_smoke01_seq, uvs_FXT_smoke01_seq.xy );
			float4 temp_cast_0 = (_Smoke_Pow).xxxx;
			o.Emission = ( i.vertexColor * ( _Tint_Color * pow( tex2DNode1 , temp_cast_0 ) ) ).rgb;
			float4 uvs_Dissolve_Texture = i.uv_texcoord;
			uvs_Dissolve_Texture.xy = i.uv_texcoord.xy * _Dissolve_Texture_ST.xy + _Dissolve_Texture_ST.zw;
			float2 temp_cast_2 = (0.5).xx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch25 = i.uv_texcoord.w;
			#else
				float staticSwitch25 = _Rot_Time;
			#endif
			float cos12 = cos( staticSwitch25 );
			float sin12 = sin( staticSwitch25 );
			float2 rotator12 = mul( uvs_Dissolve_Texture.xy - temp_cast_2 , float2x2( cos12 , -sin12 , sin12 , cos12 )) + temp_cast_2;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch24 = i.uv_texcoord.z;
			#else
				float staticSwitch24 = _Dissolve;
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( tex2DNode1.r * step( 0.1 , ( tex2D( _Dissolve_Texture, rotator12 ).r + staticSwitch24 ) ) ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-754,401.5;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1274,331.5;Float;False;Property;_Rot_Time;Rot_Time;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1166,115.5;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1175,-25.5;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;25;-1069,338.5;Float;False;Property;_Use_Custom;Use_Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-825,280.5;Float;False;Property;_Dissolve;Dissolve;6;0;Create;True;0;0;0;False;0;False;-0.5294118;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;12;-913,58.5;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-691,37.5;Inherit;True;Property;_Dissolve_Texture;Dissolve_Texture;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;24;-477,348.5;Float;False;Property;_Use_Custom;Use_Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-350,75.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-818,-345.5;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-335,-29.5;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-563,-348.5;Inherit;True;Property;_FXT_smoke01_seq;FXT_smoke01_seq;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;5;-84,19.5;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;139,-130.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;158,121.5;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;1;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-532,-144.5;Float;False;Property;_Smoke_Pow;Smoke_Pow;1;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;461,-7.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-235,-577.5;Float;False;Property;_Tint_Color;Tint_Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;18;-100,-329.5;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;135,-396.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;22;675,-20.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;25,-636.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;414,-571.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;797,-176.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1013,-345;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Alphablend_ToonSmoke;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;1;15;0
WireConnection;25;0;7;4
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;12;2;25;0
WireConnection;2;1;12;0
WireConnection;24;1;4;0
WireConnection;24;0;7;3
WireConnection;3;0;2;1
WireConnection;3;1;24;0
WireConnection;1;1;23;0
WireConnection;5;0;6;0
WireConnection;5;1;3;0
WireConnection;10;0;1;1
WireConnection;10;1;5;0
WireConnection;20;0;10;0
WireConnection;20;1;21;0
WireConnection;18;0;1;0
WireConnection;18;1;19;0
WireConnection;16;0;17;0
WireConnection;16;1;18;0
WireConnection;22;0;20;0
WireConnection;9;0;8;0
WireConnection;9;1;16;0
WireConnection;11;0;8;4
WireConnection;11;1;22;0
WireConnection;0;2;9;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=1AE5F7320321F842207AD7381978510EA3160415