Shader "Unlit/Matcap"
{
    Properties
    {
        _Matcap ("Matcap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            }; 

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 world_normal : TEXCOORD1;
                float3 view_normal : TEXCOORD2;
            };

            sampler2D _Matcap;
            float4 _Matcap_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Matcap);
                o.world_normal = UnityObjectToWorldNormal(v.normal);
                o.view_normal = mul(UNITY_MATRIX_V, float4(o.world_normal, 0.0)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.view_normal);
                normal *= 0.5f;
                normal += 0.5f;
                fixed4 col = tex2D(_Matcap, normal.xy);
                return col;
            }
            ENDCG
        }
    }
}
