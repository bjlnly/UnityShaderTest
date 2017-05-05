 Shader "BJLN/CookBook/BRDF" {
	Properties {
		_Bump ("Bump", 2D) = "bump"{}
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_AmbnientColor("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue("This is a Slider", Range(0,10)) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BasicDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0
				sampler2D _Bump;

		//自定义光照模型
		inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir, half3 viewDir, fixed atten){
			float difLight = dot(s.Normal, lightDir);
			float rimLight = dot(s.Normal, viewDir);
			float hLambert = difLight * 0.5 +0.5;
			//float3 ramp = tex2D(_Bump, float2(hLambert, rimLight)).rgb;
			float3 ramp = tex2D (_Bump, float2(hLambert, rimLight)).rgb;
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * ramp;
			col.a = s.Alpha;
			return col;
		}

		float4 _EmissiveColor;
		float4 _AmbnientColor;	
		float _MySliderValue;	
		struct Input {
			float2 uv_MainTex;
		};
		

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			float4 c;
			c = pow((_EmissiveColor + _AmbnientColor), _MySliderValue);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
