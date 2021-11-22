Shader "Random Entity/PointCloud"
{
    Properties
    {
        _DepthTexture ("Depth Texture", 2D) = "white" {}
        _ColorTexture ("Color Texture", 2D) = "white" {}

        _Pitch ("Pitch", Float) = 0.01
        _DepthScale ("Depth Scale", Float) = 0.1

        // _Displacement ("Displacement", Range(0, 1)) = 0.03
        // _Color("Particle color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
    		Cull Off
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv_depth : TEXCOORD0;
                float2 uv_color : TEXCOORD1;
            };

            struct v2f
            {
                // float2 uv_depth : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 col : COLOR;
            };

            sampler2D _DepthTexture;
            sampler2D _ColorTexture;
            float _Pitch;
            float _DepthScale;

            // float _Displacement;
            // fixed4 _Color;

            v2f vert (appdata v)
            {
				float4 rawDepth = tex2Dlod(_DepthTexture, float4(v.uv_depth, 0, 0));
                float depth = rawDepth.x * _DepthScale;

                float scale = depth / (365.5 * _Pitch);

                v.vertex.x *= scale;
                v.vertex.y *= scale;
                v.vertex.z = depth;;

                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.col = tex2Dlod(_ColorTexture, float4(v.uv_color, 0, 0));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv_depth);
                fixed4 col = i.col;
                
                return col;
            }
            ENDCG
        }
    }
}