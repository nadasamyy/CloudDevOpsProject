// dockerBuild.groovy

def call(String dockerRegistry, String dockerImage, String buildNumber) {
    echo "Building Docker Image: ${dockerRegistry}/${dockerImage}:${buildNumber}"
    
    // Build Docker Image using bat for Windows
    bat "docker build -t ${dockerRegistry}/${dockerImage}:${buildNumber} ."
}
