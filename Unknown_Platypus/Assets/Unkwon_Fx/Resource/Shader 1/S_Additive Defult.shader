// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additive Defult Zoff"
{
	Properties
	{
		_T_Shine("T_Shine", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		_Ins("Ins", Range( 1 , 50)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		ZTest Always
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _Ins;
		uniform float4 _Color0;
		uniform sampler2D _T_Shine;
		uniform float4 _T_Shine_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_T_Shine = i.uv_texcoord * _T_Shine_ST.xy + _T_Shine_ST.zw;
			o.Emission = ( i.vertexColor * ( _Ins * ( _Color0 * tex2D( _T_Shine, uv_T_Shine ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SamplerNode;1;-936,-106.5;Inherit;True;Property;_T_Shine;T_Shine;1;0;Create;True;0;0;0;False;0;False;-1;f183f90a99840c54492fafa7b757cc9c;a857c5a20ab98c14b8bba6d5fb06f352;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-884,-301;Float;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2.014218,1.133145,2.287874,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-619,-188;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-713,-388;Float;False;Property;_Ins;Ins;3;0;Create;True;0;0;0;False;0;False;1;1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-138,-457;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-395,-246;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-19,-203;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;219,-233;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Additive Defult Zoff;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;7;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;5;0
WireConnection;8;1;1;0
WireConnection;9;0;11;0
WireConnection;9;1;8;0
WireConnection;4;0;2;0
WireConnection;4;1;9;0
WireConnection;0;2;4;0
ASEEND*/
//CHKSM=87D3E8A13BCC8D085BA94F85EA579B7A2BC8D7E5