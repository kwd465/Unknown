// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alphablend_ShokewaveFront"
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
		_Mask_Pow("Mask_Pow", Range( 1 , 10)) = 3.606799
		[Toggle(_USE_MASKTEX_ON)] _Use_MaskTex("Use_MaskTex", Float) = 0
		_Noise_Tex("Noise_Tex", 2D) = "bump" {}
		_NoiseTex_UPanner("NoiseTex_UPanner", Float) = 0
		_NoiseTex_VPanner("NoiseTex_VPanner", Float) = 0
		_Noise_Val("Noise_Val", Float) = 0
		_Main_UCoord_Pow("Main_UCoord_Pow", Range( 0 , 20)) = 1
		[Toggle(_USE_UCOORD_POW_ON)] _Use_UCoord_Pow("Use_UCoord_Pow", Float) = 0
		_Dissolve_Tex("Dissolve_Tex", 2D) = "white" {}
		_Dissolve_Val("Dissolve_Val", Range( -1 , 1)) = 1
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_Dissove_UPanner("Dissove_UPanner", Float) = 0
		_Dissove_VPanner("Dissove_VPanner", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_UCOORD_POW_ON
		#pragma shader_feature_local _USE_CUSTOM_ON
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
		uniform float _Mask_Pow;
		uniform sampler2D _FXT_Mask01;
		uniform float4 _FXT_Mask01_ST;
		uniform sampler2D _Dissolve_Tex;
		uniform float _Dissove_UPanner;
		uniform float _Dissove_VPanner;
		uniform float4 _Dissolve_Tex_ST;
		uniform float _Dissolve_Val;
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
			#ifdef _USE_CUSTOM_ON
				float staticSwitch74 = i.uv_texcoord.z;
			#else
				float staticSwitch74 = _Main_Ins;
			#endif
			o.Emission = ( ( ( pow( tex2DNode1.r , _Main_Pow ) * staticSwitch74 ) * _TintColor ) * i.vertexColor ).rgb;
			float4 uvs_FXT_Mask01 = i.uv_texcoord;
			uvs_FXT_Mask01.xy = i.uv_texcoord.xy * _FXT_Mask01_ST.xy + _FXT_Mask01_ST.zw;
			#ifdef _USE_MASKTEX_ON
				float staticSwitch42 = pow( tex2D( _FXT_Mask01, uvs_FXT_Mask01.xy ).r , _Mask_Pow );
			#else
				float staticSwitch42 = pow( ( ( ( 1.0 - i.uv_texcoord.xy.y ) * i.uv_texcoord.xy.y ) * 4.0 ) , _Mask_Pow );
			#endif
			float2 appendResult78 = (float2(_Dissove_UPanner , _Dissove_VPanner));
			float4 uvs_Dissolve_Tex = i.uv_texcoord;
			uvs_Dissolve_Tex.xy = i.uv_texcoord.xy * _Dissolve_Tex_ST.xy + _Dissolve_Tex_ST.zw;
			float2 panner75 = ( 1.0 * _Time.y * appendResult78 + uvs_Dissolve_Tex.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch73 = i.uv_texcoord.w;
			#else
				float staticSwitch73 = _Dissolve_Val;
			#endif
			float temp_output_18_0 = ( i.vertexColor.a * saturate( ( ( ( tex2DNode1.r * staticSwitch42 ) * ( pow( tex2D( _Dissolve_Tex, panner75 ).r , 2.0 ) + staticSwitch73 ) ) * _Opacity ) ) );
			o.Alpha = temp_output_18_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;49;-2099.049,-865.0724;Float;False;Property;_NoiseTex_UPanner;NoiseTex_UPanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2103.049,-783.0724;Float;False;Property;_NoiseTex_VPanner;NoiseTex_VPanner;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2122.049,-1155.073;Inherit;True;0;45;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;51;-1877.049,-866.0724;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1726.284,-672.7115;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-1865.081,-83.51431;Float;False;Property;_Main_UCoord_Pow;Main_UCoord_Pow;14;0;Create;True;0;0;0;False;0;False;1;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-1815.718,-338.7841;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;-1033.603,1008.037;Inherit;False;1446.815;691.7301;Mask;10;24;23;38;36;25;35;42;22;19;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;48;-1811.049,-1011.072;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;56;-1488.081,-304.5143;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-983.6033,1397.767;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;-1615.049,-1121.073;Inherit;True;Property;_Noise_Tex;Noise_Tex;10;0;Create;True;0;0;0;False;0;False;-1;None;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-739.7931,416.977;Float;False;Property;_Dissove_VPanner;Dissove_VPanner;19;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-725.6411,1367.429;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;60;-1193.718,-333.7841;Float;False;Property;_Use_UCoord_Pow;Use_UCoord_Pow;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;46;-1327.049,-1120.073;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-727.7931,338.977;Float;False;Property;_Dissove_UPanner;Dissove_UPanner;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1257.049,-903.0724;Float;False;Property;_Noise_Val;Noise_Val;13;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1004.081,-641.5143;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-656.42,160.7906;Inherit;False;0;65;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;78;-545.7931,341.977;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-554.7355,1428.105;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-727.2676,1048.457;Inherit;False;0;35;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-704,-206.5;Float;False;Property;_Main_VPanner;Main_VPanner;2;0;Create;True;0;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1043.823,-1107.539;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-703,-282.5;Float;False;Property;_Main_UPanner;Main_UPanner;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;75;-387.9088,307.5432;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;35;-473.0738,1058.037;Inherit;True;Property;_FXT_Mask01;FXT_Mask01;7;0;Create;True;0;0;0;False;0;False;-1;c1cabec419b31ac458458a4156981f34;8114901cd6272254f9794a61e1c327a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-466.3021,1292.064;Float;False;Property;_Mask_Pow;Mask_Pow;8;0;Create;True;0;0;0;False;0;False;3.606799;7.29;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-521,-279.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-349.7355,1429.105;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-664.8569,-711.3562;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;69;161.2577,408.1279;Float;False;Property;_Dissolve_Val;Dissolve_Val;17;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;72;-77.98609,418.9418;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-120.5841,145.0775;Inherit;True;Property;_Dissolve_Tex;Dissolve_Tex;16;0;Create;True;0;0;0;False;0;False;-1;710f0ecf3a70db046b1d6dc37fef65ac;710f0ecf3a70db046b1d6dc37fef65ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;1.25769,348.1279;Float;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-418,-555.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;36;-151.0316,1081.653;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-118.5595,1417.413;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;66;166.2577,168.1279;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;73;503.355,483.9393;Float;False;Property;_Use_Custom;Use_Custom;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;42;161.2116,1257.315;Float;False;Property;_Use_MaskTex;Use_MaskTex;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-292.2404,-685.2042;Inherit;True;Property;_Mian_Texture;Mian_Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-217,-351.5;Float;False;Property;_Main_Pow;Main_Pow;3;0;Create;True;0;0;0;False;0;False;1;2.41;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;434.2577,124.1279;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-127.9409,-233.7848;Float;False;Property;_Main_Ins;Main_Ins;5;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;228.9668,-102.8583;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;74;240.3086,-259.812;Float;False;Property;_Use_Custom;Use_Custom;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;7;63,-534.5;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;819.2577,-131.8721;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;946.4067,91.2868;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;2;3.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;443.3679,-459.5301;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;1101.47,-130.7784;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;369.5813,-671.4039;Float;False;Property;_TintColor;Tint Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;25.99207,25.99207,25.99207,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;1317.471,-129.7784;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;634.5813,-654.4039;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;16;704.5811,-380.4039;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;62;2152.622,46.88148;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;64;2476.773,73.89411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;918.5813,-470.4039;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;2787.958,-64.41022;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1354.052,-237.978;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1534.317,-516.8914;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Alphablend_ShokewaveFront;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Front;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;59;0;3;2
WireConnection;48;0;47;0
WireConnection;48;2;51;0
WireConnection;56;0;59;0
WireConnection;56;1;58;0
WireConnection;45;1;48;0
WireConnection;22;0;19;2
WireConnection;60;1;3;2
WireConnection;60;0;56;0
WireConnection;46;0;45;0
WireConnection;55;0;3;1
WireConnection;55;1;60;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;23;0;22;0
WireConnection;23;1;19;2
WireConnection;52;0;46;0
WireConnection;52;1;53;0
WireConnection;75;0;70;0
WireConnection;75;2;78;0
WireConnection;35;1;61;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;24;0;23;0
WireConnection;54;0;52;0
WireConnection;54;1;55;0
WireConnection;65;1;75;0
WireConnection;2;0;54;0
WireConnection;2;2;6;0
WireConnection;36;0;35;1
WireConnection;36;1;38;0
WireConnection;25;0;24;0
WireConnection;25;1;38;0
WireConnection;66;0;65;1
WireConnection;66;1;67;0
WireConnection;73;1;69;0
WireConnection;73;0;72;4
WireConnection;42;1;25;0
WireConnection;42;0;36;0
WireConnection;1;1;2;0
WireConnection;68;0;66;0
WireConnection;68;1;73;0
WireConnection;44;0;1;1
WireConnection;44;1;42;0
WireConnection;74;1;13;0
WireConnection;74;0;72;3
WireConnection;7;0;1;1
WireConnection;7;1;8;0
WireConnection;71;0;44;0
WireConnection;71;1;68;0
WireConnection;12;0;7;0
WireConnection;12;1;74;0
WireConnection;9;0;71;0
WireConnection;9;1;10;0
WireConnection;11;0;9;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;64;0;62;0
WireConnection;17;0;14;0
WireConnection;17;1;16;0
WireConnection;63;0;18;0
WireConnection;63;1;64;0
WireConnection;18;0;16;4
WireConnection;18;1;11;0
WireConnection;0;2;17;0
WireConnection;0;9;18;0
ASEEND*/
//CHKSM=508D66F29D45E7454ECFDFA172522F52EE2FA6C5