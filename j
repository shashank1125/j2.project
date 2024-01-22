Git-Nginx-Jenkins Pipeline

To create a Jenkins pipeline that integrates with Git and deploys your HTML project to an Nginx server on Windows 10, you can follow these steps:
1.	Write an html project ‘index.html’ and save it in any directory of your choice. Say the directory in your local system is ‘C:\Users\user\Desktop\Namrata_Das_PU\Fall_AY_2023-24\Subject_Handled\DevOps\pipeline’.

<!DOCTYPE html>
<html>
    <head>
        <title>Canvas Example</title>
    <style>
        canvas {
            border: 1px solid black;
            }
    </style>
</head>
<body>
    <header>
        <h1>Canvas Example</h1>
        <p>Draw on the canvas by clicking and dragging the mouse</p>
    </header>
    <article>
        <h2>Canvas</h2>
        <canvas id="myCanvas" width="400" height="400" 
        onmousedown="startDrawing(event)" onmousemove="drawLine(event)" 
        onmouseup="stopDrawing(event)"></canvas>
    </article>
<script>
    var canvas = document.getElementById("myCanvas");
    var ctx = canvas.getContext("2d");
    var isDrawing = false;
    function startDrawing(event) {
        isDrawing = true;
        var x = event.clientX - canvas.offsetLeft;
        var y = event.clientY - canvas.offsetTop;
        ctx.beginPath();
        ctx.moveTo(x, y);
    }
    function drawLine(event) {
        if (isDrawing) {
        var x = event.clientX - canvas.offsetLeft;
        var y = event.clientY - canvas.offsetTop;
        ctx.lineTo(x, y);
        ctx.stroke();
    }
    }
    function stopDrawing(event) {
        isDrawing = false;
    }
</script>
</body>


2.	Download and install nginx server in your system and make all necessary configurations.
3.	Create a folder ‘htmldocs’ in your nginx filesystem. This will serve as the root directory for your nginx html project . Say the path to the root is ‘C:\Users\user\Desktop\Namrata_Das_PU\Fall_AY_2023-24\DevOps\installers\nginx-1.24.0\htmldocs’
4.	Create a jenkinsfile named ‘Jenkinsfile’ in the same project directory. 

pipeline {
    agent any

    environment {
        GIT_REPO_URL = 'https://github.com/namratasgit/pipeline1.git'
        NGINX_PATH = 'C:\\Users\\user\\Desktop\\Namrata_Das_PU\\Fall_AY_2023-24\\DevOps\\installers\\nginx-1.24.0\\htmldocs'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Use the checkout step to clone the Git repository
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: GIT_REPO_URL]]])
                }
            }
        }

        stage('Deploy to Nginx') {
            steps {
                script {
                    // Using the Jenkins workspace variable to reference files
                    bat 'xcopy /y "C:\\Users\\user\\Desktop\\Namrata_Das_PU\\Fall_AY_2023-24\\Subject_Handled\\DevOps\\pipeline\\index.html" "%NGINX_PATH%"'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! You can add additional steps here.'
        }
        failure {
            echo 'Pipeline failed! You may want to take some actions.'
        }
    }
}

The Jenkinsfile consist of two stages-
a.	Checking out from scm
b.	Deploying the project in your nginx server

5.	Create a github repository and push the project to your scm.
6.	In your Jenkins server-
a.	 create a new pipeline
b.	Under Pipeline, select Pipeline Script from SCM.
c.	Choose the SCM of your choice, say Git.
d.	Provide the repository URL and credentials(optional, if public).
e.	Set Branches to build to ‘*/master’
f.	Select script path as Jenkinsfile.
g.	Save and apply
h.	Build.
