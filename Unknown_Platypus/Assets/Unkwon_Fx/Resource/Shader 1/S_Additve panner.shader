// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additive Panner"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_Ins("Ins", Range( 1 , 50)) = 0
		_MainPow("Main Pow", Float) = 4
		_UPanner("UPanner", Float) = 0
		_VPanner("VPanner", Float) = 0
		_MaskTexture("Mask Texture", 2D) = "white" {}
		_MaskPow("Mask Pow", Float) = 0
		_Dissolvetex("Dissolve tex", 2D) = "white" {}
		_Dissolve("Dissolve", Range( -1 , 1)) = 0
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USECUSTOM_ON
		#pragma surface surf Unlit keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform float _Ins;
		uniform sampler2D _Dissolvetex;
		uniform float4 _Dissolvetex_ST;
		uniform float _Dissolve;
		uniform float4 _TintColor;
		uniform sampler2D _MainTexture;
		uniform float _UPanner;
		uniform float _VPanner;
		uniform float4 _MainTexture_ST;
		uniform float _MainPow;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform float _MaskPow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Dissolvetex = i.uv_texcoord * _Dissolvetex_ST.xy + _Dissolvetex_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch67 = i.uv2_texcoord2.z;
			#else
				float staticSwitch67 = _Dissolve;
			#endif
			half2 appendResult10 = (half2(_UPanner , _VPanner));
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			half2 panner4 = ( 1.0 * _Time.y * appendResult10 + uv_MainTexture);
			half4 temp_cast_0 = (_MainPow).xxxx;
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			o.Emission = ( i.vertexColor * ( ( _Ins * ( saturate( ( tex2D( _Dissolvetex, uv_Dissolvetex ).r + staticSwitch67 ) ) * ( _TintColor * pow( tex2D( _MainTexture, panner4 ) , temp_cast_0 ) ) ) ) * pow( tex2D( _MaskTexture, uv_MaskTexture ).r , _MaskPow ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;9;-1430.675,-194.318;Float;False;Property;_VPanner;VPanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1433.675,-296.318;Float;False;Property;_UPanner;UPanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-751.093,-1129.005;Inherit;False;1161.901;578.5891;Dissolve;7;64;63;62;66;67;65;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1322.314,-612.235;Inherit;True;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1236.675,-285.318;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-687.0175,-1079.005;Inherit;False;0;63;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;66;-629.5931,-757.4161;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;4;-1004.314,-472.2351;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-699.493,-843.2167;Float;False;Property;_Dissolve;Dissolve;11;0;Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-724.3142,-384.2351;Inherit;True;Property;_MainTexture;Main Texture;1;0;Create;True;0;0;0;False;0;False;-1;ed2cf0efcc6b5224e8fd3ac550dc00a5;2f94ef5f263af4cfeadb1c7408839e30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-469.7343,-185.0464;Float;False;Property;_MainPow;Main Pow;4;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-417.2956,-1063.004;Inherit;True;Property;_Dissolvetex;Dissolve tex;9;0;Create;True;0;0;0;False;0;False;-1;None;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;67;-420.2929,-744.4161;Float;False;Property;_UseCustom;Use Custom;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-39.39278,-987.5165;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-282.058,-553.662;Float;False;Property;_TintColor;Tint Color;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;52;-278.8583,-301.9298;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;212.8077,-974.5159;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;45.85917,-460.4083;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;54;235.7275,155.1739;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-50.21789,-103.2427;Inherit;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;328.8413,-598.7412;Float;False;Property;_Ins;Ins;3;0;Create;True;0;0;0;False;0;False;0;1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;292.6436,-465.7517;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;58;421.2255,398.7017;Float;False;Property;_WorldPosition;World Position;10;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;317.3884,116.9929;Float;False;Property;_MaskPow;Mask Pow;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;445.1495,148.3861;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;201.4567,-105.9101;Inherit;True;Property;_MaskTexture;Mask Texture;7;0;Create;True;0;0;0;False;0;False;-1;None;c1cabec419b31ac458458a4156981f34;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;61;642.6233,171.3031;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;43;524.3882,-75.00709;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;550.8413,-475.7412;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;42;-1691.912,448.8828;Inherit;False;1482.726;884.3866;mask;17;32;34;33;35;38;36;37;39;40;41;11;24;19;26;27;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;49;797.8413,-448.7412;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;768.0266,-246.8799;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;56;894.4249,158.2017;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1641.912,608.8827;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;40;-470.1866,993.3694;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-944.812,621.1827;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1035.786,1217.17;Float;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;35;-1158.687,984.4696;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1353.712,498.8828;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-632.7864,992.8697;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-834.1865,990.7695;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-628.8864,1215.069;Float;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-935.3342,838.7628;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1639.886,952.2695;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1168.712,632.1829;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;993.8413,-444.7412;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1360.887,988.2695;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1055.625,-17.29815;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-696.1341,632.1629;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1567.886,1218.27;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-1002.686,991.0695;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1109.312,860.1828;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1210,-289;Half;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Additive Panner;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;4;0;5;0
WireConnection;4;2;10;0
WireConnection;3;1;4;0
WireConnection;63;1;62;0
WireConnection;67;1;65;0
WireConnection;67;0;66;3
WireConnection;64;0;63;1
WireConnection;64;1;67;0
WireConnection;52;0;3;0
WireConnection;52;1;53;0
WireConnection;68;0;64;0
WireConnection;46;0;45;0
WireConnection;46;1;52;0
WireConnection;70;0;68;0
WireConnection;70;1;46;0
WireConnection;55;1;54;2
WireConnection;31;1;51;0
WireConnection;61;0;55;0
WireConnection;61;1;58;0
WireConnection;43;0;31;1
WireConnection;43;1;44;0
WireConnection;47;0;48;0
WireConnection;47;1;70;0
WireConnection;28;0;47;0
WireConnection;28;1;43;0
WireConnection;56;0;61;0
WireConnection;40;0;39;0
WireConnection;40;1;41;0
WireConnection;26;0;19;0
WireConnection;26;1;27;0
WireConnection;35;0;33;0
WireConnection;24;0;11;2
WireConnection;39;0;37;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;19;0;24;0
WireConnection;19;1;11;2
WireConnection;50;0;49;0
WireConnection;50;1;28;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;60;0;49;4
WireConnection;60;1;56;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;36;0;35;0
WireConnection;0;2;50;0
ASEEND*/
//CHKSM=7310D9AC6CA3F87585E370A61CE331B1ACD00C12