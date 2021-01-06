pipeline {
    agent any
    stages {
        stage('Check out app code') {
            steps {
                echo "check-out code from git upon a PR"
            }
        }
        stage('lint tests') {
            steps {
                echo 'in ruby this might be something like ruby -n [ruby-file.rb]'
            }
        }
        stage('build') {
            steps {
                echo 'docker build command to build an image upon app code update'
            }
        }
        stage('merge branch to master') {
            steps {
                echo 'approve and merge PR to master branch if tests OK'
            }
        }
        stage('push to registry') {
            steps {
                echo 'docker push to a registry'
            }
        }
        stage('deploy to K8s / ECS') {
            steps {
                echo 'deploy a k8s cluster or ECS (staging env or canary deployment)'
            }
        }
    }
}
