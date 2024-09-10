// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Add_Shoke_Wave_Pow"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Offset("Offset", Range( -1 , 1)) = 0.1541504
		_Pow("Pow", Range( -10 , 10)) = 5.470588
		_MaskPow("Mask Pow", Float) = 6
		_Main_Ins("Main_Ins", Range( 0 , 10)) = 0
		[HDR]_Main_Color("Main_Color", Color) = (0,0,0,0)
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		_MainUpanner("Main Upanner", Float) = 0
		_MainVpanner("Main Vpanner", Float) = 0
		_Opactiy("Opactiy", Range( 1 , 10)) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 0
		[Enum(Defult,2,Always,6)]_ZTestMode("ZTest Mode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
		};

		uniform float _Src_BlendMode;
		uniform float _Dst_BlendMode;
		uniform float _ZTestMode;
		uniform float _CullMode;
		uniform float4 _Main_Color;
		uniform float _Main_Ins;
		uniform sampler2D _TextureSample0;
		uniform float _MainUpanner;
		uniform float _MainVpanner;
		uniform float4 _TextureSample0_ST;
		uniform float _Pow;
		uniform float _Offset;
		uniform float _MaskPow;
		uniform float _Opactiy;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult35 = (float2(_MainUpanner , _MainVpanner));
			float4 uvs_TextureSample0 = i.uv_texcoord;
			uvs_TextureSample0.xy = i.uv_texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 temp_cast_0 = (uvs_TextureSample0.xy.x).xx;
			float2 panner32 = ( 1.0 * _Time.y * appendResult35 + temp_cast_0);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch30 = i.uv_texcoord.w;
			#else
				float staticSwitch30 = _Pow;
			#endif
			#ifdef _USE_CUSTOM_ON
				float staticSwitch28 = i.uv_texcoord.z;
			#else
				float staticSwitch28 = _Offset;
			#endif
			float2 appendResult9 = (float2(( ( panner32 + float2( 0,0 ) ) * 1.0 ).x , ( ( pow( uvs_TextureSample0.xy.y , staticSwitch30 ) + staticSwitch28 ) * 1.0 )));
			float4 tex2DNode1 = tex2D( _TextureSample0, appendResult9 );
			o.Emission = ( i.vertexColor * ( _Main_Color * ( _Main_Ins * tex2DNode1 ) ) ).rgb;
			o.Alpha = ( ( i.vertexColor.a * tex2DNode1.r ) * ( saturate( pow( ( ( ( 1.0 - i.uv_texcoord.xy.y ) * i.uv_texcoord.xy.y ) * 4.0 ) , _MaskPow ) ) * _Opactiy ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;11;-1312.43,35.89911;Float;False;Property;_Pow;Pow;2;0;Create;True;0;0;0;False;0;False;5.470588;-2.5;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-1405.07,305.0743;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1417.548,-62.15287;Float;False;Property;_MainVpanner;Main Vpanner;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1421.787,-162.4426;Float;False;Property;_MainUpanner;Main Upanner;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1453.116,-443.0916;Inherit;True;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;30;-982.0701,142.0743;Float;False;Property;_Use_Custom;Use_Custom;6;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1153.4,289.5;Float;False;Property;_Offset;Offset;1;0;Create;True;0;0;0;False;0;False;0.1541504;0.36;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;22;-860.4556,410.1162;Inherit;False;1213;503;Comment;7;17;16;18;20;19;21;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-1183.069,-155.3799;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;28;-906.0701,328.0743;Float;False;Property;_Use_Custom;Use_Custom;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-1016.39,-300.8708;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;10;-984.6829,-114.8816;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-612,-177.5;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-628.1002,-81.89998;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-765,-370.5;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-374,-350.5;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-367,-101.5;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-116,-274.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-326.455,554.1165;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;65.98145,-655.4459;Float;False;Property;_Main_Ins;Main_Ins;4;0;Create;True;0;0;0;False;0;False;0;1.74;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-55.90002,-495.7001;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;c2f5e06ce5d539b418dc5ebfbfeeee94;05ea33e1e37a8c245aca3e86dec28fdf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;19;-102.4551,546.1165;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;99.80098,790.587;Inherit;False;Property;_Opactiy;Opactiy;9;0;Create;True;0;0;0;False;0;False;0;2.25;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;555.9814,-864.4459;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;329.9814,-611.4459;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;301.9814,-814.4459;Float;False;Property;_Main_Color;Main_Color;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;21;157.1938,543.3387;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;450.4336,217.1638;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;921.897,-18.28027;Inherit;False;268.3198;465.227;Auto-Register;4;38;39;40;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;392.9814,-372.4459;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;502.9814,-681.4459;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;698.1288,-113.5557;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;971.897,31.71972;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;10;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;976.2168,133.2354;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;11;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;987.0164,331.9467;Inherit;False;Property;_ZTestMode;ZTest Mode;13;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;802.9814,-656.4459;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;980.5366,234.751;Inherit;False;Property;_CullMode;Cull Mode;12;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;902,-492;Float;False;True;-1;0;ASEMaterialInspector;0;0;Unlit;KOGUN/Add_Shoke_Wave_Pow;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;2;True;_ZTestMode;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;True;_Src_BlendMode;10;True;_Dst_BlendMode;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_CullMode;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;43;-838.8057,864.2609;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-278.455,797.1169;Float;False;Property;_MaskPow;Mask Pow;3;0;Create;True;0;0;0;False;0;False;6;1.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-467.9974,869.0356;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1149.434,611.9026;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;17;-861.4531,482.3962;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-556.2295,553.1709;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;30;1;11;0
WireConnection;30;0;29;4
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;28;1;8;0
WireConnection;28;0;29;3
WireConnection;32;0;2;1
WireConnection;32;2;35;0
WireConnection;10;0;2;2
WireConnection;10;1;30;0
WireConnection;4;0;10;0
WireConnection;4;1;28;0
WireConnection;3;0;32;0
WireConnection;5;0;3;0
WireConnection;5;1;7;0
WireConnection;6;0;4;0
WireConnection;6;1;7;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;18;0;16;0
WireConnection;1;1;9;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;24;0;25;0
WireConnection;24;1;1;0
WireConnection;21;0;19;0
WireConnection;36;0;21;0
WireConnection;36;1;37;0
WireConnection;14;0;12;4
WireConnection;14;1;1;1
WireConnection;26;0;27;0
WireConnection;26;1;24;0
WireConnection;23;0;14;0
WireConnection;23;1;36;0
WireConnection;13;0;12;0
WireConnection;13;1;26;0
WireConnection;0;2;13;0
WireConnection;0;9;23;0
WireConnection;17;0;15;2
WireConnection;16;0;17;0
WireConnection;16;1;15;2
ASEEND*/
//CHKSM=1E6486D3C54B33A121ECFF023EF8524A336AF9F1