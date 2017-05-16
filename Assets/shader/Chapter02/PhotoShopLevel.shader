Shader "BJLN/CookBook/PhotoShopLevel" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_inBlack ("Input Back", Range(0, 255)) = 0
		_inGame("Input Game", Range(0, 2)) = 1.61
		_inWhite("Input White", Range(0, 255)) = 255

		_outWhite("Output White", Range(0, 255)) = 255
		_outBlack("Output Black", Range(0, 255)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _inBlack;
		float _inGame;
		float _inWhite;
		float _outWhite;
		float _outBlack;

		float GetPixelLevel(float pixelColor)
		{
			float pixelResult;
			pixelResult = (pixelColor * 255.0);
			pixelResult = max(0, pixelResult - _inBlack);

			pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGame));

			pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack) / 255.0;
			return pixelResult;
		}
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);

			float outRPixel = GetPixelLevel(c.r);
			float outGPixel = GetPixelLevel(c.g);
			float outBPixel = GetPixelLevel(c.b);

			o.Albedo = float3(outRPixel, outGPixel, outBPixel);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
