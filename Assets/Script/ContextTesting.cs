using UnityEngine;
using System.Collections;

public class ContextTesting : MonoBehaviour {
    /// Add a context menu named "Do Something" in the inspector
    /// of the attached script.
    [ContextMenu("Do Something")]
    void DoSomething()
    {
        Debug.Log("Perform operation");
    }
    // Use this for initialization
    void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
