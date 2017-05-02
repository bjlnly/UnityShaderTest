// 白雪覆盖效果
Shader "BJLN/Snow Vert" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump"{}
		_Snow ("Snow Level", Range(0,1) ) = 0
		_SnowColor ("Snow Color", Color) = (1.0,1.0,1.0,1.0)
		_SnowDirection ("Snow Direction", Vector) = (0,1,0)
		_SnowDepth ("Snow Depth", Range(0, 0.3)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomDiffuse vertex:vert

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
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal; INTERNAL_DATA
		};


		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) > lerp(1, -1, _Snow))
			{
				o.Albedo = _SnowColor.rgb;
			}
			else
			{
				o.Albedo = c.rgb;
			}

			o.Alpha = c.a;
		}

		void vert(inout appdata_full v){
			float4 sn = mul(transpose(_Object2World), _SnowDirection);
			if(dot(v.normal, sn.xyz) >= lerp (1, -1, (_Snow * 2) / 3)){
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
			}
		}

		ENDCG
	}
	FallBack "Diffuse"
}
