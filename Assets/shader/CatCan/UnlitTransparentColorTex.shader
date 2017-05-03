Shader "Unlit/TransparentColorTex"
{
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Brightness("Brightness", Range(-1, 1)) = 0
		_MainTex("Texture", 2D) = "white" {}
		_CutOff("CutOff", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		ZWrite on
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			float _Brightness;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _CutOff;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.uv);
				fixed4 col = _Color;
				if (tex.a < _CutOff)
					discard;
				col.rgb = (col.rgb + _Brightness) * tex.rgb;
				return col;
			}
			ENDCG
		}
	}
}
