// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Particle_Alphabled"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Main_Ins("Main_Ins", Range( 1 , 10)) = 1
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 2.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma surface surf Unlit alpha:fade keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float4 _Tint_Color;
		uniform sampler2D _Main_Texture;
		uniform float4 _Main_Texture_ST;
		uniform float _Main_Pow;
		uniform float _Main_Ins;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_Main_Texture = i.uv_texcoord;
			uvs_Main_Texture.xy = i.uv_texcoord.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			half4 tex2DNode1 = tex2D( _Main_Texture, uvs_Main_Texture.xy );
			half4 temp_cast_0 = (_Main_Pow).xxxx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch20 = i.uv_texcoord.z;
			#else
				float staticSwitch20 = _Main_Ins;
			#endif
			o.Emission = ( i.vertexColor * ( _Tint_Color * ( pow( tex2DNode1 , temp_cast_0 ) * staticSwitch20 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-865.201,-106.0431;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-148,-298.5;Float;False;Property;_Main_Ins;Main_Ins;2;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-369,-119.5;Float;False;Property;_Main_Pow;Main_Pow;1;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;19;-58.20105,-201.0431;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-651.1942,-107.6386;Inherit;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;20;153.799,-251.0431;Float;False;Property;_Use_Custom;Use_Custom;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-11.20099,113.9569;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2;-100,-428.5;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;265.799,31.9569;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;466.9622,-653.4059;Float;False;Property;_Tint_Color;Tint_Color;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;315,-430.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;16;394.799,40.9569;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;717.9622,-643.4059;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;526.9622,-281.4059;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;571.799,58.95691;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;772.9622,-319.4059;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;886,-247;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Particle_Alphabled;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;1;18;0
WireConnection;20;1;5;0
WireConnection;20;0;19;3
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;14;0;1;1
WireConnection;14;1;15;0
WireConnection;4;0;2;0
WireConnection;4;1;20;0
WireConnection;16;0;14;0
WireConnection;10;0;11;0
WireConnection;10;1;4;0
WireConnection;17;0;12;4
WireConnection;17;1;16;0
WireConnection;13;0;12;0
WireConnection;13;1;10;0
WireConnection;0;2;13;0
ASEEND*/
//CHKSM=7598ADD2038FCE7EAA5BD0F81EFB0BB78D1D54D7