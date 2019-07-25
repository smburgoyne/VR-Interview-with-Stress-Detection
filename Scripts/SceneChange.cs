using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChange : MonoBehaviour {

    public float delay = 30;
    public string sceneName;
    void Start()
    {
        string currentScene = SceneManager.GetActiveScene().name;
        if (currentScene.Equals("Laptop"))
        {
            ChangeCount.Choices[ChangeCount.SceneChangeCount - 1] = 1;
            ChangeCount.GoogleCount++;
        }
        else if(currentScene.Equals("Coffee"))
        {
            ChangeCount.Choices[ChangeCount.SceneChangeCount - 1] = 2;
            ChangeCount.CoffeeCount++;
        }
        else if (currentScene.Equals("Coworker"))
        {
            ChangeCount.Choices[ChangeCount.SceneChangeCount - 1] = 3;
            ChangeCount.CoworkerCount++;
        }
        StartCoroutine(LoadLevelAfterDelay(delay));
    }

    IEnumerator LoadLevelAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);
        Debug.Log("Current value: " + ChangeCount.SceneChangeCount);
        int currentCount = ChangeCount.SceneChangeCount;
        if (currentCount == 1 && ChangeCount.Choices[0] == 3 && !ChangeCount.NewScene)
        {
            SceneManager.LoadScene("NewOffice");
        }
        else if (currentCount >= 5 || ChangeCount.CoworkerCount >= 1 || ChangeCount.GoogleCount >= 3)
        {
            SceneManager.LoadScene("Office3");
        }
        else if((!ChangeCount.WarningIssued && currentCount >= 3 && ChangeCount.Choices[currentCount - 1] == 2 && ChangeCount.Choices[currentCount - 2] == 2 && ChangeCount.Choices[currentCount - 3] == 2) || (!ChangeCount.WarningIssued && ChangeCount.CoffeeCount == 3 && currentCount == 4))
        {
            ChangeCount.WarningIssued = true;
            SceneManager.LoadScene("ManagerWarning");
        }
        else
        {
            SceneManager.LoadScene("Office2");
        }
       
    }
}
