#!/usr/bin/env groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'sudo apt-get udapte -y'
            }
        }
        stage('Test') {
            steps {
                echo 'Hello World..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
