// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alphablend_Panner"
{
	Properties
	{
		_Main_Texture("Main_Texture", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_Vector0("Vector 0", Vector) = (1,0,0,0)
		_MainPow("Main Pow", Float) = 3.81
		_Opacity("Opacity", Range( 0 , 10)) = 1
		_MaskPow("Mask Pow", Float) = 4
		_MaskTexture("Mask Texture", 2D) = "white" {}
		_MaskUpanner("Mask Upanner", Float) = 0
		_MaskVpanner("Mask Vpanner", Float) = 0
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_DissolveU_Panner("DissolveU_Panner", Float) = 0
		_DissolveV_Paaner("Dissolve V_Paaner", Float) = 0
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USECUSTOM_ON
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
		uniform sampler2D _Main_Texture;
		uniform float2 _Vector0;
		uniform float4 _Main_Texture_ST;
		uniform float _MainPow;
		uniform sampler2D _MaskTexture;
		uniform float _MaskUpanner;
		uniform float _MaskVpanner;
		uniform float4 _MaskTexture_ST;
		uniform float _MaskPow;
		uniform sampler2D _DissolveTex;
		uniform float _DissolveU_Panner;
		uniform float _DissolveV_Paaner;
		uniform float _Dissolve;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( _Tint_Color * i.vertexColor ).rgb;
			float4 uvs_Main_Texture = i.uv_texcoord;
			uvs_Main_Texture.xy = i.uv_texcoord.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
			float2 panner3 = ( 1.0 * _Time.y * _Vector0 + uvs_Main_Texture.xy);
			float temp_output_10_0 = pow( ( 1.0 - abs( ( i.uv_texcoord.xy.y - 0.5 ) ) ) , _MainPow );
			float2 appendResult33 = (float2(_MaskUpanner , _MaskVpanner));
			float4 uvs_MaskTexture = i.uv_texcoord;
			uvs_MaskTexture.xy = i.uv_texcoord.xy * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float2 panner32 = ( 1.0 * _Time.y * appendResult33 + uvs_MaskTexture.xy);
			float2 appendResult39 = (float2(_DissolveU_Panner , _DissolveV_Paaner));
			float2 panner40 = ( 1.0 * _Time.y * appendResult39 + i.uv_texcoord.xy);
			#ifdef _USECUSTOM_ON
				float staticSwitch44 = i.uv_texcoord.z;
			#else
				float staticSwitch44 = _Dissolve;
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( ( ( ( tex2D( _Main_Texture, panner3 ).r + temp_output_10_0 ) * temp_output_10_0 ) * pow( tex2D( _MaskTexture, panner32 ).r , _MaskPow ) ) * ( tex2D( _DissolveTex, panner40 ).r * staticSwitch44 ) ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-315,313.5;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-305,541.5;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-81,368.5;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-627.1226,1098.537;Inherit;False;Property;_MaskUpanner;Mask Upanner;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;8;112,358.5;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-621.1226,1202.537;Inherit;False;Property;_MaskVpanner;Mask Vpanner;8;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-412,70.5;Float;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-563.3987,-213.1269;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;9;259,357.5;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;260,582.5;Float;False;Property;_MainPow;Main Pow;3;0;Create;True;0;0;0;False;0;False;3.81;3.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;3;-248,22.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-424.1226,1129.537;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-561.0493,825.3867;Inherit;True;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-310.2892,1570.745;Inherit;False;Property;_DissolveU_Panner;DissolveU_Panner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-293.4285,1698.886;Inherit;False;Property;_DissolveV_Paaner;Dissolve V_Paaner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-97.84451,1609.525;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;10;438,365.5;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-277.1226,915.5374;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-52,-139.5;Inherit;True;Property;_Main_Texture;Main_Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-273.1957,1410.568;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;269.5862,1048.017;Float;False;Property;_MaskPow;Mask Pow;5;0;Create;True;0;0;0;False;0;False;4;3.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-92.3098,838.5311;Inherit;True;Property;_MaskTexture;Mask Texture;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;101.1118,1666.851;Inherit;False;Property;_Dissolve;Dissolve;12;0;Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;45;92.68163,1773.073;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;40;6.691711,1454.406;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;336,-41.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;230.9386,1408.882;Inherit;True;Property;_DissolveTex;Dissolve Tex;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;714,92.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;44;382.6855,1764.643;Inherit;False;Property;_UseCustom;Use Custom;13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;403.2467,902.0168;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;945.0874,515.5707;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;576.5829,1371.789;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;1198,498.5;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;1;0.79;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;950.8904,1051.436;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;1345,259.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;18;1168,111.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;893,-124.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;723,-334.5;Float;False;Property;_Tint_Color;Tint_Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;1343,-301.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;1385,39.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1627,-190;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Alphablend_Panner;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;2
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;9;0;8;0
WireConnection;3;0;2;0
WireConnection;3;2;4;0
WireConnection;33;0;30;0
WireConnection;33;1;31;0
WireConnection;39;0;36;0
WireConnection;39;1;37;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;32;0;23;0
WireConnection;32;2;33;0
WireConnection;1;1;3;0
WireConnection;29;1;32;0
WireConnection;40;0;34;0
WireConnection;40;2;39;0
WireConnection;13;0;1;1
WireConnection;13;1;10;0
WireConnection;35;1;40;0
WireConnection;12;0;13;0
WireConnection;12;1;10;0
WireConnection;44;1;41;0
WireConnection;44;0;45;3
WireConnection;27;0;29;1
WireConnection;27;1;26;0
WireConnection;28;0;12;0
WireConnection;28;1;27;0
WireConnection;42;0;35;1
WireConnection;42;1;44;0
WireConnection;43;0;28;0
WireConnection;43;1;42;0
WireConnection;14;0;43;0
WireConnection;14;1;17;0
WireConnection;18;0;14;0
WireConnection;21;0;16;0
WireConnection;21;1;19;0
WireConnection;20;0;19;4
WireConnection;20;1;18;0
WireConnection;0;2;21;0
WireConnection;0;9;20;0
ASEEND*/
//CHKSM=D86D19925DEB843BF1F92700396F4536B27A010C