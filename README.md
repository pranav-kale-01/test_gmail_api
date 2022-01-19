# test_gmail_api

A Basic Gmail Application using Google's Gmail Api and OAuth 2.0

## Getting Started

First, Create a new project in google cloud console - https://console.cloud.google.com/. 

Once the project has been created, Head over to Api and services Tab - 

![Screenshot 2022-01-19 120813](https://user-images.githubusercontent.com/70502672/150079536-19b00607-6834-47a0-9989-1f1a8da33e66.png)

<br><br>

In Api and services, go to consent Screen, select the user type as external

![Screenshot 2022-01-19 122730](https://user-images.githubusercontent.com/70502672/150079930-3b0114f0-cc9a-4c90-97c2-65a2100cc765.png)

Now, Fill in the information that's require (Note: You can skip uploading the app logo, as it somtimes may take some days for google to verify it )

<br><br>

For the Scopes screen keep everything as it is and continue..

![image](https://user-images.githubusercontent.com/70502672/150080527-9ac53c17-aca1-4253-9e4b-a810bebae565.png)

<br><br>

Since, this project's status would be set to "testing" until the app is published and confirmed by Google, You have to add test users that may log into the application. If the user is not registered as a test user you may see a message as shown below.. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/70502672/150082872-8fe36475-b069-4aac-a62e-cb8ef9840514.png?raw=true" alt="Sublime's custom image"/>
</p>
  

<br><br>

Add as many test user you wish ( the limit for test-users is 100 ) - 

![image](https://user-images.githubusercontent.com/70502672/150081383-0f10233c-097d-4a14-9a58-0a7a04899476.png)

<br><br> 

Once the consent screen is been created, Head over to credentials tab in Api and Services, Click on create credentials and select "OAuth 2.0 Client ID"

![image](https://user-images.githubusercontent.com/70502672/150089753-83914bec-af63-4e0c-8ee8-27a49c57525d.png)

<br> <br> 

Select "Android" as Application type,

![image](https://user-images.githubusercontent.com/70502672/150089848-190a2718-59c7-4bdf-ac8e-71c88db2248c.png)

<br><br>

Now add your package name which is located in Android -> app -> src -> main -> AndroidManifest.xml

![image](https://user-images.githubusercontent.com/70502672/150090170-5d11c73a-89f6-4188-8cd0-601cfed5b824.png)

<br> <br> 

Refer [this thread](https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-react-native-android-native-app) from StackOverflow to get the SHA-1 fingerprint -


<br> <br> <br>

Once, the clientID is created it will be listed into the clientIDs List, just like this.

![image](https://user-images.githubusercontent.com/70502672/150091574-c01577ee-97d9-47d4-a59b-0c1e5305f618.png)

<br><br>

Now that the clientID has been succesfully generated, copy the ID and paste it into the code wherever required. ( For Android and iOS application, a client-secret is not required hence you can pass an empty string as client secret ) 

![image](https://user-images.githubusercontent.com/70502672/150091106-76050b55-4228-4e92-b73c-ea6cbf5d3f08.png)

<br><br>
Everything should be configured now, try running the application..
