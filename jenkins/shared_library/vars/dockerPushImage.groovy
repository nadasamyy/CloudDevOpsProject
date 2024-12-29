// dockerPushImage.groovy

def call(String dockerRegistry, String dockerImage, String buildNumber) {
    echo "Pushing Docker Image: ${dockerRegistry}/${dockerImage}:${buildNumber}"

    // Login to Docker Registry using bat for Windows
    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} ${dockerRegistry}"
    }
    
    // Push Docker Image to Registry using bat for Windows
    bat "docker push ${dockerRegistry}/${dockerImage}:${buildNumber}"
}

