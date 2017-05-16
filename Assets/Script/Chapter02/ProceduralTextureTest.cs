using UnityEngine;
using System.Collections;
using System.Text;

public class ProceduralTextureTest : MonoBehaviour {
    #region 公有变量
    public int widthHeight = 512;
    public Texture2D GeneratedTexture2D;
    #endregion

    #region 私有变量
    private Material currentMaterial;
    private Vector2 centerPosition;
    #endregion
    // Use this for initialization
    void Start () {
        if (!currentMaterial)
        {
            currentMaterial = transform.GetComponent<Renderer>().sharedMaterial;
            if (!currentMaterial)
            {
                StringBuilder debug = new StringBuilder();
                Debug.LogWarning(debug.Append("找不到一个合适的材质：  ").Append(transform.name));
            }
        }

        if (currentMaterial)
        {
            centerPosition = new Vector2(0.5f, 0.5f);
            GeneratedTexture2D = GenerateParabola();

            currentMaterial.SetTexture("_MainTex", GeneratedTexture2D);
        }
	}

    private Texture2D GenerateParabola()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int i = 0; i < widthHeight; i++)
        {
            for (int j = 0; j < widthHeight; j++)
            {
                Vector2 currentPosition = new Vector2(i,j);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));

                Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(i, j, pixelColor);
            }
        }
        proceduralTexture.Apply();
        return proceduralTexture;
    }

	// Update is called once per frame
	void Update () {
	
	}
}
