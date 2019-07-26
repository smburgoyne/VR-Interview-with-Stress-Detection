# VR-Interview-with-Stress-Detection


This was a CIS 4914 Senior Project at the University of Florida in Spring of 2018.


Contributors were Skyler Burgoyne and Tana Konda. Advised by Dr. Eakta Jain
& PhD candidate Mr. Brendan John.


Why did we make this project? Well, behavioral Interviews for Software Engineering positions are flawed. Answers can be faked and don’t tell employers about how the candidate would perform in a work scenario. This results in the company not obtaining a genuine assessment of a candidate on work performance through Q&A. 


Our proposed solution was an immersive Virtual Reality scenario with a sensor system to detect stress levels via monitoring heart rate and perspiration. The idea was you could see what kind of decisions the candidate would make in an office scenario. It wasn’t something you can memorize or game. 


Instead of one correct solution, each series of decisions taken by a candidate informed the performance result. The stress detection element was added to assess the ability of the candidate to stay calm under pressure. 


In order to measure the stress of the candidate effectively, we established baseline and threshold readings using a calm gondola scene in Venice and then an intense tightrope walk across a canyon. We could then compare the performance in the office scene against these extremes. 


Here is what this Git Repo contains:


The scripts folder contains the main functionality for the VR game in Unity. This set of scripts was written in C# and implements the state machine for game decisions, as well as the functionality for any buttons or GUI elements. The GUI for the game was created in Unity using 360 images of an office space as background and text boxes placed around the scene to prompt user interaction. The 360 photos used for the background are placed in the folder “360 Photos”.


In the signal processing folder, you will find two MATLAB scripts. They use the game decisions (2018-04-10-01-38.txt) and the sensor data (opensignals_98D331B210CE_2018-04-10_13-34-56.h5) to create two types of graphs. First, by measuring the amplitude of the R intervals, we determine the heart rate. Second, we track the fluctuations in EDA (electrodermal activity) which gives us their activity/perspiration levels over time. 


In order to see video demos of the VR game and the Signal Processing as well as the 360 images and graphs please see this Google drive folder: https://drive.google.com/drive/folders/1XCIcLIdczFjCYekCutccTZxc_0_LhYzj?usp=sharing
