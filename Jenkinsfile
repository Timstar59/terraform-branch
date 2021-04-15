pipeline{
            agent any
            stages{
                    stage('--Front End--'){
                            steps{
                                    sh '''
                                            image="35.177.97.39:5000/frontend:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/frontend
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_frontend
                                    '''
                            }
                    }  
                    stage('--Service1--'){
                            steps{
                                    sh '''
                                            image="35.177.97.39:5000/rand1:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp1
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_service1
                                    '''
                            }
                    }
                    stage('--Service2--'){
                            steps{
                                    sh '''
                                            image="35.177.97.39:5000/rand2:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp2
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_service2
                                    '''
                            }
                    }
                    stage('--Back End--'){
                            steps{
                                    sh '''
                                            image="35.177.97.39:5000/backend:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/backend
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_backend
                                    '''
                            }
                    }
                    stage('--Clean up--'){
                            steps{
                                    sh '''
                                            ssh 18.132.43.144  << EOF
                                            docker system prune
                                    '''
                            }
                    }
            }
    }
