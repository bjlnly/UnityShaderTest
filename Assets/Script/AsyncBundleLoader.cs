using System.Collections;
using System.IO;
using UnityEngine;

public class AsyncBundleLoader : MonoBehaviour
{
	// Used for visual debugging as to not generate unnecessary allocations
	public GameObject worldLight;

	// Private fields to keep track of loaded objects
	private AssetBundle m_Bundle;
	private Texture2D m_Asset;

	private const string kASSETBUNDLE_PATH = "Assets/Ztest/Textures/Texture0.png";
	private static string kASSETBUNDLE_FILE;

	private void Awake()
	{
		kASSETBUNDLE_FILE = Path.Combine(Application.streamingAssetsPath, "generated");
	}

	private IEnumerator Start()
	{
		while (true)
		{
			// TODO: Add an exit hook besides ALT+F4
			// Wait to trigger loading
			while (!Input.anyKeyDown)
				yield return null;
			yield return null;

			// Load Bundle
			var bundleRequest = AssetBundle.LoadFromFileAsync(kASSETBUNDLE_FILE);
			yield return bundleRequest;
			m_Bundle = bundleRequest.assetBundle;

			// Load Asset
			var assetRequest = m_Bundle.LoadAssetAsync<Texture2D>(kASSETBUNDLE_PATH);
			yield return assetRequest;
			m_Asset = assetRequest.asset as Texture2D;

			// Turn off the light, visual loading status indicator
			worldLight.SetActive(false);

			// Wait to trigger unloading
			while (!Input.anyKeyDown)
				yield return null;
			yield return null;

			// Unload Bundle and Asset
			m_Asset = null;
			m_Bundle.Unload(true);
			m_Bundle = null;

			// Turn on the light, visual loading status indicator
			worldLight.SetActive(true);
		}
	}
}
