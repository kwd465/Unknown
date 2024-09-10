// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN/Alpha Tornado"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Firepanning("Fire panning", Vector) = (-0.6,-0.6,0,0)
		[HDR]_FireColor("Fire Color", Color) = (0.07670188,1,0,1)
		_FireMidColor("Fire Mid Color", Color) = (1,0.390008,0,1)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HDR]_IceColor("Ice Color", Color) = (0,0.6152477,1,1)
		_IceLevelOffset("Ice Level Offset", 2D) = "white" {}
		_FrozenLevel("Frozen Level", Range( 0 , 1)) = 0
		_Helght("Helght", Range( 0 , 40)) = 24
		[HDR]_FreezeborderColor("Freezeborder Color", Color) = (1,1,1,1)
		_Displacement("Displacement", Vector) = (-0.15,-0.3,0,0)
		_Displacementlntensity("Displacementlntensity", 2D) = "white" {}
		_MainDisplacement("Main Displacement", 2D) = "white" {}
		_DisplcementMuti("Displcement Muti", Range( 0 , 10)) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainDisplacement;
		uniform float2 _Displacement;
		uniform float _FrozenLevel;
		uniform sampler2D _IceLevelOffset;
		uniform float4 _IceLevelOffset_ST;
		uniform float _Helght;
		uniform float4 _MainDisplacement_ST;
		uniform sampler2D _Displacementlntensity;
		uniform float _DisplcementMuti;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _IceColor;
		uniform sampler2D _TextureSample0;
		uniform float2 _Firepanning;
		uniform float4 _TextureSample0_ST;
		uniform float4 _FireColor;
		uniform float4 _FireMidColor;
		uniform float4 _FreezeborderColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_IceLevelOffset = v.texcoord * _IceLevelOffset_ST.xy + _IceLevelOffset_ST.zw;
			float lerpResult28 = lerp( -0.31 , 0.5 , _FrozenLevel);
			float temp_output_30_0 = (0.0 + (( _FrozenLevel + tex2Dlod( _IceLevelOffset, float4( uv_IceLevelOffset, 0, 0.0) ).r ) - 0.0) * (lerpResult28 - 0.0) / (1.0 - 0.0));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_32_0 = ( ase_worldPos.y / _Helght );
			float temp_output_34_0 = step( temp_output_30_0 , temp_output_32_0 );
			half Freeze41 = temp_output_34_0;
			float2 uv_MainDisplacement = v.texcoord.xy * _MainDisplacement_ST.xy + _MainDisplacement_ST.zw;
			float2 panner66 = ( 1.0 * _Time.y * ( _Displacement * Freeze41 ) + uv_MainDisplacement);
			float4 tex2DNode71 = tex2Dlod( _MainDisplacement, float4( panner66, 0, 0.0) );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 Displacement77 = ( tex2DNode71.r * tex2DNode71.r * tex2Dlod( _Displacementlntensity, float4( panner66, 0, 0.0) ).r * ase_vertexNormal * _DisplcementMuti );
			v.vertex.xyz += Displacement77;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float2 panner19 = ( 1.0 * _Time.y * float2( -0.012,-0.021 ) + uv_TextureSample1);
			float4 IceAlbado24 = ( tex2D( _TextureSample1, panner19 ) * _IceColor );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 panner2 = ( 1.0 * _Time.y * _Firepanning + uv_TextureSample0);
			float4 tex2DNode1 = tex2D( _TextureSample0, panner2 );
			float4 FireAlbedo16 = ( ( step( tex2DNode1.r , 0.25 ) * _FireColor ) + ( step( tex2DNode1.r , 0.325 ) * _FireMidColor ) );
			float2 uv_IceLevelOffset = i.uv_texcoord * _IceLevelOffset_ST.xy + _IceLevelOffset_ST.zw;
			float lerpResult28 = lerp( -0.31 , 0.5 , _FrozenLevel);
			float temp_output_30_0 = (0.0 + (( _FrozenLevel + tex2D( _IceLevelOffset, uv_IceLevelOffset ).r ) - 0.0) * (lerpResult28 - 0.0) / (1.0 - 0.0));
			float3 ase_worldPos = i.worldPos;
			float temp_output_32_0 = ( ase_worldPos.y / _Helght );
			float temp_output_34_0 = step( temp_output_30_0 , temp_output_32_0 );
			half Freeze41 = temp_output_34_0;
			float4 lerpResult92 = lerp( IceAlbado24 , FireAlbedo16 , Freeze41);
			float4 temp_output_93_0 = ( lerpResult92 * i.vertexColor );
			o.Albedo = temp_output_93_0.rgb;
			float4 FreezeBarder40 = ( ( step( temp_output_30_0 , ( temp_output_32_0 + 0.0 ) ) - temp_output_34_0 ) * _FreezeborderColor );
			o.Emission = ( temp_output_93_0 + FreezeBarder40 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;42;-4197.676,-321.1803;Inherit;False;2338.448;637.7771;Frozen Level;16;27;28;26;29;30;31;33;32;34;35;36;37;38;39;40;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;26;-4147.676,-82.09908;Inherit;True;Property;_IceLevelOffset;Ice Level Offset;7;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-4147.083,-198.2038;Float;False;Property;_FrozenLevel;Frozen Level;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-3721.383,54.99651;Inherit;False;3;0;FLOAT;-0.31;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3501.399,141.2162;Float;False;Property;_Helght;Helght;9;0;Create;True;0;0;0;False;0;False;24;25;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-3434.399,-18.78373;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-3750.585,-228.1034;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-3234.767,-17.78373;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;-3434.399,-214.7837;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;-3039.306,-237.989;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2612.355,-311.126;Half;True;Freeze;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;-4174.018,334.6813;Inherit;False;2193.983;842.8477;Opacity Mask;20;45;46;44;50;43;47;51;52;54;53;55;56;58;59;57;60;61;62;63;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1606.733,-325.6699;Inherit;False;1640.743;594;Fire Emissive;12;2;7;3;1;9;11;13;10;14;12;15;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1600.055,305.2913;Inherit;False;1343.692;493.8019;Ice Emissive;7;19;20;18;21;22;23;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;20;-1540.914,498.1125;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;-0.012,-0.021;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;47;-4124.018,711.9428;Inherit;True;41;Freeze;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1550.055,355.2913;Inherit;False;0;21;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1538.733,-275.6698;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;45;-4111.321,578.4399;Float;False;Property;_OpacityPanning;Opacity Panning;11;0;Create;True;0;0;0;False;0;False;0.8,0.8;0.8,0.8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-1556.733,-134.6699;Float;False;Property;_Firepanning;Fire panning;2;0;Create;True;0;0;0;False;0;False;-0.6,-0.6;-0.6,-0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;19;-1302.974,426.7021;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-4121.143,398.4215;Inherit;False;0;50;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-3903.018,613.9428;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-1304.733,-220.6699;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;44;-3813.939,424.2443;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;23;-1007.364,587.0932;Float;False;Property;_IceColor;Ice Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0.6152477,1,1;0,0.6152477,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1086.733,-221.6699;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1111.364,396.0932;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-3631.085,384.6813;Inherit;True;Property;_OpacityMask;Opacity Mask;12;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;10;-797.7335,-39.66989;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.325;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-870.7335,56.33013;Float;False;Property;_FireMidColor;Fire Mid Color;4;0;Create;True;0;0;0;False;0;False;1,0.390008,0,1;0.5636916,0.1475169,0.8018868,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;78;-1616.527,859.4314;Inherit;False;1530.402;723.6633;Comment;11;65;66;68;69;70;71;73;74;75;76;77;Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;12;-667.1335,-162.6698;Float;False;Property;_FireColor;Fire Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0.07670188,1,0,1;0.3215615,0,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;54;-3588.921,713.7469;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;9;-695.7335,-261.6699;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-714.3636,403.0932;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-3593.521,913.5289;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;88;-4155.066,1195.748;Inherit;False;1301.441;481.5066;Opacity;7;83;80;82;85;87;81;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3664.921,613.7469;Float;False;Property;_OpacityMuti;Opacity Muti;13;0;Create;True;0;0;0;False;0;False;1;0.58;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-3027.468,6.110963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1566.527,1300.731;Inherit;False;41;Freeze;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-3316.921,586.7469;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;58;-3367.142,944.3738;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-480.3637,393.0932;Float;True;IceAlbado;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;68;-1506.727,1129.131;Float;False;Property;_Displacement;Displacement;14;0;Create;True;0;0;0;False;0;False;-0.15,-0.3;-0.15,-0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-4105.067,1312.295;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-601.7335,31.33015;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-506.733,-269.6698;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-3051.921,660.7469;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;36;-2819.198,-2.199923;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1524.927,952.3307;Inherit;False;0;71;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-422.8327,-113.2699;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;81;-3872.207,1364.458;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1.08;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-3169.521,923.5289;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3839.625,1245.748;Inherit;False;24;IceAlbado;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1311.728,1194.131;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;66;-1214.227,1018.631;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-189.9907,-80.77287;Float;False;FireAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;39;-2585.337,104.5967;Float;False;Property;_FreezeborderColor;Freezeborder Color;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-3644.625,1320.748;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-2595.438,-113.2779;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;60;-2934.521,934.5289;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;-2929.921,659.7469;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-3600.07,1561.254;Inherit;False;41;Freeze;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3321.106,362.3372;Float;False;Property;_Dissolve;Dissolve;15;0;Create;True;0;0;0;False;0;False;0;0.1721031;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;75;-951.1249,1313.095;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-2720.521,696.5289;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;85;-3364.625,1354.748;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;-1021.827,1123.931;Inherit;True;Property;_Displacementlntensity;Displacementlntensity;16;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;89;86.7951,9.444702;Inherit;False;24;IceAlbado;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;88.96495,81.04979;Inherit;False;16;FireAlbedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-996.1249,1467.095;Float;False;Property;_DisplcementMuti;Displcement Muti;18;0;Create;True;0;0;0;False;0;False;10;0.83;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2987.921,392.747;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2348.288,-113.4333;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;91.20068,171.7122;Inherit;False;41;Freeze;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-1025.727,909.4314;Inherit;True;Property;_MainDisplacement;Main Displacement;17;0;Create;True;0;0;0;False;0;False;-1;ac89dd2201cbd6b4f81757524eaa35d4;ac89dd2201cbd6b4f81757524eaa35d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;92;276.4203,65.15414;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;94;274.4203,198.1541;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-540.1251,1018.095;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-3077.625,1372.748;Float;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-2083.229,-110.661;Float;True;FreezeBarder;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-2458.551,545.2051;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;258.4203,464.1541;Inherit;False;87;Opacity;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;460.4203,84.15414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2204.035,514.2298;Float;False;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;429.4203,236.1541;Inherit;False;40;FreezeBarder;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-310.125,1015.095;Float;False;Displacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;617.4203,148.1541;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;263.4203,630.1542;Inherit;False;77;Displacement;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;263.4203,377.1541;Inherit;False;-1;;1;0;OBJECT;0;False;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;557.2777,393.7942;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;251.4203,548.1542;Inherit;False;63;OpacityMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;103;-4491.026,507.1088;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;873.8451,93.55668;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;KOGUN/Alpha Tornado;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;-0.1;True;True;0;True;TransparentCutout;;Transparent;ForwardOnly;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;2;29;0
WireConnection;27;0;29;0
WireConnection;27;1;26;1
WireConnection;32;0;31;2
WireConnection;32;1;33;0
WireConnection;30;0;27;0
WireConnection;30;4;28;0
WireConnection;34;0;30;0
WireConnection;34;1;32;0
WireConnection;41;0;34;0
WireConnection;19;0;18;0
WireConnection;19;2;20;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;2;0;3;0
WireConnection;2;2;7;0
WireConnection;44;0;43;0
WireConnection;44;2;46;0
WireConnection;1;1;2;0
WireConnection;21;1;19;0
WireConnection;50;1;44;0
WireConnection;10;0;1;1
WireConnection;9;0;1;1
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;35;0;32;0
WireConnection;52;0;50;1
WireConnection;52;1;53;0
WireConnection;52;2;54;0
WireConnection;58;0;57;2
WireConnection;24;0;22;0
WireConnection;14;0;10;0
WireConnection;14;1;13;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;55;0;52;0
WireConnection;36;0;30;0
WireConnection;36;1;35;0
WireConnection;15;0;11;0
WireConnection;15;1;14;0
WireConnection;81;0;80;2
WireConnection;59;0;57;2
WireConnection;59;1;58;0
WireConnection;69;0;68;0
WireConnection;69;1;70;0
WireConnection;66;0;65;0
WireConnection;66;2;69;0
WireConnection;16;0;15;0
WireConnection;82;0;83;0
WireConnection;82;1;81;0
WireConnection;37;0;36;0
WireConnection;37;1;34;0
WireConnection;60;0;59;0
WireConnection;56;0;55;0
WireConnection;61;0;56;0
WireConnection;61;2;60;0
WireConnection;85;0;82;0
WireConnection;85;1;81;0
WireConnection;85;2;86;0
WireConnection;73;1;66;0
WireConnection;51;0;102;0
WireConnection;51;1;50;1
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;71;1;66;0
WireConnection;92;0;89;0
WireConnection;92;1;90;0
WireConnection;92;2;91;0
WireConnection;74;0;71;1
WireConnection;74;1;71;1
WireConnection;74;2;73;1
WireConnection;74;3;75;0
WireConnection;74;4;76;0
WireConnection;87;0;85;0
WireConnection;40;0;38;0
WireConnection;62;0;61;0
WireConnection;62;1;51;0
WireConnection;93;0;92;0
WireConnection;93;1;94;0
WireConnection;63;0;62;0
WireConnection;77;0;74;0
WireConnection;95;0;93;0
WireConnection;95;1;96;0
WireConnection;101;0;94;4
WireConnection;101;1;98;0
WireConnection;0;0;93;0
WireConnection;0;2;95;0
WireConnection;0;11;100;0
ASEEND*/
//CHKSM=C24CD0E064AED61A01D4002EA938C2AE53BE5306