pipeline {
    agent any
    environment {
        registryUrl = "ibmpoccontainer.azurecr.io"
        }
        stages {
            stage( 'Gitcheckout') {
                steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], gitTool: 'Default', userRemoteConfigs: [[credentialsId: 'venky', url: 'https://github.com/venkateshmuddusetty/java-hello-world-with-gradle.git']]])
                    
                }
            }
            stage( 'Build') {
                steps {
                    script {
                        // Define Variable
                        def USER_INPUT = input(
                            message: 'User input required - select build type?',
                            parameters: [
                                [$class: 'ChoiceParameterDefinition',
                                choices: ['maven','gradle'],
                                name: 'input',
                                description: 'Menu - select box option']
                                ]
                                )
                                echo "build type is: ${USER_INPUT}"
                                if( "${USER_INPUT}" == "maven")
                                sh 'mvn clean install'
                                else( "${USER_INPUT}" == "gradle")
                                sh 'gradle build'
                                }
                }
            }
            stage( 'Build docker image') {
                steps {
                    sh 'docker build -t helloworld:latest .'
                    
                }
                
            }
            stage('Upload Image to ACR') {
                steps{
                    sh 'docker login http://$registryUrl -u ibmpoccontainer -p U7/tPnyIHnva=iNhTVPC32kgHsCSo07P'
                    sh 'docker tag helloworld:latest ibmpoccontainer.azurecr.io/helloworld:latest'
                    sh 'docker push ibmpoccontainer.azurecr.io/helloworld:latest'
                    
                }
            }
            stage( 'Login to AKS repo') {
                steps {
                        sh 'rm -rf *'
                    
                        //sh "mkdir -p $WORKSPACE/test"
                        //sh "cd $WORKSPACE/test"
                        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], gitTool: 'Default', userRemoteConfigs: [[credentialsId: 'test-tken-v', url: 'https://github.com/venkateshmuddusetty/test.git']]])
                    
                    }
               }
            stage( 'Update to AKS repo') {
                steps {
                        sh '''
                            set -e
                            git clone https://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@github.com/venkateshmuddusetty/test.git
                            cat deployment.yml
                            sed -e "s|HELLO|ibmpoccontainer.azurecr.io/helloworld:latest|g" deployment.yml
                            rm -rf .gradle
                            git add .
                            git status
                            git commit -m "chnages the image name"t
                            git push -u origin '''
                       
                      // withCredentials([gitUsernamePassword(credentialsId: 'test-tken-v', gitToolName: 'Default')]) {
                            
                        //sh "git push -u origin"
                       // }
                    }
                }
            }
        }
    
