pipeline{
            agent any
            stages{
                    stage('--Front End--'){
                            steps{
                                    sh '''case $BRANCH_NAME in
                                    main) 
                                            image="35.177.97.39:5000/frontend:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/frontend
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_frontend 
                                            ;;
                                    development) 
                                            image="35.177.97.39:5000/frontend-dev:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/frontend
                                            docker push $image
                                            ssh 18.133.175.237  << EOF
                                            docker service update --image $image DnDCharacterGen_frontend 
                                            ;;
                                    esac
                                    '''
                            }
                    }  
                    stage('--Service1--'){
                            steps{
                                    sh '''case $BRANCH_NAME in
                                    main) 
                                            image="35.177.97.39:5000/rand1:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp1
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_service1 ;;
                                    development) 
                                            image="35.177.97.39:5000/rand1-dev:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp1
                                            docker push $image
                                            ssh 18.133.175.237  << EOF
                                            docker service update --image $image DnDCharacterGen_service1 ;;
                                    esac
                                    '''
                            }
                    }
                    stage('--Service2--'){
                            steps{
                                    sh '''case $BRANCH_NAME in
                                    main) 
                                            image="35.177.97.39:5000/rand2:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp2
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_service2 
                                            ;;
                                    development) 
                                            image="35.177.97.39:5000/rand2-dev:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/randapp2
                                            docker push $image
                                            ssh 18.133.175.237  << EOF
                                            docker service update --image $image DnDCharacterGen_service2 
                                            ;;
                                    esac
                                    '''
                            }
                    }
                    stage('--Back End--'){
                            steps{
                                    sh '''case $BRANCH_NAME in
                                    main) 
                                            image="35.177.97.39:5000/backend:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/backend
                                            docker push $image
                                            ssh 18.132.43.144  << EOF
                                            docker service update --image $image DnDCharacterGen_backend ;;
                                    development) 
                                            image="35.177.97.39:5000/backend-dev:build-$BUILD_NUMBER"
                                            docker build -t $image /var/lib/jenkins/workspace/DnD_master/backend
                                            docker push $image
                                            ssh 18.133.175.237  << EOF
                                            docker service update --image $image DnDCharacterGen_backend ;;
                                    esac
                                    '''
                            }
                    }
                    stage('--Clean up--'){
                            steps{
                                    sh '''case $BRANCH_NAME in
                                    main) 
                                            ssh 18.132.43.144  << EOF
                                            docker system prune ;;
                                    development) 
                                            ssh 18.133.175.237  << EOF
                                            docker system prune ;;
                                    esac
                                    '''
                            }
                    }
            }
    }
