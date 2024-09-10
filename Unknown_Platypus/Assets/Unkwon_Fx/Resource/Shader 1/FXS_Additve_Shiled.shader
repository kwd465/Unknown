// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Additve_Shiled"
{
	Properties
	{
		_MainTexture("MainTexture", 2D) = "white" {}
		[HDR]_Main_Color_A("Main_Color_A", Color) = (0,0,0,0)
		[HDR]_Main_Color_B("Main_Color_B", Color) = (0.9433962,0.7698469,0.7698469,1)
		_Main_UPanner("Main_UPanner", Float) = 0
		_Main_VPanner("Main_VPanner", Float) = 0
		_Dissolve_Val("Dissolve_Val", Range( 0 , 1)) = 0.3647059
		_Chromatic_Val("Chromatic_Val", Range( 0 , 0.1)) = 0
		_Normal_Texture("Normal_Texture", 2D) = "bump" {}
		_Noise_Val("Noise_Val", Range( 0 , 1)) = 0
		_Sub_Texture("Sub_Texture", 2D) = "white" {}
		[HDR]_Sub_Color("Sub_Color", Color) = (0,0,0,0)
		_Sub_VPanner("Sub_VPanner", Range( 0 , 1)) = 0.04705883
		_Normal_Edge_Texure("Normal_Edge_Texure", 2D) = "bump" {}
		_Edge_Noise_Val("Edge_Noise_Val", Range( 0 , 1)) = 0.5630788
		_Edge_Thnkiness("Edge_Thnkiness", Range( 0 , 1)) = 0.2205882
		[HDR]_Edge_Color("Edge_Color", Color) = (1,1,1,0)
		[Toggle(_USE_CUSTOM_ON)] _Use_Custom("Use_Custom", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USE_CUSTOM_ON
		#pragma surface surf Unlit keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Sub_Color;
		uniform sampler2D _Sub_Texture;
		uniform float _Sub_VPanner;
		uniform float4 _Sub_Texture_ST;
		uniform float4 _Main_Color_A;
		uniform float4 _Main_Color_B;
		uniform sampler2D _MainTexture;
		uniform float _Main_UPanner;
		uniform float _Main_VPanner;
		uniform sampler2D _Normal_Texture;
		uniform float4 _Normal_Texture_ST;
		uniform float _Noise_Val;
		uniform float4 _MainTexture_ST;
		uniform float _Chromatic_Val;
		uniform float4 _Edge_Color;
		uniform sampler2D _Normal_Edge_Texure;
		uniform float4 _Normal_Edge_Texure_ST;
		uniform float _Edge_Noise_Val;
		uniform float _Dissolve_Val;
		uniform float _Edge_Thnkiness;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult32 = (float2(0.0 , _Sub_VPanner));
			float4 uvs_Sub_Texture = i.uv_texcoord;
			uvs_Sub_Texture.xy = i.uv_texcoord.xy * _Sub_Texture_ST.xy + _Sub_Texture_ST.zw;
			float2 panner28 = ( 1.0 * _Time.y * appendResult32 + uvs_Sub_Texture.xy);
			float2 appendResult22 = (float2(_Main_UPanner , _Main_VPanner));
			float4 uvs_Normal_Texture = i.uv_texcoord;
			uvs_Normal_Texture.xy = i.uv_texcoord.xy * _Normal_Texture_ST.xy + _Normal_Texture_ST.zw;
			float4 uvs_MainTexture = i.uv_texcoord;
			uvs_MainTexture.xy = i.uv_texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float2 panner2 = ( 1.0 * _Time.y * appendResult22 + ( ( (UnpackNormal( tex2D( _Normal_Texture, uvs_Normal_Texture.xy ) )).xy * _Noise_Val ) + uvs_MainTexture.xy ));
			float2 temp_cast_0 = (_Chromatic_Val).xx;
			float4 appendResult15 = (float4(tex2D( _MainTexture, ( panner2 + _Chromatic_Val ) ).r , tex2D( _MainTexture, panner2 ).g , tex2D( _MainTexture, ( panner2 - temp_cast_0 ) ).b , 0.0));
			float4 lerpResult5 = lerp( _Main_Color_A , _Main_Color_B , appendResult15);
			float4 uvs_Normal_Edge_Texure = i.uv_texcoord;
			uvs_Normal_Edge_Texure.xy = i.uv_texcoord.xy * _Normal_Edge_Texure_ST.xy + _Normal_Edge_Texure_ST.zw;
			float2 panner60 = ( 1.0 * _Time.y * float2( 0,0.15 ) + uvs_Normal_Edge_Texure.xy);
			#ifdef _USE_CUSTOM_ON
				float staticSwitch64 = i.uv_texcoord.z;
			#else
				float staticSwitch64 = _Dissolve_Val;
			#endif
			float temp_output_45_0 = ( ( ( (UnpackNormal( tex2D( _Normal_Edge_Texure, panner60 ) )).xy * _Edge_Noise_Val ) + i.uv_texcoord.xy ).y + (-2.0 + (staticSwitch64 - 0.0) * (2.0 - -2.0) / (1.0 - 0.0)) );
			float temp_output_53_0 = step( 0.18 , temp_output_45_0 );
			o.Emission = ( ( ( saturate( ( _Sub_Color * pow( tex2D( _Sub_Texture, panner28 ).r , 5.0 ) ) ) + lerpResult5 ) + ( _Edge_Color * ( temp_output_53_0 - step( _Edge_Thnkiness , temp_output_45_0 ) ) ) ) * i.vertexColor ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2292.795,-750.7488;Inherit;False;0;16;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-2281.665,212.5989;Inherit;False;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;62;-2181.665,346.5989;Float;False;Constant;_Vector0;Vector 0;16;0;Create;True;0;0;0;False;0;False;0,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;16;-2086.795,-753.7487;Inherit;True;Property;_Normal_Texture;Normal_Texture;8;0;Create;True;0;0;0;False;0;False;-1;645b0a2fda25d114599a2fba6417fe81;645b0a2fda25d114599a2fba6417fe81;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;60;-1982.665,223.5989;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1890.795,-552.7487;Float;False;Property;_Noise_Val;Noise_Val;9;0;Create;True;0;0;0;False;0;False;0;0.191;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1795.747,199.4539;Inherit;True;Property;_Normal_Edge_Texure;Normal_Edge_Texure;13;0;Create;True;0;0;0;False;0;False;-1;4f96d4ef7222cda4fbc29abb96dc4423;4f96d4ef7222cda4fbc29abb96dc4423;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;17;-1801.795,-751.7487;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1016.99,-869.3884;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1553.795,-742.7487;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1475.73,-36.11444;Float;False;Property;_Main_VPanner;Main_VPanner;5;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1554.972,-390.4304;Inherit;True;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1480.73,-111.1144;Float;False;Property;_Main_UPanner;Main_UPanner;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1626.238,388.581;Float;False;Property;_Edge_Noise_Val;Edge_Noise_Val;14;0;Create;True;0;0;0;False;0;False;0.5630788;0.262;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;39;-1467.238,228.5809;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1127.99,-797.3884;Float;False;Property;_Sub_VPanner;Sub_VPanner;12;0;Create;True;0;0;0;False;0;False;0.04705883;0.04705883;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1257.238,239.5809;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1065.772,-1012.806;Inherit;False;0;25;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;32;-842.9899,-833.3884;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1311.73,-352.1144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1295.73,-187.1144;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;63;-1027.636,1114.116;Inherit;True;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1560.61,517.5098;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-1051.376,893.44;Float;True;Property;_Dissolve_Val;Dissolve_Val;6;0;Create;True;0;0;0;False;0;False;0.3647059;0.476;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-677.3763,799.4399;Float;False;Constant;_Float5;Float 5;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-671.3763,953.4399;Float;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-670.3763,1021.44;Float;False;Constant;_Float4;Float 4;13;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1057.675,491.3423;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;64;-788.6362,1115.116;Float;True;Property;_Use_Custom;Use_Custom;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-674.3763,881.4401;Float;False;Constant;_Float6;Float 6;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1231.972,-48.43034;Float;False;Property;_Chromatic_Val;Chromatic_Val;7;0;Create;True;0;0;0;False;0;False;0;0.0067;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-1173.972,-235.4304;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;28;-798.772,-979.8065;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1011.538,-220.4755;Float;True;Property;_MainTexture;MainTexture;1;0;Create;True;0;0;0;False;0;False;710f0ecf3a70db046b1d6dc37fef65ac;710f0ecf3a70db046b1d6dc37fef65ac;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;27;-483.8818,-723.8009;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-575.2869,-935.7405;Inherit;True;Property;_Sub_Texture;Sub_Texture;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;47;-462.3764,825.4401;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-928,86.5;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-975,-366.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;44;-818.3763,492.4401;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;26;-280.6889,-905.9001;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-809.3082,56.67501;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;710f0ecf3a70db046b1d6dc37fef65ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-791,-406.5;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;710f0ecf3a70db046b1d6dc37fef65ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;69;-215.5398,-1085.557;Float;False;Property;_Sub_Color;Sub_Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-484.3764,401.44;Float;False;Property;_Edge_Thnkiness;Edge_Thnkiness;15;0;Create;True;0;0;0;False;0;False;0.2205882;0.206;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-494.3763,514.4399;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-335.3764,731.4399;Float;False;Constant;_Float8;Float 8;13;0;Create;True;0;0;0;False;0;False;0.18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-780,-157.5;Inherit;True;Property;_Main_Texture;Main_Texture;1;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;710f0ecf3a70db046b1d6dc37fef65ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2.539795,-975.5574;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;52;-154.3763,410.44;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-303,-195.5;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;6;-305.8,-571.7;Float;False;Property;_Main_Color_A;Main_Color_A;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.1132075,0.07252531,0.01014595,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;53;-140.3763,639.44;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-296.8,-357.7;Float;False;Property;_Main_Color_B;Main_Color_B;3;1;[HDR];Create;True;0;0;0;False;0;False;0.9433962,0.7698469,0.7698469,1;0.5849056,0.5849056,0.5849056,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;58;231.6238,386.34;Float;False;Property;_Edge_Color;Edge_Color;16;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;3.90124,1.283303,0.2760311,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;219.1237,654.64;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;222.7506,-902.7556;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-6.8,-363.7;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;279.4345,-459.4556;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;557.1237,543.64;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;542.14,-176.1815;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;65;787.5494,31.47837;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;979.2465,126.2253;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1005.276,-24.82867;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1146.887,-87.41473;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;KOGUN/Additve_Shiled;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;1;20;0
WireConnection;60;0;61;0
WireConnection;60;2;62;0
WireConnection;37;1;60;0
WireConnection;17;0;16;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;39;0;37;0
WireConnection;38;0;39;0
WireConnection;38;1;40;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;21;0;18;0
WireConnection;21;1;3;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;36;0;38;0
WireConnection;36;1;35;0
WireConnection;64;1;46;0
WireConnection;64;0;63;3
WireConnection;2;0;21;0
WireConnection;2;2;22;0
WireConnection;28;0;29;0
WireConnection;28;2;32;0
WireConnection;25;1;28;0
WireConnection;47;0;64;0
WireConnection;47;1;50;0
WireConnection;47;2;51;0
WireConnection;47;3;48;0
WireConnection;47;4;49;0
WireConnection;13;0;2;0
WireConnection;13;1;14;0
WireConnection;12;0;2;0
WireConnection;12;1;14;0
WireConnection;44;0;36;0
WireConnection;26;0;25;1
WireConnection;26;1;27;0
WireConnection;10;0;9;0
WireConnection;10;1;13;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;45;0;44;1
WireConnection;45;1;47;0
WireConnection;1;0;9;0
WireConnection;1;1;2;0
WireConnection;68;0;69;0
WireConnection;68;1;26;0
WireConnection;52;0;54;0
WireConnection;52;1;45;0
WireConnection;15;0;11;1
WireConnection;15;1;1;2
WireConnection;15;2;10;3
WireConnection;53;0;55;0
WireConnection;53;1;45;0
WireConnection;56;0;53;0
WireConnection;56;1;52;0
WireConnection;34;0;68;0
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;5;2;15;0
WireConnection;33;0;34;0
WireConnection;33;1;5;0
WireConnection;57;0;58;0
WireConnection;57;1;56;0
WireConnection;59;0;33;0
WireConnection;59;1;57;0
WireConnection;67;0;65;4
WireConnection;67;1;53;0
WireConnection;66;0;59;0
WireConnection;66;1;65;0
WireConnection;0;2;66;0
ASEEND*/
//CHKSM=844B7B63CA7E8C55C7B031F57261045E7A314BBC