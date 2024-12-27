// vars/dockerPullImage.groovy
def call(String imageName, String buildNumber, String dockerRegistry) {
    sh """
        docker pull ${dockerRegistry}/${imageName}:${buildNumber}
    """
}
