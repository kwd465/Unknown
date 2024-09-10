// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Toon Master Shader"
{
	Properties
	{
		_AlphaTex("Alpha Tex", 2D) = "white" {}
		_AlphaPow("Alpha Pow", Float) = 0
		_AlphaTileVpanner("Alpha Tile Vpanner", Float) = 1
		_AlphaTileUpanner("Alpha Tile Upanner", Float) = 1
		_AlphaScrollUpanner("Alpha Scroll Upanner", Float) = 0
		_AlphaScrollVpanner("Alpha Scroll Vpanner", Float) = 0
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_NoiseControl("Noise Control", Float) = 1
		_NoiseUpanner("Noise Upanner", Float) = 1
		_NoiseVpanner("Noise Vpanner", Float) = 1
		_NoiseScrollUpanner("Noise Scroll Upanner", Float) = 0
		_NoiseScrollVpanner("Noise  Scroll Vpanner", Float) = 0
		_ColorTex("Color Tex", 2D) = "white" {}
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_ColorUpanner("Color Upanner", Float) = 1
		_ColorVpanner("Color Vpanner", Float) = 1
		_ColorScrollUpanner("Color Scroll Upanner", Float) = 0
		_ColorScrollVpanner("Color Scroll Vpanner", Float) = 0
		_DissolveRangs("Dissolve Rangs", Float) = 0
		_DissolveControl("Dissolve Control", Range( 0 , 1)) = 1
		_DissolveShapness("Dissolve Shapness", Range( 0 , 1)) = 0
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
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _MainColor;
		uniform sampler2D _ColorTex;
		uniform float _ColorScrollUpanner;
		uniform float _ColorScrollVpanner;
		uniform float4 _ColorTex_ST;
		uniform float _ColorUpanner;
		uniform float _ColorVpanner;
		uniform sampler2D _NoiseTex;
		uniform float _NoiseScrollUpanner;
		uniform float _NoiseScrollVpanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseUpanner;
		uniform float _NoiseVpanner;
		uniform float _NoiseControl;
		uniform sampler2D _AlphaTex;
		uniform float _AlphaScrollUpanner;
		uniform float _AlphaScrollVpanner;
		uniform float4 _AlphaTex_ST;
		uniform float _AlphaTileUpanner;
		uniform float _AlphaTileVpanner;
		uniform float _AlphaPow;
		uniform float _DissolveRangs;
		uniform float _DissolveControl;
		uniform float _DissolveShapness;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult28 = (float2(_ColorScrollUpanner , _ColorScrollVpanner));
			float2 uv_ColorTex = i.uv_texcoord * _ColorTex_ST.xy + _ColorTex_ST.zw;
			float2 appendResult33 = (float2(_ColorUpanner , _ColorVpanner));
			float2 panner32 = ( 1.0 * _Time.y * appendResult28 + ( uv_ColorTex * appendResult33 ));
			float2 appendResult41 = (float2(_NoiseScrollUpanner , _NoiseScrollVpanner));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 appendResult44 = (float2(_NoiseUpanner , _NoiseVpanner));
			float2 panner43 = ( 1.0 * _Time.y * appendResult41 + ( uv_NoiseTex * appendResult44 ));
			float4 temp_output_51_0 = ( tex2D( _NoiseTex, panner43 ) * _NoiseControl );
			o.Emission = ( ( _MainColor * tex2D( _ColorTex, ( float4( panner32, 0.0 , 0.0 ) + temp_output_51_0 ).rg ) ) * i.vertexColor ).rgb;
			float2 appendResult11 = (float2(_AlphaScrollUpanner , _AlphaScrollVpanner));
			float2 uv_AlphaTex = i.uv_texcoord * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
			float2 appendResult5 = (float2(_AlphaTileUpanner , _AlphaTileVpanner));
			float2 panner8 = ( 1.0 * _Time.y * appendResult11 + ( uv_AlphaTex * appendResult5 ));
			float4 temp_cast_5 = (_AlphaPow).xxxx;
			float lerpResult60 = lerp( _DissolveRangs , 1.0 , _DissolveControl);
			float smoothstepResult64 = smoothstep( ( 1.0 - temp_output_51_0 ).r , 1.0 , lerpResult60);
			o.Alpha = ( ( saturate( pow( tex2D( _AlphaTex, ( temp_output_51_0 + float4( panner8, 0.0 , 0.0 ) ).rg ) , temp_cast_5 ) ) * saturate( ( smoothstepResult64 / _DissolveShapness ) ) ) * i.vertexColor.a ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;38;-3034.352,-304.988;Inherit;False;1319.488;886.967;Noise;2;40;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3005.671,-254.9879;Inherit;False;1238.543;537.7051;Tile;8;50;49;46;45;44;43;42;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-3002.533,291.7895;Inherit;False;488.0684;260.6375;Scroll;3;48;47;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2938.794,74.76402;Inherit;False;Property;_NoiseUpanner;Noise Upanner;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2938.793,167.7175;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2403.508,713.8278;Inherit;False;1346.767;886.9574;Alpha ;2;12;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2944.093,437.4268;Inherit;False;Property;_NoiseScrollVpanner;Noise  Scroll Vpanner;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2955.67,-204.988;Inherit;True;0;49;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;44;-2688.447,124.118;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2949.462,341.7895;Inherit;False;Property;_NoiseScrollUpanner;Noise Scroll Upanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2345.284,763.8278;Inherit;False;1238.543;537.7051;Tile;7;7;8;1;5;3;4;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2346.69,1315.151;Inherit;False;488.0684;260.6375;Scroll;3;11;9;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2262.08,-1304.425;Inherit;False;1317.225;889.2301;Color ;2;27;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2615.311,-202.175;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2278.406,1186.533;Inherit;False;Property;_AlphaTileVpanner;Alpha Tile Vpanner;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2675.462,365.6988;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2278.407,1095.115;Inherit;False;Property;_AlphaTileUpanner;Alpha Tile Upanner;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2295.284,813.8278;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;43;-2355.121,-143.1049;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2233.399,-1254.425;Inherit;False;1238.543;537.7051;Tile;7;37;36;35;34;33;32;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2296.691,1365.15;Inherit;False;Property;_AlphaScrollUpanner;Alpha Scroll Upanner;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-2028.062,1142.934;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2288.251,1460.788;Inherit;False;Property;_AlphaScrollVpanner;Alpha Scroll Vpanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-2230.261,-707.6475;Inherit;False;488.0684;260.6375;Scroll;3;30;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;49;-2087.125,-151.9349;Inherit;True;Property;_NoiseTex;Noise Tex;6;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;70;-2330.798,1692.817;Inherit;False;1625.67;595.9912;Dissolve;9;61;60;59;64;63;62;65;66;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1951.634,88.8583;Inherit;False;Property;_NoiseControl;Noise Control;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1954.927,816.6405;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-2019.623,1389.06;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2166.522,-831.7196;Inherit;False;Property;_ColorVpanner;Color Vpanner;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2166.523,-923.1378;Inherit;False;Property;_ColorUpanner;Color Upanner;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2180.261,-657.6475;Inherit;False;Property;_ColorScrollUpanner;Color Scroll Upanner;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1692.585,-162.0182;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;8;-1694.736,875.7108;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2183.399,-1204.425;Inherit;True;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-2135.747,1742.817;Inherit;False;Property;_DissolveRangs;Dissolve Rangs;18;0;Create;True;0;0;0;False;0;False;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2202.746,1911.817;Inherit;False;Property;_DissolveControl;Dissolve Control;19;0;Create;True;0;0;0;False;0;False;1;0.667;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2087.746,1821.817;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2171.821,-562.0102;Inherit;False;Property;_ColorScrollVpanner;Color Scroll Vpanner;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-1916.176,-875.3191;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;60;-1871.51,1782.223;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-1363.204,394.3654;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1843.04,-1201.612;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1903.191,-633.7382;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;59;-2280.798,2028.802;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1165.494,1105.718;Inherit;False;Property;_AlphaPow;Alpha Pow;1;0;Create;True;0;0;0;False;0;False;0;-0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1379.538,865.1316;Inherit;True;Property;_AlphaTex;Alpha Tex;0;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;64;-1555.746,1932.817;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1561.04,2173.808;Inherit;False;Property;_DissolveShapness;Dissolve Shapness;20;0;Create;True;0;0;0;False;0;False;0;0.745;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-1582.85,-1142.542;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;65;-1211.427,1946.97;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-1376.347,-846.8952;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;71;-1003.958,914.5112;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-1314.855,-1151.372;Inherit;True;Property;_ColorTex;Color Tex;12;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;ed2cf0efcc6b5224e8fd3ac550dc00a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1174.612,-1372.444;Inherit;False;Property;_MainColor;Main Color;13;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;67;-903.1278,1783.89;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;73;-1002.309,578.252;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;58;-1101.549,-293.2659;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-811.0496,612.7155;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-832.3484,-1104.388;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-624.8867,-763.9703;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-558.2639,182.988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-193.7992,-442.7471;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Toon Master Shader;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;5;False;;1;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;45;0
WireConnection;44;1;46;0
WireConnection;42;0;50;0
WireConnection;42;1;44;0
WireConnection;41;0;47;0
WireConnection;41;1;48;0
WireConnection;43;0;42;0
WireConnection;43;2;41;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;49;1;43;0
WireConnection;7;0;2;0
WireConnection;7;1;5;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;51;0;49;0
WireConnection;51;1;52;0
WireConnection;8;0;7;0
WireConnection;8;2;11;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;60;0;61;0
WireConnection;60;1;62;0
WireConnection;60;2;63;0
WireConnection;54;0;51;0
WireConnection;54;1;8;0
WireConnection;31;0;36;0
WireConnection;31;1;33;0
WireConnection;28;0;29;0
WireConnection;28;1;30;0
WireConnection;59;0;51;0
WireConnection;1;1;54;0
WireConnection;64;0;60;0
WireConnection;64;1;59;0
WireConnection;32;0;31;0
WireConnection;32;2;28;0
WireConnection;65;0;64;0
WireConnection;65;1;66;0
WireConnection;53;0;32;0
WireConnection;53;1;51;0
WireConnection;71;0;1;0
WireConnection;71;1;72;0
WireConnection;37;1;53;0
WireConnection;67;0;65;0
WireConnection;73;0;71;0
WireConnection;68;0;73;0
WireConnection;68;1;67;0
WireConnection;56;0;55;0
WireConnection;56;1;37;0
WireConnection;57;0;56;0
WireConnection;57;1;58;0
WireConnection;69;0;68;0
WireConnection;69;1;58;4
WireConnection;0;2;57;0
WireConnection;0;9;69;0
ASEEND*/
//CHKSM=8C76A82F0DBBB0B98B7EA12356262D72B1018BC0