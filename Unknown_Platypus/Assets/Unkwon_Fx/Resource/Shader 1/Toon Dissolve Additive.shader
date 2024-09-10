// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Toon Dissolve Additive"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_MainUpanner("Main Upanner", Float) = 0
		_MainVpanner("Main Vpanner", Float) = 0
		_ColorTex("Color Tex", 2D) = "white" {}
		[HDR]_ColorFront("Color Front", Color) = (1,1,1,1)
		_ColorUpanner("Color Upanner", Float) = 0
		_ColorVpanner("Color Vpanner", Float) = 0
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _ColorFront;
		uniform sampler2D _ColorTex;
		uniform float _ColorUpanner;
		uniform float _ColorVpanner;
		uniform float4 _ColorTex_ST;
		uniform sampler2D _MainTex;
		uniform float _MainUpanner;
		uniform float _MainVpanner;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DissolveTex;
		uniform float4 _DissolveTex_ST;
		uniform float _Dissolve;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult41 = (float2(_ColorUpanner , _ColorVpanner));
			float2 uv_ColorTex = i.uv_texcoord * _ColorTex_ST.xy + _ColorTex_ST.zw;
			float2 panner42 = ( 1.0 * _Time.y * appendResult41 + uv_ColorTex);
			o.Emission = ( ( _ColorFront * tex2D( _ColorTex, panner42 ) ) * i.vertexColor ).rgb;
			float4 temp_cast_1 = (0.1).xxxx;
			float temp_output_7_0 = ( 1.0 - i.uv_texcoord.y );
			float2 appendResult5 = (float2(_MainUpanner , _MainVpanner));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner2 = ( 1.0 * _Time.y * appendResult5 + uv_MainTex);
			float4 temp_cast_2 = (3.0).xxxx;
			float2 uv_DissolveTex = i.uv_texcoord * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			o.Alpha = ( i.vertexColor.a * ( step( temp_cast_1 , pow( ( temp_output_7_0 * ( temp_output_7_0 + tex2D( _MainTex, panner2 ) ) ) , temp_cast_2 ) ) * saturate( ( tex2D( _DissolveTex, uv_DissolveTex ) + _Dissolve ) ) ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;4;-2239.735,582.4189;Inherit;False;Property;_MainVpanner;Main Vpanner;3;0;Create;True;0;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2227.29,491.4366;Inherit;False;Property;_MainUpanner;Main Upanner;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2260.29,280.9776;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-2029.29,540.4366;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-1917.29,348.4366;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1921.176,162.4074;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1706.931,392.7811;Inherit;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;0;False;0;False;-1;None;c10244bcb5987bd41b64e7758c3af36f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;-1604.337,200.8806;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;-2026.43,-500.2756;Inherit;False;1666.581;584.1042;Color;12;38;42;21;37;25;35;34;36;24;39;40;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1965.43,-102.8844;Inherit;False;Property;_ColorVpanner;Color Vpanner;7;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1976.43,-182.8844;Inherit;False;Property;_ColorUpanner;Color Upanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1491.325,693.8853;Inherit;False;0;16;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1401.118,265.6566;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1953.43,-313.8844;Inherit;False;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1123.906,440.0369;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-1792.43,-160.8844;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1148.132,214.6251;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1201.458,911.7831;Inherit;False;Property;_Dissolve;Dissolve;9;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1228.833,700.9429;Inherit;True;Property;_DissolveTex;Dissolve Tex;8;0;Create;True;0;0;0;False;0;False;-1;None;c10244bcb5987bd41b64e7758c3af36f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-853.2422,762.5527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;11;-962.7465,256.7583;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-888.1774,170.9942;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-1662.43,-252.8844;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-1435.43,-181.8844;Inherit;True;Property;_ColorTex;Color Tex;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;19;-694.9031,748.5067;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;13;-657.6821,248.0262;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-1271.664,-450.2756;Inherit;False;Property;_ColorFront;Color Front;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;5.59088,1.405038,2.129098,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;25;-854.6445,-118.1713;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-438.903,669.5067;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-905.4688,-368.2933;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-1562.725,-426.7663;Inherit;False;Property;_ColorBack;Color Back;10;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-292.8613,302.1121;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1281.726,-267.8941;Inherit;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-594.8488,-231.0391;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Toon Dissolve Additive;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;2;0;1;0
WireConnection;2;2;5;0
WireConnection;9;1;2;0
WireConnection;7;0;6;2
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;42;0;38;0
WireConnection;42;2;41;0
WireConnection;37;1;42;0
WireConnection;19;0;17;0
WireConnection;13;0;14;0
WireConnection;13;1;11;0
WireConnection;20;0;13;0
WireConnection;20;1;19;0
WireConnection;35;0;21;0
WireConnection;35;1;37;0
WireConnection;30;0;25;4
WireConnection;30;1;20;0
WireConnection;24;0;35;0
WireConnection;24;1;25;0
WireConnection;0;2;24;0
WireConnection;0;9;30;0
ASEEND*/
//CHKSM=783A42BCCB120F7ED9D762818C79E7884945A343