// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KOGUN_UI/UI_Dissolve"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        _MainTexture("Main Texture", 2D) = "white" {}
        [HDR]_MainColor("Main Color", Color) = (1,1,1,1)
        _MainPow("Main Pow", Float) = 1
        _MainIns("Main Ins", Float) = 1
        _NoiseTexture("Noise Texture", 2D) = "white" {}
        _NoiseUpanner("Noise Upanner", Float) = 0
        _NoiseVpanner("Noise Vpanner", Float) = 0
        _NoiseStr("Noise Str", Float) = 0.1
        _DissolveTex("Dissolve Tex", 2D) = "white" {}
        _DissolveUpanner("Dissolve Upanner", Float) = 0
        _DissolveVpanner("Dissolve Vpanner", Float) = 0
        _Dissolve("Dissolve", Range( -1 , 1)) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]_Src_BlendMode("Src_Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]_Dst_BlendMode("Dst_Blend Mode", Float) = 10
        [Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Float) = 0
        [Enum(Defult,2,Always,6)]_ZTest_Mode("ZTest_Mode", Float) = 2

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull [_Cull_Mode]
        Lighting Off
        ZWrite Off
        ZTest [_ZTest_Mode]
        Blend [_Src_BlendMode] [_Dst_BlendMode]
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float _Src_BlendMode;
            uniform float _Dst_BlendMode;
            uniform float _ZTest_Mode;
            uniform float _Cull_Mode;
            uniform float4 _MainColor;
            uniform sampler2D _MainTexture;
            uniform sampler2D _DissolveTex;
            uniform float _DissolveUpanner;
            uniform float _DissolveVpanner;
            uniform sampler2D _NoiseTexture;
            uniform float _NoiseUpanner;
            uniform float _NoiseVpanner;
            uniform float _NoiseStr;
            uniform float4 _DissolveTex_ST;
            uniform float _Dissolve;
            uniform float _MainPow;
            uniform float _MainIns;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float2 texCoord21 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 appendResult16 = (float2(_DissolveUpanner , _DissolveVpanner));
                float2 appendResult4 = (float2(_NoiseUpanner , _NoiseVpanner));
                float2 texCoord1 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 panner5 = ( 1.0 * _Time.y * appendResult4 + texCoord1);
                float2 uv_DissolveTex = IN.texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
                float2 panner13 = ( 1.0 * _Time.y * appendResult16 + ( ( (tex2D( _NoiseTexture, panner5 )).rgba * _NoiseStr ) + float4( uv_DissolveTex, 0.0 , 0.0 ) ).rg);
                float4 temp_cast_2 = (_MainPow).xxxx;
                

                half4 color = ( IN.color * ( _MainColor * ( pow( ( tex2D( _MainTexture, texCoord21 ) * saturate( ( tex2D( _DissolveTex, panner13 ).r + _Dissolve ) ) ) , temp_cast_2 ) * _MainIns ) ) );

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1630.25,-179.1997;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1647.25,1.800276;Inherit;False;Property;_NoiseStr;Noise Str;7;0;Create;True;0;0;0;False;0;False;0.1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1443.25,-103.1997;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;5;-2232.878,-193.8922;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2583.876,-201.8922;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-2599.876,-61.89224;Inherit;False;Property;_NoiseUpanner;Noise Upanner;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2599.876,43.10776;Inherit;False;Property;_NoiseVpanner;Noise Vpanner;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2378.877,-36.89222;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1990.87,-211.1119;Inherit;True;Property;_NoiseTexture;Noise Texture;4;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1204.729,41.35627;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;13;-914.2484,188.1044;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1328.359,299.6727;Inherit;False;Property;_DissolveUpanner;Dissolve Upanner;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1320.318,409.2308;Inherit;False;Property;_DissolveVpanner;Dissolve Vpanner;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1084.114,332.8417;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-739.519,148.0592;Inherit;True;Property;_DissolveTex;Dissolve Tex;8;0;Create;True;0;0;0;False;0;False;-1;8d21b35fab1359d4aa689ddf302e1b01;8d21b35fab1359d4aa689ddf302e1b01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-407.3288,284.1226;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1476.289,151.8312;Inherit;False;0;19;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-994.0146,-297.7423;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-738.0999,-298.836;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;8dc0c836ca62d49d9add680457681437;8dc0c836ca62d49d9add680457681437;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-201.1183,8.480891;Inherit;False;Property;_MainPow;Main Pow;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;-62.22425,-163.2228;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;200.2527,-153.3798;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;53.70307,147.3749;Inherit;False;Property;_MainIns;Main Ins;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;66.82607,-391.7964;Inherit;False;Property;_MainColor;Main Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;428.8251,-131.5068;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;32;511.9416,-320.7088;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;694.5814,-108.5398;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;1057.675,141.9067;Inherit;False;Property;_Src_BlendMode;Src_Blend Mode;12;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;1063.143,251.2722;Inherit;False;Property;_Dst_BlendMode;Dst_Blend Mode;13;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;1066.424,436.0995;Inherit;False;Property;_ZTest_Mode;ZTest_Mode;15;1;[Enum];Create;True;0;2;Defult;2;Always;6;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;1065.331,323.4532;Inherit;False;Property;_Cull_Mode;Cull_Mode;14;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-196.3287,285.1226;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-623.6792,405.7782;Inherit;False;Property;_Dissolve;Dissolve;11;0;Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-370.6318,-262.7453;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;38;1081.623,-84.21136;Float;False;True;-1;2;ASEMaterialInspector;0;3;KOGUN_UI/UI_Dissolve;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;True;1;0;True;_Src_BlendMode;0;True;_Dst_BlendMode;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;True;True;2;True;_Cull_Mode;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;0;True;_ZTest_Mode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;0;9;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;5;0;1;0
WireConnection;5;2;4;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;9;1;5;0
WireConnection;10;0;7;0
WireConnection;10;1;12;0
WireConnection;13;0;10;0
WireConnection;13;2;16;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;19;1;13;0
WireConnection;17;0;19;1
WireConnection;17;1;18;0
WireConnection;22;1;21;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;28;0;30;0
WireConnection;28;1;26;0
WireConnection;31;0;32;0
WireConnection;31;1;28;0
WireConnection;20;0;17;0
WireConnection;23;0;22;0
WireConnection;23;1;20;0
WireConnection;38;0;31;0
ASEEND*/
//CHKSM=75B4042C0890EC945ECFCEF9FD4E324B236A7DF7