using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LaptopScript : MonoBehaviour {

    public Image BackGroundImage;

    public Text LaptopText;
    public Color HighlightTextColor;
    public Color NormalTextColor;

    public Color NormalColor;
    public Color HighlightColor;
    public Color ClickColor;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void OnGazeEnter()
    {
        BackGroundImage.color = HighlightColor;
        LaptopText.color = HighlightTextColor;
    }

    public void OnGazeExit()
    {
        BackGroundImage.color = NormalColor;
        LaptopText.color = NormalTextColor;
    }

    public void OnClick()
    {
        ChangeCount.FileData.Append("Google " + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\n");

        BackGroundImage.color = ClickColor;
        SceneManager.LoadScene("Laptop");
    }
}
