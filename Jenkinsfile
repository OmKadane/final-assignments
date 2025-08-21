pipeline {
    agent any

    environment {
        // IMPORTANT: Change 'your-dockerhub-username' to your actual Docker Hub username.
        DOCKER_IMAGE = "omkadane10/my-app:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Notify: Deployment Started') {
            steps {
                slackSend(
                    channel: '#all-github-deployments', // Your Slack channel
                    color: 'warning',
                    message: "🚀 Starting Docker deployment for `${env.JOB_NAME}`..."
                )
            }
        }
        
        stage('Build Docker Image 📦') {
            steps {
                script {
                    // This command builds the Docker image using the Dockerfile in your repo.
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Push to Docker Hub 📤') {
            steps {
                script {
                    // This logs in to Docker Hub using the 'dockerhub-creds' credential and pushes the image.
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Staging 🐳') {
            steps {
                // This wrapper loads your server's SSH key.
                sshagent(credentials: ['staging-server-key']) {
                    // This shell script runs commands on your remote staging server.
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@43.204.150.160 <<EOF
                        # Pull the new image from Docker Hub
                        docker pull ${DOCK//_IMAGE}
                        # Stop and remove the old container if it exists
                        docker stop my-app-container || true
                        docker rm my-app-container || true
                        # Run the new container, mapping port 80 on the server to port 8080 in the container
                        docker run -d --name my-app-container -p 80:8080 ${DOCKER_IMAGE}
                        EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            slackSend(channel: '#all-github-deployments', color: 'good', message: "✅ Docker deployment successful. Image: `${DOCKER_IMAGE}`")
            mail(to: 'omkadane5@gmail.com', subject: 'Docker Deployment Successful', body: "Image `${DOCKER_IMAGE}` deployed to staging.")
        }
        failure {
            slackSend(channel: '#all-github-deployments', color: 'danger', message: "❌ Docker deployment failed for `${env.JOB_NAME}`.")
        }
    }
}
