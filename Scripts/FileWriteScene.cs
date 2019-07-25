using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FileWriteScene : MonoBehaviour {
    
	void Start () {
        ChangeCount.FileData.Append(SceneManager.GetActiveScene().name + " " + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\n");
	}
}
