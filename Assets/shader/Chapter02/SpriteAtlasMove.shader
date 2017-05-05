Shader "BJLN/CookBook/SpriteAtlasMove" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_TexWidth("Sheet Width", float) = 0.0
		_CellAmount("Cell Amount", float) = 0.0
		_yCellAmount("Cell Amount", float) = 0.0
		_Speed("Speed", Range(0.01, 32)) = 12
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

		struct Input {
			float2 uv_MainTex;
		};

		fixed _TexWidth;
		fixed _CellAmount;
		fixed _yCellAmount;
		fixed _Speed;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float2 spriteUV = IN.uv_MainTex;
			float cellPixedlWidth = _TexWidth/_CellAmount;
			float cellUVPercentage = cellPixedlWidth/_TexWidth;

			float ycellPixedlWidth = _TexWidth/_yCellAmount;
			float ycellUVPercentage = ycellPixedlWidth/_TexWidth;

			float timeVal = fmod(_Time.y * _Speed, _CellAmount);
			timeVal = ceil( timeVal);

			float xValue = spriteUV.x;
			xValue += cellUVPercentage * timeVal * _CellAmount;
			xValue *= cellUVPercentage;


//			float ytimeVal = fmod(_Time.y * _Speed, _yCellAmount);
//			ytimeVal = ceil( ytimeVal);
			float num = _Time.y * _Speed/ (_CellAmount-1);
			num = ceil(num);
			num = fmod(_yCellAmount - num ,_yCellAmount);
			float yValue = spriteUV.y;
			yValue += ycellUVPercentage * _yCellAmount * num;
			yValue *= ycellUVPercentage;



			spriteUV = float2(xValue, yValue);
			fixed4 c = tex2D (_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
