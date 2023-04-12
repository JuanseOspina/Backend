pipeline {
    agent any

    environment{
        DOCKERHUB_CREDENTIALS= credentials("DockerHubCredentials")
    }
    
    stages {

        stage('Run Test'){
            steps{
                script{
                    sh "docker build -t juospina/test:latest -f Dockerfile.test ."
                    sh "docker run -t juospina/test:latest"
                }
            }
        }

        stage('Download Image and retag') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh "docker pull juospina/backend:latest"
                    sh "docker tag juospina/backend:latest juospina/backend:recovery"
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push juospina/backend:recovery"
                    sh "docker image rm juospina/backend:latest"
                }
            }
        }

        stage('Build new and pull'){
            when {
                branch 'main'
            }
            steps{
                script{
                    sh "chmod +x start.sh"
                    sh "docker build -t juospina/backend:latest -f Dockerfile . "
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin "
                    sh "docker push juospina/backend:latest"
                }
            }
        }

        stage('Deployment'){
            when {
                branch 'main'
            }
            steps{
                sshagent(credentials: ['ubuntu_bastion']) {
                    sh '''
                    [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                    ssh-keyscan -t rsa,dsa 10.0.0.87 >> ~/.ssh/known_hosts
                    ssh ubuntu@10.0.0.87 'kubectl rollout restart deployment/backend-deployment'
                    '''
                }
            }
        }
    }
}