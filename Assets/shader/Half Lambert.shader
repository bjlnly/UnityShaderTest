// 创建自己的光照模型
Shader "BJLN/Half Lambert" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomDiffuse

		inline float4 LightingCustomDiffuse(SurfaceOutput s,fixed3 lightDir, fixed atten){
			float difLight = max(0, dot(s.Normal, lightDir));
			float hLambert = difLight * 0.5 + 0.5;
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
			col.a = s.Alpha;
			return col;
		}

		sampler2D _MainTex;
		sampler2D _Bump;
		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
