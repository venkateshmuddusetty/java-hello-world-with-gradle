pipeline {
    agent any
    environment {
        registryUrl = "ibmpoccontainer.azurecr.io"
        def passw = sh (
                         script: 'echo "Z2hwX2lrOXFVaWVvVERaRWk0ZkZSeWgyTlZFWmtzdnJ4UDFQcERSaw==" | base64 -d',
                            returnStdout: true
                         ).trim()
        }
    
    
        stages {
            stage( 'Gitcheckout') {
                steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], gitTool: 'Default', userRemoteConfigs: [[credentialsId: 'test-tken-v', url: 'https://github.com/venkateshmuddusetty/java-hello-world-with-gradle.git']]])
                    
                }
            }
            stage( 'Build') {
                steps {
                    script {
                        datas = readYaml (file : "$WORKSPACE/config.yml")
                        echo "build type is: ${datas.Build_tool}"
                        
                        
                        if( "${datas.Build_tool}" == "maven" )
                            sh 'mvn clean install'
                        else( "${datas.Build_tool}" == "gradle" )
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
                    sh "  git clone https://${passw}@github.com/venkateshmuddusetty/test.git"
                    }
               }
            stage( 'Update to AKS repo') {
                steps {
                        sh '''
                            set -e
                         
                            cat deployment.yml
                            sed -e "s|HELLO|ibmpoccontainer.azurecr.io/helloworld:latest|g" deployment.yml
                            '''
                            sh 'git config --global user.name "venkateshmuddusetty"'
                            sh 'git config --global user.email "venkat149dev@gmail.com"'
                            sh 'git remote set-url origin https://venkateshmuddusetty:${passw}@github.com/venkateshmuddusetty/test.git'
                            sh "git add ."
                            sh "git status"
                            sh 'git commit -m  "adding the image"'
                            sh 'git branch'
    
                            sh "  git push origin HEAD:main"
                      
                      
                    }
                }
            }
        }
    
