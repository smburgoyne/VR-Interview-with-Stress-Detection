using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FileWriter : MonoBehaviour {

	public float delay = 30;
    
	void Start () {
        try
        {
            Debug.Log(ChangeCount.FilePath);

            string FileString = ChangeCount.FileData.ToString();
            FileStream fs = File.Create(ChangeCount.FilePath);
            Byte[] info = new UTF8Encoding(true).GetBytes(FileString);
            fs.Write(info, 0, info.Length);

			StartCoroutine(LoadLevelAfterDelay(delay));
        }

        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
    }

	IEnumerator LoadLevelAfterDelay(float delay)
	{
		yield return new WaitForSeconds(delay);
		SceneManager.LoadScene("MainMenu");
	}
}
