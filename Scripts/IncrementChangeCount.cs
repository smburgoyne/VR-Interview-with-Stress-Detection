using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IncrementChangeCount : MonoBehaviour {

	// Use this for initialization
	void Start () {
        ChangeCount.SceneChangeCount++;
        Debug.Log("Incremented value: " + ChangeCount.SceneChangeCount);
	}
}
