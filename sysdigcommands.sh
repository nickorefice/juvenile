kubectl create ns sysdig-agent
helm repo add sysdig https://charts.sysdig.com
helm repo update
helm install sysdig-agent --namespace sysdig-agent \
    --set global.sysdig.accessKey=535c31e2-566f-400d-b3c6-cce5d42104fe \
    --set global.sysdig.region=us2 \
    --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
    --set global.kspm.deploy=true \
    --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=false \
    --set nodeAnalyzer.nodeAnalyzer.runtimeScanner.settings.eveEnabled=true \
    --set nodeAnalyzer.nodeAnalyzer.runtimeScanner.eveConnector.deploy=true \
    --set global.clusterConfig.name=education-cluster \
    sysdig/sysdig-deploy
    

curl --location 'https://us2.app.sysdig.com/api/scanning/eveintegration/v2/runtimeclusters' \
--header 'Authorization: Bearer 02ac9a84-7719-45e0-a6b0-0a2a04de1618-c2EK'