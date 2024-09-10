// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve_Shokewave01"
{
	Properties
	{
		_Mian_Texture("Mian_Texture", 2D) = "white" {}
		_Main_UPanner("Main_UPanner", Float) = 0
		_Main_VPanner("Main_VPanner", Float) = 0
		_Main_Pow("Main_Pow", Range( 1 , 10)) = 1
		_Opacity("Opacity", Float) = 2
		_Main_Ins("Main_Ins", Range( 1 , 10)) = 1
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		_FXT_Mask01("FXT_Mask01", 2D) = "white" {}
		_Mask_Pow("Mask_Pow", Float) = 3.606799
		[Toggle(_USE_MASKTEX_ON)] _Use_MaskTex("Use_MaskTex", Float) = 0
		_Noise_Tex("Noise_Tex", 2D) = "bump" {}
		_NoiseTex_UPanner("NoiseTex_UPanner", Float) = 0
		_NoiseTex_VPanner("NoiseTex_VPanner", Float) = 0
		_Noise_Val("Noise_Val", Float) = 0
		_Main_UCoord_Pow("Main_UCoord_Pow", Range( 0 , 20)) = 1
		[Toggle(_USE_UCOORD_POW_ON)] _Use_UCoord_Pow("Use_UCoord_Pow", Float) = 0
		_Dissolve_Texture("Dissolve_Texture", 2D) = "white" {}
		_Dissovle_Val("Dissovle_Val", Range( -1 , 1)) = 0
		_Dissolve_UPanner("Dissolve_UPanner", Float) = 0
		_Dissolve_VPanner("Dissolve_VPanner", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_DissolveStep("Dissolve Step", Float) = 0
		[Toggle(_USESTEP_ON)] _UseStep("Use Step", Float) = 0
		[Enum(Defult,2,AlWays,1)]_ZTest_Mode("ZTest_Mode", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_UCOORD_POW_ON
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma shader_feature_local _USESTEP_ON
		#pragma shader_feature_local _USE_MASKTEX_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _ZTest_Mode;
		uniform float _Dst_BlendMode;
		uniform float _Src_BlendMode;
		uniform float _Cull_Mode;
		uniform sampler2D _Mian_Texture;
		uniform float _Main_UPanner;
		uniform float _Main_VPanner;
		uniform sampler2D _Noise_Tex;
		uniform float _NoiseTex_UPanner;
		uniform float _NoiseTex_VPanner;
		uniform float4 _Noise_Tex_ST;
		uniform float _Noise_Val;
		uniform float4 _Mian_Texture_ST;
		uniform float _Main_UCoord_Pow;
		uniform float _Main_Pow;
		uniform float _Main_Ins;
		uniform float4 _TintColor;
		uniform sampler2D _Dissolve_Texture;
		uniform float _Dissolve_UPanner;
		uniform float _Dissolve_VPanner;
		uniform float4 _Dissolve_Texture_ST;
		uniform float _Dissovle_Val;
		uniform float _DissolveStep;
		uniform float _Mask_Pow;
		uniform sampler2D _FXT_Mask01;
		uniform float4 _FXT_Mask01_ST;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult6 = (float2(_Main_UPanner , _Main_VPanner));
			float2 appendResult51 = (float2(_NoiseTex_UPanner , _NoiseTex_VPanner));
			float4 uvs_Noise_Tex = i.uv_texcoord;
			uvs_Noise_Tex.xy = i.uv_texcoord.xy * _Noise_Tex_ST.xy + _Noise_Tex_ST.zw;
			float2 panner48 = ( 1.0 * _Time.y * appendResult51 + uvs_Noise_Tex.xy);
			float4 uvs_Mian_Texture = i.uv_texcoord;
			uvs_Mian_Texture.xy = i.uv_texcoord.xy * _Mian_Texture_ST.xy + _Mian_Texture_ST.zw;
			#ifdef _USE_UCOORD_POW_ON
				float staticSwitch60 = pow( ( 1.0 - uvs_Mian_Texture.xy.y ) , _Main_UCoord_Pow );
			#else
				float staticSwitch60 = uvs_Mian_Texture.xy.y;
			#endif
			float2 appendResult55 = (float2(uvs_Mian_Texture.xy.x , staticSwitch60));
			float2 panner2 = ( 1.0 * _Time.y * appendResult6 + ( ( (UnpackNormal( tex2D( _Noise_Tex, panner48 ) )).xy * _Noise_Val ) + appendResult55 ));
			float4 tex2DNode1 = tex2D( _Mian_Texture, panner2 );
			float4 temp_cast_0 = (_Main_Pow).xxxx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch76 = i.uv_texcoord.w;
			#else
				float staticSwitch76 = _Main_Ins;
			#endif
			o.Emission = ( ( ( pow( tex2DNode1 , temp_cast_0 ) * staticSwitch76 ) * _TintColor ) * i.vertexColor ).rgb;
			float2 appendResult70 = (float2(_Dissolve_UPanner , _Dissolve_VPanner));
			float4 uvs_Dissolve_Texture = i.uv_texcoord;
			uvs_Dissolve_Texture.xy = i.uv_texcoord.xy * _Dissolve_Texture_ST.xy + _Dissolve_Texture_ST.zw;
			float2 panner67 = ( 1.0 * _Time.y * appendResult70 + uvs_Dissolve_Texture.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch75 = i.uv_texcoord.z;
			#else
				float staticSwitch75 = _Dissovle_Val;
			#endif
			float temp_output_65_0 = saturate( ( tex2D( _Dissolve_Texture, panner67 ).r + staticSwitch75 ) );
			#ifdef _USESTEP_ON
				float staticSwitch80 = step( _DissolveStep , temp_output_65_0 );
			#else
				float staticSwitch80 = temp_output_65_0;
			#endif
			float4 uvs_FXT_Mask01 = i.uv_texcoord;
			uvs_FXT_Mask01.xy = i.uv_texcoord.xy * _FXT_Mask01_ST.xy + _FXT_Mask01_ST.zw;
			#ifdef _USE_MASKTEX_ON
				float staticSwitch42 = pow( tex2D( _FXT_Mask01, uvs_FXT_Mask01.xy ).r , _Mask_Pow );
			#else
				float staticSwitch42 = pow( ( ( ( 1.0 - i.uv_texcoord.xy.y ) * i.uv_texcoord.xy.y ) * 4.0 ) , _Mask_Pow );
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( ( tex2DNode1.r * staticSwitch80 ) * staticSwitch42 ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;49;-2099.049,-865.0724;Float;False;Property;_NoiseTex_UPanner;NoiseTex_UPanner;11;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2103.049,-783.0724;Float;False;Property;_NoiseTex_VPanner;NoiseTex_VPanner;12;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-1877.049,-866.0724;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1726.284,-672.7115;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2122.049,-1155.073;Inherit;True;0;45;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-1868.981,-99.11432;Float;False;Property;_Main_UCoord_Pow;Main_UCoord_Pow;14;0;Create;True;0;0;0;False;0;False;1;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;48;-1811.049,-1011.072;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;71;-1210.101,19.87112;Inherit;False;1259.6;432;Dissolve;9;62;64;63;67;66;70;68;69;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;59;-1815.718,-338.7841;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-1615.049,-1121.073;Inherit;True;Property;_Noise_Tex;Noise_Tex;10;0;Create;True;0;0;0;False;0;False;-1;None;9d5139686547cd24983e1c90ad7e4c33;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;43;-1040.887,752.5952;Inherit;False;1446.815;691.7301;Mask;10;24;23;38;36;25;35;42;22;19;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;56;-1488.081,-304.5143;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1234.949,-888.7722;Float;False;Property;_Noise_Val;Noise_Val;13;0;Create;True;0;0;0;False;0;False;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-990.8874,1142.326;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;60;-1193.718,-333.7841;Float;False;Property;_Use_UCoord_Pow;Use_UCoord_Pow;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;46;-1327.049,-1120.073;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;22;-732.9252,1111.987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-704,-206.5;Float;False;Property;_Main_VPanner;Main_VPanner;2;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-703,-282.5;Float;False;Property;_Main_UPanner;Main_UPanner;1;0;Create;True;0;0;0;False;0;False;0;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1043.823,-1107.539;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1004.081,-641.5143;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-562.0199,1172.663;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-521,-279.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-664.8569,-711.3562;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-756.3174,797.9062;Inherit;False;0;35;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-357.02,1173.663;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-418,-555.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;35;-480.3582,802.5952;Inherit;True;Property;_FXT_Mask01;FXT_Mask01;7;0;Create;True;0;0;0;False;0;False;-1;c1cabec419b31ac458458a4156981f34;d5ce14cdc1ac343ffa476ad3e81f2ed4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;36;-158.3159,826.2111;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-236,-683.5;Inherit;True;Property;_Mian_Texture;Mian_Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;3a419aa5e10bd47a0b6c63760e83a4fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;25;-125.8437,1161.971;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;42;153.9273,1001.874;Float;False;Property;_Use_MaskTex;Use_MaskTex;9;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-119.1297,-283.1836;Float;False;Property;_Main_Ins;Main_Ins;5;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-217,-351.5;Float;False;Property;_Main_Pow;Main_Pow;3;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;406.7505,-96.62426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;7;63,-534.5;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;863.7,-39.7;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;2;1.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;630.3647,-98.55595;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;76;124.9796,-200.1071;Inherit;False;Property;_Use_Custom;Use_Custom;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;1021.791,-113.1785;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;380.6813,-476.2039;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;369.5813,-671.4039;Float;False;Property;_TintColor;Tint Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;1259.968,-103.3077;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;16;1022.281,-393.3038;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;674.8813,-650.5038;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1240.981,-469.1039;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1433.281,-222.6039;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1677.897,-447.5573;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve_Shokewave01;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;;0;True;_ZTest_Mode;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;True;_Src_BlendMode;10;True;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull_Mode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1160.101,270.8711;Float;False;Property;_Dissolve_VPanner;Dissolve_VPanner;19;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1146.101,209.8712;Float;False;Property;_Dissolve_UPanner;Dissolve_UPanner;18;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1138.101,69.87112;Inherit;False;0;62;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;70;-951.1008,232.8712;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;67;-890.1008,113.8711;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;74;-717.2598,478.5893;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;-795.4008,328.0713;Float;False;Property;_Dissovle_Val;Dissovle_Val;17;0;Create;True;0;0;0;False;0;False;0;0.11;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;75;-507.9609,388.8885;Float;False;Property;_Use_Custom;Use_Custom;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-687.1199,108.0424;Inherit;True;Property;_Dissolve_Texture;Dissolve_Texture;16;0;Create;True;0;0;0;False;0;False;-1;None;3a419aa5e10bd47a0b6c63760e83a4fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-364.1006,121.8711;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;65;-161.5007,114.3711;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-71.86938,410.9336;Inherit;False;Property;_DissolveStep;Dissolve Step;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;80;312.5066,303.9196;Inherit;False;Property;_UseStep;Use Step;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;1693.281,373.3508;Inherit;False;Property;_ZTest_Mode;ZTest_Mode;23;1;[Enum];Create;True;0;2;Defult;2;AlWays;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1693.001,189.6478;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;25;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;1686.415,74.72646;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;24;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1696.331,269.9993;Inherit;False;Property;_Cull_Mode;Cull_Mode;26;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;78;70.83051,191.6757;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-473.5864,1036.622;Float;False;Property;_Mask_Pow;Mask_Pow;8;0;Create;True;0;0;0;False;0;False;3.606799;1;0;0;0;1;FLOAT;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;48;0;47;0
WireConnection;48;2;51;0
WireConnection;59;0;3;2
WireConnection;45;1;48;0
WireConnection;56;0;59;0
WireConnection;56;1;58;0
WireConnection;60;1;3;2
WireConnection;60;0;56;0
WireConnection;46;0;45;0
WireConnection;22;0;19;2
WireConnection;52;0;46;0
WireConnection;52;1;53;0
WireConnection;55;0;3;1
WireConnection;55;1;60;0
WireConnection;23;0;22;0
WireConnection;23;1;19;2
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;54;0;52;0
WireConnection;54;1;55;0
WireConnection;24;0;23;0
WireConnection;2;0;54;0
WireConnection;2;2;6;0
WireConnection;35;1;61;0
WireConnection;36;0;35;1
WireConnection;36;1;38;0
WireConnection;1;1;2;0
WireConnection;25;0;24;0
WireConnection;25;1;38;0
WireConnection;42;1;25;0
WireConnection;42;0;36;0
WireConnection;73;0;1;1
WireConnection;73;1;80;0
WireConnection;7;0;1;0
WireConnection;7;1;8;0
WireConnection;44;0;73;0
WireConnection;44;1;42;0
WireConnection;76;1;13;0
WireConnection;76;0;74;4
WireConnection;9;0;44;0
WireConnection;9;1;10;0
WireConnection;12;0;7;0
WireConnection;12;1;76;0
WireConnection;11;0;9;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;17;0;14;0
WireConnection;17;1;16;0
WireConnection;18;0;16;4
WireConnection;18;1;11;0
WireConnection;0;2;17;0
WireConnection;0;9;18;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;67;0;66;0
WireConnection;67;2;70;0
WireConnection;75;1;64;0
WireConnection;75;0;74;3
WireConnection;62;1;67;0
WireConnection;63;0;62;1
WireConnection;63;1;75;0
WireConnection;65;0;63;0
WireConnection;80;1;65;0
WireConnection;80;0;78;0
WireConnection;78;0;79;0
WireConnection;78;1;65;0
ASEEND*/
//CHKSM=13211738FACE95F043A121B0ED055CEAC07DF5A1