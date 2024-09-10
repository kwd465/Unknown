// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Ch_FX"
{
	Properties
	{
		_Vampire_diffuse("Vampire_diffuse", 2D) = "white" {}
		_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_Vampire_emission("Vampire_emission", 2D) = "white" {}
		_Vampire_normal("Vampire_normal", 2D) = "white" {}
		_Vampire_specular("Vampire_specular", 2D) = "white" {}
		_Normal_Str("Normal_Str", Range( 1 , 10)) = 3.858824
		_Emission_Str("Emission_Str", Range( 0 , 10)) = 1
		_Specular_Str("Specular_Str", Range( 1 , 10)) = 1
		_Fresnel_Pow("Fresnel_Pow", Range( 1 , 10)) = 7.035294
		_Fresnel_Texture("Fresnel_Texture", 2D) = "white" {}
		[HDR]_Fresnel_Color("Fresnel_Color", Color) = (1,1,1,1)
		_Fresnel_Ins("Fresnel_Ins", Range( 0 , 20)) = 1
		_Dissove_Texture("Dissove_Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		_Edge_Thnikness("Edge_Thnikness", Range( 0.1 , 0.5)) = 0.122
		[HDR]_Edge_Color("Edge_Color", Color) = (1,0.21698,0,1)
		_VertexNomral_Tex("VertexNomral_Tex", 2D) = "bump" {}
		_Position("Position", Vector) = (0,0,0,0)
		_Vertex_Val("Vertex_Val", Range( 0 , 1)) = 0
		_VertexNoise_Val("VertexNoise_Val", Range( 0 , 1)) = 1
		[HDR]_ColorA("ColorA", Color) = (0,0,0,0)
		[HDR]_ColorB("ColorB", Color) = (0,0,0,0)
		[Toggle(_SW_MOVEMONET_ON)] _SW_Movemonet("SW_Movemonet", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _SW_MOVEMONET_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float3 _Position;
		uniform sampler2D _VertexNomral_Tex;
		uniform float _VertexNoise_Val;
		uniform float _Vertex_Val;
		uniform sampler2D _Vampire_normal;
		uniform float4 _Vampire_normal_ST;
		uniform float _Normal_Str;
		uniform float4 _Tint_Color;
		uniform sampler2D _Vampire_diffuse;
		uniform sampler2D _Fresnel_Texture;
		uniform float4 _Fresnel_Texture_ST;
		uniform sampler2D _Vampire_emission;
		uniform float _Emission_Str;
		uniform float _Fresnel_Pow;
		uniform float _Fresnel_Ins;
		uniform float4 _Fresnel_Color;
		uniform sampler2D _Dissove_Texture;
		uniform float4 _Dissove_Texture_ST;
		uniform float _Dissolve;
		uniform float _Edge_Thnikness;
		uniform float4 _Edge_Color;
		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform sampler2D _Vampire_specular;
		uniform float4 _Vampire_specular_ST;
		uniform float _Specular_Str;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 worldToObj76 = mul( unity_WorldToObject, float4( _Position, 1 ) ).xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_74_0 = ( worldToObj76 - ase_vertex3Pos );
			#ifdef _SW_MOVEMONET_ON
				float3 staticSwitch94 = ( temp_output_74_0 + ase_vertex3Pos );
			#else
				float3 staticSwitch94 = temp_output_74_0;
			#endif
			float3 normalizeResult71 = normalize( temp_output_74_0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 panner87 = ( 1.0 * _Time.y * float2( 0,0.15 ) + v.texcoord.xy);
			float dotResult67 = dot( normalizeResult71 , ( ase_vertexNormal + ( UnpackNormal( tex2Dlod( _VertexNomral_Tex, float4( panner87, 0, 0.0) ) ).r * _VertexNoise_Val ) ) );
			float temp_output_64_0 = saturate( ( dotResult67 + (-5.0 + (_Vertex_Val - 0.0) * (5.0 - -5.0) / (1.0 - 0.0)) ) );
			float3 lerpResult73 = lerp( float3( 0,0,0 ) , staticSwitch94 , temp_output_64_0);
			v.vertex.xyz += lerpResult73;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Vampire_normal = i.uv_texcoord * _Vampire_normal_ST.xy + _Vampire_normal_ST.zw;
			float2 panner100 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uv_Vampire_normal);
			float4 tex2DNode3 = tex2D( _Vampire_normal, panner100 );
			float3 appendResult6 = (float3(( (tex2DNode3).rga * _Normal_Str ).xy , tex2DNode3.b));
			o.Normal = appendResult6;
			float2 uv_Fresnel_Texture = i.uv_texcoord * _Fresnel_Texture_ST.xy + _Fresnel_Texture_ST.zw;
			float2 panner103 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uv_Fresnel_Texture);
			o.Albedo = ( _Tint_Color * tex2D( _Vampire_diffuse, panner103 ) ).rgb;
			float2 panner106 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uv_Fresnel_Texture);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode15 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV15, _Fresnel_Pow ) );
			float temp_output_16_0 = saturate( fresnelNode15 );
			float2 panner22 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uv_Fresnel_Texture);
			float2 uv_Dissove_Texture = i.uv_texcoord * _Dissove_Texture_ST.xy + _Dissove_Texture_ST.zw;
			float temp_output_46_0 = ( tex2D( _Dissove_Texture, uv_Dissove_Texture ).r + _Dissolve );
			float temp_output_39_0 = step( 0.1 , temp_output_46_0 );
			float3 worldToObj76 = mul( unity_WorldToObject, float4( _Position, 1 ) ).xyz;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 temp_output_74_0 = ( worldToObj76 - ase_vertex3Pos );
			float3 normalizeResult71 = normalize( temp_output_74_0 );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float2 panner87 = ( 1.0 * _Time.y * float2( 0,0.15 ) + i.uv_texcoord);
			float dotResult67 = dot( normalizeResult71 , ( ase_vertexNormal + ( UnpackNormal( tex2D( _VertexNomral_Tex, panner87 ) ).r * _VertexNoise_Val ) ) );
			float temp_output_64_0 = saturate( ( dotResult67 + (-5.0 + (_Vertex_Val - 0.0) * (5.0 - -5.0) / (1.0 - 0.0)) ) );
			float4 lerpResult78 = lerp( _ColorA , _ColorB , temp_output_64_0);
			o.Emission = ( ( ( ( tex2D( _Vampire_emission, panner106 ) * _Emission_Str ) + ( ( saturate( ( temp_output_16_0 * ( temp_output_16_0 + pow( tex2D( _Fresnel_Texture, panner22 ).r , 2.65 ) ) ) ) * _Fresnel_Ins ) * _Fresnel_Color ) ) + ( ( temp_output_39_0 - step( _Edge_Thnikness , temp_output_46_0 ) ) * _Edge_Color ) ) + lerpResult78 ).rgb;
			float2 uv_Vampire_specular = i.uv_texcoord * _Vampire_specular_ST.xy + _Vampire_specular_ST.zw;
			float2 panner97 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uv_Vampire_specular);
			o.Specular = ( tex2D( _Vampire_specular, panner97 ) * _Specular_Str ).rgb;
			o.Alpha = temp_output_39_0;
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
Node;AmplifyShaderEditor.CommentaryNode;57;-2369.049,-622.375;Inherit;False;1890.916;725.3489;Fresnel;16;21;23;22;25;20;24;26;18;15;16;27;32;28;31;29;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;23;-2270.15,-61.02612;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2319.049,-210.3264;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-2172.75,-435.9263;Float;False;Property;_Fresnel_Pow;Fresnel_Pow;9;0;Create;True;0;0;0;False;0;False;7.035294;7.035294;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-2089.948,-127.2263;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;89;-1010.337,1081.274;Float;False;Constant;_Vector1;Vector 1;22;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;25;-1829.55,-246.3264;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;2.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1931.35,-144.2261;Inherit;True;Property;_Fresnel_Texture;Fresnel_Texture;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;15;-1883.75,-569.9261;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-1055.337,948.2742;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;24;-1638.65,-329.5262;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;77;-1089.991,217.5885;Float;False;Property;_Position;Position;18;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;63;-807.2198,546.0806;Inherit;False;1438.229;643.2787;Vertex Normal;13;64;65;67;66;70;72;69;71;68;86;91;92;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;87;-838.3365,964.2742;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;16;-1595.75,-571.9261;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;58;-453.7462,-629.1054;Inherit;False;1197.428;736.2998;Dissolve;11;44;42;43;38;39;40;46;41;34;47;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1370.782,-350.4565;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-585.8777,1109.647;Float;False;Property;_VertexNoise_Val;VertexNoise_Val;20;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;75;-944.9549,254.4939;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;76;-929.1356,96.0259;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-403.7462,-358.7411;Inherit;False;0;34;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;86;-687.3365,904.2744;Inherit;True;Property;_VertexNomral_Tex;VertexNomral_Tex;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-716.4365,199.5361;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;72;-599.2058,696.833;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-366.8777,962.6472;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1299.884,-566.7515;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-191.5254,-363.3202;Inherit;True;Property;_Dissove_Texture;Dissove_Texture;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-179.2152,-167.0758;Float;False;Property;_Dissolve;Dissolve;14;0;Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-583.5825,-1053.491;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;105;-534.6835,-904.1907;Float;False;Constant;_Vector5;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NormalizeNode;71;-392.301,643.741;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;69;186.8694,1028.618;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;-5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;99;-1189.04,-1251.904;Float;False;Constant;_Vector3;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;41;109.4823,-91.90623;Float;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-1237.939,-1401.204;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;106;-354.4814,-970.3912;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;68.42802,954.6222;Float;False;Property;_Vertex_Val;Vertex_Val;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;86.08232,-302.7059;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1191.146,-337.3731;Float;False;Property;_Fresnel_Ins;Fresnel_Ins;12;0;Create;True;0;0;0;False;0;False;1;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-1094.857,-572.3751;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-202.8777,724.6472;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;70;188.8694,1096.618;Float;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-30.51778,-455.706;Float;False;Property;_Edge_Thnikness;Edge_Thnikness;15;0;Create;True;0;0;0;False;0;False;0.122;0.122;0.1;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;66;358.017,970.1422;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;100;-1008.838,-1318.104;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-196.4174,-1056.346;Inherit;True;Property;_Vampire_emission;Vampire_emission;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;39;250.0822,-146.8062;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-920.7703,-571.3732;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-174.5803,-839.2058;Float;False;Property;_Emission_Str;Emission_Str;7;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;239.7824,-378.3059;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;67;43.76323,695.088;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-905.7593,-354.7016;Float;False;Property;_Fresnel_Color;Fresnel_Color;11;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;96;-1546.506,-975.6245;Float;False;Constant;_Vector2;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;44;251.6823,-579.1055;Float;False;Property;_Edge_Color;Edge_Color;16;1;[HDR];Create;True;0;0;0;False;0;False;1,0.21698,0,1;1,0.21698,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;90;-401.3533,367.1132;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-799.5234,-1304.435;Inherit;True;Property;_Vampire_normal;Vampire_normal;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;98.68268,-1045.746;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;276.7526,701.8489;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;102;78.06982,-1453.699;Float;False;Constant;_Vector4;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-713.1341,-568.1735;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;29.17078,-1603;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;-1595.405,-1124.925;Inherit;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;493.6824,-219.1061;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;103;258.2719,-1519.9;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;64;469.0788,698.9419;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;825.5987,299.6366;Float;False;Property;_ColorB;ColorB;22;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-227.4538,321.0521;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;508.6824,-524.1057;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-254.2573,-1448.155;Float;False;Property;_Normal_Str;Normal_Str;6;0;Create;True;0;0;0;False;0;False;3.858824;3.858824;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;97;-1366.304,-1041.825;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;320.668,-910.6633;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-492.6708,-1401.221;Inherit;True;True;True;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;81;825.2091,133.1624;Float;False;Property;_ColorA;ColorA;21;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1154.976,-1075.987;Inherit;True;Property;_Vampire_specular;Vampire_specular;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1114.257,-871.7068;Float;False;Property;_Specular_Str;Specular_Str;8;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;94;51.11789,212.3014;Float;False;Property;_SW_Movemonet;SW_Movemonet;23;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-176.67,-1350.221;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;78;1069.148,163.8241;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;758.7746,-330.1252;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;524.4947,-1556.601;Float;False;Property;_Tint_Color;Tint_Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;394.4315,-1367.558;Inherit;True;Property;_Vampire_diffuse;Vampire_diffuse;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-863.4568,-988.3468;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;74.09738,-1309.473;Inherit;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;1086.416,-220.8046;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;73;308.9656,195.1668;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;826.4949,-1390.601;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1365.484,-358.6489;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;KOGUN/Ch_FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;21;0
WireConnection;22;2;23;0
WireConnection;20;1;22;0
WireConnection;15;3;18;0
WireConnection;24;0;20;1
WireConnection;24;1;25;0
WireConnection;87;0;88;0
WireConnection;87;2;89;0
WireConnection;16;0;15;0
WireConnection;26;0;16;0
WireConnection;26;1;24;0
WireConnection;76;0;77;0
WireConnection;86;1;87;0
WireConnection;74;0;76;0
WireConnection;74;1;75;0
WireConnection;91;0;86;1
WireConnection;91;1;92;0
WireConnection;27;0;16;0
WireConnection;27;1;26;0
WireConnection;34;1;47;0
WireConnection;71;0;74;0
WireConnection;106;0;104;0
WireConnection;106;2;105;0
WireConnection;46;0;34;1
WireConnection;46;1;37;0
WireConnection;28;0;27;0
WireConnection;93;0;72;0
WireConnection;93;1;91;0
WireConnection;66;0;68;0
WireConnection;66;3;69;0
WireConnection;66;4;70;0
WireConnection;100;0;98;0
WireConnection;100;2;99;0
WireConnection;2;1;106;0
WireConnection;39;0;41;0
WireConnection;39;1;46;0
WireConnection;31;0;28;0
WireConnection;31;1;32;0
WireConnection;38;0;40;0
WireConnection;38;1;46;0
WireConnection;67;0;71;0
WireConnection;67;1;93;0
WireConnection;3;1;100;0
WireConnection;9;0;2;0
WireConnection;9;1;10;0
WireConnection;65;0;67;0
WireConnection;65;1;66;0
WireConnection;29;0;31;0
WireConnection;29;1;30;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;103;0;101;0
WireConnection;103;2;102;0
WireConnection;64;0;65;0
WireConnection;84;0;74;0
WireConnection;84;1;90;0
WireConnection;43;0;42;0
WireConnection;43;1;44;0
WireConnection;97;0;95;0
WireConnection;97;2;96;0
WireConnection;33;0;9;0
WireConnection;33;1;29;0
WireConnection;5;0;3;0
WireConnection;4;1;97;0
WireConnection;94;1;74;0
WireConnection;94;0;84;0
WireConnection;7;0;5;0
WireConnection;7;1;8;0
WireConnection;78;0;81;0
WireConnection;78;1;82;0
WireConnection;78;2;64;0
WireConnection;45;0;33;0
WireConnection;45;1;43;0
WireConnection;1;1;103;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;6;0;7;0
WireConnection;6;2;3;3
WireConnection;83;0;45;0
WireConnection;83;1;78;0
WireConnection;73;1;94;0
WireConnection;73;2;64;0
WireConnection;13;0;14;0
WireConnection;13;1;1;0
WireConnection;0;0;13;0
WireConnection;0;1;6;0
WireConnection;0;2;83;0
WireConnection;0;3;11;0
WireConnection;0;9;39;0
WireConnection;0;11;73;0
ASEEND*/
//CHKSM=2AC151E253AD385368C2315761F88C290F9C388C