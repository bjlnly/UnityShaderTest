using UnityEngine;
using System.Collections;

public class SpriteAtlasMove : MonoBehaviour {
	float timeValue;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void FixedUpdate() {
		timeValue = Mathf.Ceil(Time.time % 16);
		transform.GetComponent<Renderer>().material.SetFloat("_TimeValue", timeValue);
	}
}
