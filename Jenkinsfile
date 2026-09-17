pipeline {

    agent any

    environment {

        AZURE_RESOURCE_GROUP = 'rg-azure-aci-cicd'

        AZURE_ACR = 'azureacicicd2026'

        ACR_LOGIN_SERVER = 'azureacicicd2026.azurecr.io'

        ACI_NAME = 'azure-aci-cicd'

        IMAGE_NAME = 'azure-aci-cicd-demo'

        IMAGE_TAG = "${BUILD_NUMBER}"

        ACI_PORT = '8080'
    }

    stages {

        stage('Checkout') {

            steps {

                checkout scm
            }
        }

        stage('Azure Login') {

            steps {

                withCredentials([

                    string(
                        credentialsId: 'azure-client-id',
                        variable: 'AZURE_CLIENT_ID'
                    ),

                    string(
                        credentialsId: 'azure-client-secret',
                        variable: 'AZURE_CLIENT_SECRET'
                    ),

                    string(
                        credentialsId: 'azure-tenant-id',
                        variable: 'AZURE_TENANT_ID'
                    ),

                    string(
                        credentialsId: 'azure-subscription-id',
                        variable: 'AZURE_SUBSCRIPTION_ID'
                    )

                ]) {

                    sh '''
                        az login \
                          --service-principal \
                          --username "$AZURE_CLIENT_ID" \
                          --password "$AZURE_CLIENT_SECRET" \
                          --tenant "$AZURE_TENANT_ID"

                        az account set \
                          --subscription "$AZURE_SUBSCRIPTION_ID"
                    '''
                }
            }
        }

        stage('Login to ACR') {

            steps {

                sh '''
                    az acr login \
                      --name ${AZURE_ACR}
                '''
            }
        }

        stage('Docker Build') {

            steps {

                sh '''
                    docker build \
                      -t ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} \
                      -t ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest \
                      ./app
                '''
            }
        }

        stage('Push to ACR') {

            steps {

                sh '''
                    docker push \
                      ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

                    docker push \
                      ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy to ACI') {

            steps {

                withCredentials([

                    usernamePassword(
                        credentialsId: 'azure-acr-credentials',
                        usernameVariable: 'ACR_USERNAME',
                        passwordVariable: 'ACR_PASSWORD'
                    )

                ]) {

                    sh '''
                        az container delete \
                          --resource-group ${AZURE_RESOURCE_GROUP} \
                          --name ${ACI_NAME} \
                          --yes || true

                        az container create \
                          --resource-group ${AZURE_RESOURCE_GROUP} \
                          --name ${ACI_NAME} \
                          --image ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} \
                          --registry-login-server ${ACR_LOGIN_SERVER} \
                          --registry-username "$ACR_USERNAME" \
                          --registry-password "$ACR_PASSWORD" \
                          --dns-name-label azure-aci-cicd \
                          --ports ${ACI_PORT} \
                          --os-type Linux \
                          --cpu 1 \
                          --memory 1.5 \
                          --restart-policy Always \
                          --environment-variables PORT=8080
                    '''
                }
            }
        }

        stage('Verify ACI') {

            steps {

                sh '''
                    echo "ACI State:"

                    az container show \
                      --resource-group ${AZURE_RESOURCE_GROUP} \
                      --name ${ACI_NAME} \
                      --query instanceView.state \
                      --output tsv

                    echo "Application URL:"

                    az container show \
                      --resource-group ${AZURE_RESOURCE_GROUP} \
                      --name ${ACI_NAME} \
                      --query ipAddress.fqdn \
                      --output tsv
                '''
            }
        }
    }

    post {

        success {

            echo '''
            Jenkins → ACR → Azure Container Instances deployment successful!
            '''
        }

        failure {

            echo '''
            Azure ACI deployment failed.
            '''
        }
    }
}
