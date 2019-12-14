#!/usr/bin/env groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'apt-get upgrade -y'
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
