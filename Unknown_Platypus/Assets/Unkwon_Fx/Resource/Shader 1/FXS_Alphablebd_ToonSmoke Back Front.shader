// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alphablend_ToonSmoke Front"
{
	Properties
	{
		_FXT_smoke01_seq("FXT_smoke01_seq", 2D) = "white" {}
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,1)
		_MainUpanner("Main Upanner", Float) = 0
		_MainVpanner("Main Vpanner", Float) = 0
		_Smoke_Pow("Smoke_Pow", Range( 1 , 10)) = 1
		_Opacity("Opacity", Float) = 1
		_Dissolve_Texture("Dissolve_Texture", 2D) = "white" {}
		_DissolveUpanner("Dissolve Upanner", Float) = 0
		_DissolveVpanner("Dissolve Vpanner", Float) = 0
		_Dissolve("Dissolve", Range( -1 , 1)) = -0.5294118
		_Rot_Time("Rot_Time", Float) = 0
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_MaskTex("Mask Tex", 2D) = "white" {}
		_MaskPow("Mask Pow", Range( 1 , 10)) = 0
		[Toggle(_USEMASK_ON)] _UseMask("Use Mask", Float) = 0
		_SmokeIns("Smoke Ins", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma shader_feature_local _USEMASK_ON
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
		uniform sampler2D _FXT_smoke01_seq;
		uniform float _MainUpanner;
		uniform float _MainVpanner;
		uniform float4 _FXT_smoke01_seq_ST;
		uniform float _Smoke_Pow;
		uniform float _SmokeIns;
		uniform sampler2D _Dissolve_Texture;
		uniform float _DissolveUpanner;
		uniform float _DissolveVpanner;
		uniform float4 _Dissolve_Texture_ST;
		uniform float _Rot_Time;
		uniform float _Dissolve;
		uniform float _MaskPow;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult29 = (float2(_MainUpanner , _MainVpanner));
			float4 uvs_FXT_smoke01_seq = i.uv_texcoord;
			uvs_FXT_smoke01_seq.xy = i.uv_texcoord.xy * _FXT_smoke01_seq_ST.xy + _FXT_smoke01_seq_ST.zw;
			float2 panner26 = ( 1.0 * _Time.y * appendResult29 + uvs_FXT_smoke01_seq.xy);
			float4 tex2DNode1 = tex2D( _FXT_smoke01_seq, panner26 );
			float4 temp_cast_0 = (_Smoke_Pow).xxxx;
			o.Emission = ( i.vertexColor * ( _Tint_Color * ( pow( tex2DNode1 , temp_cast_0 ) * _SmokeIns ) ) ).rgb;
			float2 appendResult46 = (float2(_DissolveUpanner , _DissolveVpanner));
			float4 uvs_Dissolve_Texture = i.uv_texcoord;
			uvs_Dissolve_Texture.xy = i.uv_texcoord.xy * _Dissolve_Texture_ST.xy + _Dissolve_Texture_ST.zw;
			float2 temp_cast_2 = (0.5).xx;
			#ifdef _USE_CUSTOM_ON
				float staticSwitch25 = i.uv_texcoord.w;
			#else
				float staticSwitch25 = _Rot_Time;
			#endif
			float cos12 = cos( staticSwitch25 );
			float sin12 = sin( staticSwitch25 );
			float2 rotator12 = mul( uvs_Dissolve_Texture.xy - temp_cast_2 , float2x2( cos12 , -sin12 , sin12 , cos12 )) + temp_cast_2;
			float2 panner43 = ( 1.0 * _Time.y * appendResult46 + rotator12);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch24 = i.uv_texcoord.z;
			#else
				float staticSwitch24 = _Dissolve;
			#endif
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			#ifdef _USEMASK_ON
				float staticSwitch40 = pow( tex2D( _MaskTex, uvs_MaskTex.xy ).r , _MaskPow );
			#else
				float staticSwitch40 = ( ( ( 1.0 - i.uv_texcoord.xy.y ) * i.uv_texcoord.xy.y ) * _MaskPow );
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( ( ( tex2DNode1.r * step( 0.2 , ( tex2D( _Dissolve_Texture, panner43 ).r + staticSwitch24 ) ) ) * staticSwitch40 ) * _Opacity ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;30;-1474.046,38.39281;Inherit;False;1475;683;Dissolve;15;7;14;13;25;4;12;2;24;3;6;5;43;44;45;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-904.0455,519.3926;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1633.254,322.8349;Float;False;Property;_Rot_Time;Rot_Time;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1590.1,592.1632;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;8;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1586.753,501.8;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;7;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;25;-1428.254,329.8349;Float;False;Property;_Use_Custom;Use_Custom;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1447.052,222.828;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1462.39,75.48891;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;41;-1432.708,813.4745;Inherit;False;1319.467;658.2729;Mask;9;32;33;34;35;40;36;37;38;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-1558.175,-629.7531;Inherit;False;1663.666;552.8872;Main;12;28;27;23;29;26;1;17;18;16;19;47;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;12;-1183.486,91.87356;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-1374.232,570.4091;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;43;-1007.759,218.9964;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1480.453,-276.4482;Inherit;False;Property;_MainUpanner;Main Upanner;2;0;Create;True;0;0;0;False;0;False;0;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-975.0455,398.3928;Float;False;Property;_Dissolve;Dissolve;9;0;Create;True;0;0;0;False;0;False;-0.5294118;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1382.708,1172.747;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-1494.919,-191.8658;Inherit;False;Property;_MainVpanner;Main Vpanner;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1508.175,-475.7889;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;37;-1056.312,1181.081;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;24;-627.0455,466.3928;Float;False;Property;_Use_Custom;Use_Custom;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-766.0455,132.3928;Inherit;True;Property;_Dissolve_Texture;Dissolve_Texture;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1263.143,-267.4944;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1356.37,863.4745;Inherit;False;0;33;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-954.9211,1069.967;Inherit;False;Property;_MaskPow;Mask Pow;13;0;Create;True;0;0;0;False;0;False;0;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-874.3635,1201.915;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-485.0453,88.39278;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-1136.779,-448.2859;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-500.0453,193.3928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-1048.678,864.8585;Inherit;True;Property;_MaskTex;Mask Tex;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-636.8585,1203.304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;5;-234.0453,137.3928;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-757.8787,-490.5818;Inherit;True;Property;_FXT_smoke01_seq;FXT_smoke01_seq;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;34;-731.3057,883.8522;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;139,-130.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;40;-338.2415,1049.133;Inherit;False;Property;_UseMask;Use Mask;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-734.7747,-254.8995;Float;False;Property;_Smoke_Pow;Smoke_Pow;4;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-219.8676,-214.0385;Inherit;False;Property;_SmokeIns;Smoke Ins;15;0;Create;True;0;0;0;False;0;False;0;16.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;325.5268,426.0453;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;158,121.5;Float;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-291.5095,-331.7531;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;606.3076,107.3942;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-129.5094,-657.7531;Float;False;Property;_Tint_Color;Tint_Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;4.942838,5.452002,8.956253,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-134.8676,-354.0385;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;8;198.4851,-715.3568;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;22;820.3074,94.39421;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;17.49048,-409.7531;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;414,-571.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;942.3074,-61.60578;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1158.307,-230.1058;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Alphablend_ToonSmoke Front;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Front;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;1;15;0
WireConnection;25;0;7;4
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;12;2;25;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;43;0;12;0
WireConnection;43;2;46;0
WireConnection;37;0;36;2
WireConnection;24;1;4;0
WireConnection;24;0;7;3
WireConnection;2;1;43;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;38;0;37;0
WireConnection;38;1;36;2
WireConnection;26;0;23;0
WireConnection;26;2;29;0
WireConnection;3;0;2;1
WireConnection;3;1;24;0
WireConnection;33;1;32;0
WireConnection;39;0;38;0
WireConnection;39;1;35;0
WireConnection;5;0;6;0
WireConnection;5;1;3;0
WireConnection;1;1;26;0
WireConnection;34;0;33;1
WireConnection;34;1;35;0
WireConnection;10;0;1;1
WireConnection;10;1;5;0
WireConnection;40;1;39;0
WireConnection;40;0;34;0
WireConnection;42;0;10;0
WireConnection;42;1;40;0
WireConnection;18;0;1;0
WireConnection;18;1;19;0
WireConnection;20;0;42;0
WireConnection;20;1;21;0
WireConnection;47;0;18;0
WireConnection;47;1;48;0
WireConnection;22;0;20;0
WireConnection;16;0;17;0
WireConnection;16;1;47;0
WireConnection;9;0;8;0
WireConnection;9;1;16;0
WireConnection;11;0;8;4
WireConnection;11;1;22;0
WireConnection;0;2;9;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=69B0F14281EB07BC808CCF6BB878C9F6CBC9753C