using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeCount : MonoBehaviour {

    public static int SceneChangeCount = 0;
    public static int CoworkerCount = 0;
    public static int CoffeeCount = 0;
    public static int GoogleCount = 0;
    public static int[] Choices = new int[5];
    public static Boolean NewScene = false;
    public static Boolean WarningIssued = false;
    public static string FilePath;
    public static StringBuilder FileData;

	// Use this for initialization
	void Start () {
        FilePath = Application.persistentDataPath + DateTime.Now.ToString("/yyyy-MM-dd-hh:mm") + ".txt";
        if (CoworkerCount > 0 && SceneChangeCount == 1)
        {
            SceneChangeCount = 1;
            NewScene = true;
        }
        else
        {
            SceneChangeCount = 0;
            NewScene = false;
            FileData = new StringBuilder();
        }
        Debug.Log("Menu: " + SceneChangeCount);
        CoworkerCount = 0;
        CoffeeCount = 0;
        GoogleCount = 0;
        Choices = new int[5];
        WarningIssued = false;
    }
}
