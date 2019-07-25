using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DirectionsAppear : MonoBehaviour
{

    public float delay = 2;
    public Image BackGroundImage;

    public Text DirectionsText;
    public Color HighlightTextColor;
    public Color NormalTextColor;

    public Color NormalColor;
    public Color HighlightColor;

    void Start()
    {
        StartCoroutine(LoadDirectionsAfterDelay(delay));
    }

    IEnumerator LoadDirectionsAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);
        BackGroundImage.color = HighlightColor;
        DirectionsText.color = HighlightTextColor;
    }
}
