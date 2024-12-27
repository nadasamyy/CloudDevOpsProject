// vars/dockerPushImage.groovy
def call(String imageName, String buildNumber, String dockerRegistry, String dockerCredentialsId) {
    withCredentials([usernamePassword(credentialsId: dockerCredentialsId, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
        sh '''
            echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
            docker tag ${imageName}:${buildNumber} ${dockerRegistry}/${imageName}:${buildNumber}
            docker push ${dockerRegistry}/${imageName}:${buildNumber}
            docker logout ${dockerRegistry}
        '''
    }
}
