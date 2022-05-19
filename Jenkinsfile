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
                        sh "mkdir -p $WORKSPACE/test"
                        sh "cd $WORKSPACE/test"
                        git branch: 'main', credentialsId: 'test-tken-v', url: 'https://github.com/venkateshmuddusetty/test.git'
                    
                    }
               }
            stage( 'Update to AKS repo') {
                steps {
                       // sh "cd test"
                        sh 'cat deployment.yml'
                       sh' sed -e "s|HELLO|ibmpoccontainer.azurecr.io/helloworld:latest|g" deployment.yml'
                        sh "git add ."
                        sh 'git commit -m "chnages the image name"'
                        withCredentials([gitUsernamePassword(credentialsId: 'test-tken-v', gitToolName: 'Default')]) {
                            
                        sh "git push https://venkateshmuddusetty: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@github.com/venkateshmuddusetty/test.git"
                        }
                    }
                }
            }
        }
    
