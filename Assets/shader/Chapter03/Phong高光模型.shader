Shader "BJLN/CookBook/Phong高光模型" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		//_SpecColor("Specular Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecPower("Specular power", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Phong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _SpecPower;
		float4 _MainTint;
		float4 _SpecularColor;

		inline fixed4 LightingPhong(SurfaceOutput s,fixed3 lightDir, half3 viewDir, fixed atten)
		{
			// 法线方向和光线方向的点击
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

			float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			float3 finalSpec = _SpecularColor.rgb * spec;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;
		}

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
			o.Gloss = 1.0;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}