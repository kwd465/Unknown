// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Add Pow Wave"
{
	Properties
	{
		_Gra_NoiseTex("Gra_Noise Tex", 2D) = "white" {}
		_Gra_NoiseUpanner("Gra_Noise Upanner", Float) = 0
		_Gra_NoiseVpanner("Gra_Noise Vpanner", Float) = 0
		_Gra_NoiseVal("Gra_Noise Val", Float) = 0.1
		_Gra_MaskTex("Gra_Mask Tex", 2D) = "white" {}
		_MaskOffset("Mask Offset", Range( -1 , 1)) = 0
		_GraPow("Gra Pow", Float) = 1
		_GraIns("Gra Ins", Float) = 1
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_NoiseUpanner("Noise Upanner", Float) = 0
		_NoiseVpanner("Noise Vpanner", Float) = 0
		_NoiseIns("Noise Ins", Float) = 1
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		_Dissolve("Dissolve", Range( -1 , 1)) = 1
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		_MaskPow("Mask Pow", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 0
		[Enum(Defult,2,Always,6)]_ZTestMode("ZTest Mode", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform half _CullMode;
		uniform half _Dst_BlendMode;
		uniform half _Src_BlendMode;
		uniform half _ZTestMode;
		uniform sampler2D _Gra_MaskTex;
		uniform sampler2D _Gra_NoiseTex;
		uniform half _Gra_NoiseUpanner;
		uniform half _Gra_NoiseVpanner;
		uniform float4 _Gra_NoiseTex_ST;
		uniform half _Gra_NoiseVal;
		uniform float4 _Gra_MaskTex_ST;
		uniform half _MaskOffset;
		uniform half _GraPow;
		uniform sampler2D _NoiseTex;
		uniform half _NoiseUpanner;
		uniform half _NoiseVpanner;
		uniform half _NoiseIns;
		uniform half _GraIns;
		uniform sampler2D _DissolveTex;
		uniform half _DissolveUpanner;
		uniform half _DissolveVpanner;
		uniform float4 _DissolveTex_ST;
		uniform half _Dissolve;
		uniform half4 _Color;
		uniform half _MaskPow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult10 = (half2(_Gra_NoiseUpanner , _Gra_NoiseVpanner));
			float4 uvs_Gra_NoiseTex = i.uv_texcoord;
			uvs_Gra_NoiseTex.xy = i.uv_texcoord.xy * _Gra_NoiseTex_ST.xy + _Gra_NoiseTex_ST.zw;
			half2 panner11 = ( 1.0 * _Time.y * appendResult10 + uvs_Gra_NoiseTex.xy);
			float4 uvs_Gra_MaskTex = i.uv_texcoord;
			uvs_Gra_MaskTex.xy = i.uv_texcoord.xy * _Gra_MaskTex_ST.xy + _Gra_MaskTex_ST.zw;
			#ifdef _USECUSTOM_ON
				half staticSwitch20 = i.uv_texcoord.z;
			#else
				half staticSwitch20 = _MaskOffset;
			#endif
			half2 appendResult21 = (half2(uvs_Gra_MaskTex.xy.x , ( uvs_Gra_MaskTex.xy.y + staticSwitch20 )));
			half4 temp_cast_2 = (_GraPow).xxxx;
			half4 temp_output_24_0 = pow( tex2D( _Gra_MaskTex, ( ( (tex2D( _Gra_NoiseTex, panner11 )).rgba * _Gra_NoiseVal ) + half4( appendResult21, 0.0 , 0.0 ) ).rg ) , temp_cast_2 );
			half2 appendResult29 = (half2(_NoiseUpanner , _NoiseVpanner));
			half2 panner30 = ( 1.0 * _Time.y * appendResult29 + i.uv_texcoord.xy);
			#ifdef _USECUSTOM_ON
				half staticSwitch70 = i.uv_texcoord.w;
			#else
				half staticSwitch70 = _GraIns;
			#endif
			half2 appendResult47 = (half2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			half2 panner48 = ( 1.0 * _Time.y * appendResult47 + uvs_DissolveTex.xy);
			o.Emission = ( i.vertexColor * ( ( ( ( temp_output_24_0 * ( ( pow( tex2D( _NoiseTex, panner30 ).r , 1.0 ) * _NoiseIns ) + temp_output_24_0 ) ) * staticSwitch70 ) * saturate( ( tex2D( _DissolveTex, panner48 ).r + _Dissolve ) ) ) * _Color ) ).rgb;
			o.Alpha = ( i.vertexColor.a * saturate( pow( ( ( i.uv_texcoord.xy.y * ( 1.0 - i.uv_texcoord.xy.y ) ) * 4.0 ) , _MaskPow ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
132;143;1640;704;2889.389;-146.5263;1.894567;True;False
Node;AmplifyShaderEditor.RangedFloatNode;8;-4098.634,253.5509;Inherit;False;Property;_Gra_NoiseVpanner;Gra_Noise Vpanner;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-4095.406,166.4055;Inherit;False;Property;_Gra_NoiseUpanner;Gra_Noise Upanner;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-4093.793,-48.23009;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-3922.73,195.4539;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-3771.033,50.21175;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;67;-3339.522,-564.6638;Inherit;False;1501.034;438.8422;Noise;10;26;27;30;29;28;34;36;35;37;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3854.435,500.5773;Inherit;False;Property;_MaskOffset;Mask Offset;5;0;Create;True;0;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;19;-3794.724,610.3151;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-3281.356,-340.4991;Inherit;False;Property;_NoiseUpanner;Noise Upanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3563.753,354.6213;Inherit;False;0;23;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-3278.472,-263.3021;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;20;-3560.724,560.2873;Inherit;False;Property;_UseCustom;Use Custom;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-3583.832,0.1838551;Inherit;True;Property;_Gra_NoiseTex;Gra_Noise Tex;0;0;Create;True;0;0;0;False;0;False;-1;c7d564bbc661feb448e7dcb86e2aa438;4f599298d22bf8047b38f3bd26dad4c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-3236.865,219.661;Inherit;False;Property;_Gra_NoiseVal;Gra_Noise Val;3;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-3050.568,-361.8925;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-3270.754,8.252954;Inherit;True;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-3299.089,451.4499;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3289.522,-514.6639;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;-3018.286,370.7581;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3002.863,79.26009;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;30;-2857.489,-484.8217;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2573.803,895.6113;Inherit;False;1412.691;429.707;Dissolve;9;44;43;48;45;47;46;50;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;34;-2649.489,-503.8217;Inherit;True;Property;_NoiseTex;Noise Tex;9;0;Create;True;0;0;0;False;0;False;-1;c7d564bbc661feb448e7dcb86e2aa438;c7d564bbc661feb448e7dcb86e2aa438;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-2523.803,1125.318;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2491.489,-282.8219;Inherit;False;Constant;_NoisePow;Noise Pow;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2521.803,1210.318;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2691.402,351.9927;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;23;-2462.242,358.4479;Inherit;True;Property;_Gra_MaskTex;Gra_Mask Tex;4;0;Create;True;0;0;0;False;0;False;-1;None;70073c4e439cba742a66fdda32c43988;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-2246.489,-240.8219;Inherit;False;Property;_NoiseIns;Noise Ins;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-2571.602,1393.492;Inherit;False;1401.051;402.4659;Mask;7;55;56;57;58;59;60;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2362.224,594.1383;Inherit;False;Property;_GraPow;Gra Pow;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-2473.344,957.3447;Inherit;False;0;43;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;35;-2314.489,-481.8217;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-2286.803,1147.318;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2521.602,1450.591;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;48;-2128.803,1014.318;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;24;-2016.887,331.0863;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2073.489,-476.8217;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;56;-2276.781,1573.019;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1608.429,457.5081;Inherit;False;Property;_GraIns;Gra Ins;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1800.835,3.818233;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1921.983,1158.022;Inherit;False;Property;_Dissolve;Dissolve;16;0;Create;True;0;0;0;False;0;False;1;0.44;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-1947.953,945.6113;Inherit;True;Property;_DissolveTex;Dissolve Tex;13;0;Create;True;0;0;0;False;0;False;-1;c2f5e06ce5d539b418dc5ebfbfeeee94;c2f5e06ce5d539b418dc5ebfbfeeee94;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;73;-1632.947,551.8929;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1624.983,998.022;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2088.659,1443.492;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;70;-1366.724,456.1279;Inherit;False;Property;_UseCustom;Use Custom;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1539.742,122.5552;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1787.971,1680.958;Inherit;False;Property;_MaskPow;Mask Pow;18;0;Create;True;0;0;0;False;0;False;1;2.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1272.746,202.9801;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;52;-1359.112,992.267;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1858.902,1446.576;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-1045.555,389.9184;Inherit;False;Property;_Color;Color;8;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1147.073,638.0655;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;59;-1619.895,1446.576;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;-1368.551,1446.576;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-196.6962,1088.76;Inherit;False;267;474;Auto-Registar;4;3;4;2;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;65;-791.649,416.7541;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-832.4904,647.616;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-135.6962,1447.76;Inherit;False;Property;_ZTestMode;ZTest Mode;22;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-145.7009,1339.76;Inherit;False;Property;_CullMode;Cull Mode;21;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-576.5612,1027.82;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-1988.554,-6.354858;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;0;False;0;False;-0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-146.6962,1237.76;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;20;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-146.6962,1138.76;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;19;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-599.671,634.7606;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-147.6962,613.7597;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Add Pow Wave;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;11;0;6;0
WireConnection;11;2;10;0
WireConnection;20;1;18;0
WireConnection;20;0;19;3
WireConnection;12;1;11;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;13;0;12;0
WireConnection;17;0;16;2
WireConnection;17;1;20;0
WireConnection;21;0;16;1
WireConnection;21;1;17;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;30;0;26;0
WireConnection;30;2;29;0
WireConnection;34;1;30;0
WireConnection;22;0;14;0
WireConnection;22;1;21;0
WireConnection;23;1;22;0
WireConnection;35;0;34;1
WireConnection;35;1;36;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;48;0;44;0
WireConnection;48;2;47;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;37;0;35;0
WireConnection;37;1;38;0
WireConnection;56;0;55;2
WireConnection;39;0;37;0
WireConnection;39;1;24;0
WireConnection;43;1;48;0
WireConnection;51;0;43;1
WireConnection;51;1;50;0
WireConnection;57;0;55;2
WireConnection;57;1;56;0
WireConnection;70;1;42;0
WireConnection;70;0;73;4
WireConnection;40;0;24;0
WireConnection;40;1;39;0
WireConnection;41;0;40;0
WireConnection;41;1;70;0
WireConnection;52;0;51;0
WireConnection;58;0;57;0
WireConnection;54;0;41;0
WireConnection;54;1;52;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;61;0;59;0
WireConnection;62;0;54;0
WireConnection;62;1;63;0
WireConnection;66;0;65;4
WireConnection;66;1;61;0
WireConnection;64;0;65;0
WireConnection;64;1;62;0
WireConnection;0;2;64;0
WireConnection;0;9;66;0
ASEEND*/
//CHKSM=19CCC9EEACFCF6338BB48AC0FC999A3FA8BC2F20