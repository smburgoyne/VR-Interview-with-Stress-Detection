﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class CoworkerScript : MonoBehaviour
{

    public Image BackGroundImage;

    public Text CoffeeText;
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
        CoffeeText.color = HighlightTextColor;
    }

    public void OnGazeExit()
    {
        BackGroundImage.color = NormalColor;
        CoffeeText.color = NormalTextColor;
    }

    public void OnClick()
    {
        ChangeCount.FileData.Append("Coworker " + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\n");

        BackGroundImage.color = ClickColor;
        SceneManager.LoadScene("Coworker");
    }
}
