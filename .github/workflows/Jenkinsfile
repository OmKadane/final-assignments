pipeline {
    agent any

    stages {
        // Stage 1: Build the application
        stage('Build ⚙️') {
            steps {
                echo 'Building the application...'
                // These are standard Node.js commands. Replace them if your project uses a different build process.
                sh 'npm install'
                sh 'npm run build'
            }
        }

        // Stage 2: Wait for Manual Approval
        stage('Wait for Approval ✋') {
            steps {
                // This step sends an email to you, letting you know a deployment is ready for approval.
                mail(
                    to: 'omkadane5@gmail.com', // Changed to your email
                    subject: "Approval Required: Staging deployment for ${env.JOB_NAME}",
                    body: """
                    A new build is ready to be deployed to the staging environment.

                    Please log in to Jenkins to review and approve the deployment.
                    Job URL: ${env.BUILD_URL}
                    """
                )

                // This step pauses the pipeline for up to 1 hour, waiting for your input.
                timeout(time: 1, unit: 'HOURS') {
                    input(
                        message: 'Deploy to the staging environment?',
                        submitter: 'omkadane5' // Changed to your Jenkins User ID
                    )
                }
            }
        }

        // Stage 3: Deploy to Staging (runs only after you approve)
        stage('Deploy to Staging 🚀') {
            steps {
                sshagent(credentials: ['staging-server-key']) {
                    // This command copies your built files to the AWS server.
                    // NOTE: Make sure the '/var/www/staging-app' directory exists on your server!
                    sh 'scp -o StrictHostKeyChecking=no -r dist/* ubuntu@43.204.150.160:/var/www/staging-app'
                }
            }
        }
    }

    // This 'post' block runs after the main stages are finished.
    post {
        // This runs only if the entire pipeline succeeds.
        success {
            mail(
                to: 'omkadane5@gmail.com', // Changed to your email
                subject: "✅ Successful Staging Deployment: ${env.JOB_NAME}",
                body: "The deployment to the staging environment was successfully approved and completed."
            )
        }
        // This runs if any part of the pipeline fails or is aborted.
        failure {
            mail(
                to: 'omkadane5@gmail.com', // Changed to your email
                subject: "❌ FAILED Staging Deployment: ${env.JOB_NAME}",
                body: "The deployment to the staging environment failed. Please check the logs: ${env.BUILD_URL}"
            )
        }
    }
}
