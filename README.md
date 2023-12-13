# Introduction

Repository to demo Docker Scout. 

This service is vulnerable application level and base image CVE's. The repository can be used to test index and remediation of vulnerabilities using Docker Scout.

## Resources:
* [Docker Scout Overview] (https://docs.docker.com/scout/)

## Steps

### Initial setup
1. Clone repository: 
`git clone norefice-github/juvenile`
2. Traverse to directory:
`cd juvenile`
3. Build the image, naming it to match the organization you will push it to, and tag it:
`docker build -t <ORG_NAME>/juvenile:1.0 .`
4. Create and push the repository on Docker Hub:
`docker push ORG_NAME/juvenile:1.0`

### CLI Demonstration steps
1. Traverse to directory:
`cd juvenile`
2. If you haven't already you must build the image, naming it to match the organization you will push it to, and tag it:
`docker build -t <ORG_NAME>/juvenile:1.0 .`
3. Invoke Scout index. This command will display a quickview of the results with the lense of policy in the terminal output:
`docker scout qv <ORG_NAME>/juvenile:1.0`
4. Invoke Scout index, display CVE's and filter out base image vulnerabilities:
`docker scout cves --ignore-base`
  - Remediation can be performed by navigating to  `package.json` and changing `"express":"4.17.1"` to `"express": "4.17.3"` as suggested by Scout in the terminal output. 
  - Executing the Scout command again should no longer result in application layer vulnerabilities.
5. Invoke Scout index, display CVE's remediation context for base images:
`docker scout recommendations`
  - Remediation can be performed by navigating to  `Dockerfile` and changing `FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae` to `FROM alpine:3.16` as suggested by Scout in the terminal output. 
  - Executing the Scout command again should no longer result in base layer vulnerabilities.



### CLI Demonstration steps


docker scout cves dockersales/scout-demo-service:nickorefice -> Noisy - show base image results

docker scout cves dockersales/scout-demo-service:nickorefice --ignore-base -> Ignores base. useful if platform or other team manages base image

How to fix?
See fix version in 'vulnerabilities' tab in DD or output of 'docker scout cves ...'

FROM alpine:3.15
#FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae

docker scout environment staging demonstrationorg/scout-demo-service:1.6 --platform linux/amd64
docker scout environment prod demonstrationorg/juvenile:main --platform linux/amd64


docker scout environment staging demonstrationorg/juvenile:1.1.3 --platform linux/amd64

# Build
docker build -t demonstrationorg/juvenile:1.1.3 . 
docker buildx build --provenance=true --sbom=true -t demonstrationorg/juvenile:1.1.3 --push .
docker build --tag demonstrationorg/juvenile:1.1.3 \
  --attest type=sbom,generator=docker/scout-sbom-indexer:d3f9c2d \
  --push .


docker scout compare --to demonstrationorg/juvenile:main

docker scout qv alpine:3.18.2

# as a developer, I want to assess quality of image
docker scout qv demonstrationorg/juvenile:1.1.3

# Now I explore the cves in my container image
docker scout cves demonstrationorg/juvenile:1.1.3
docker scout cves registry://demonstrationorg/security-playground:1.0.6 --platform linux/amd64

# I make some changes and deploy as v2; I want to see the cves for the v2 image (now with VEX attestation powered by Sysdig)
docker scout cves registry://demonstrationorg/juvenile:1.1.3  --platform linux/amd64 --org demonstrationorg

# I only want to see which of the existing cves for the v2 image are affected (filter using the VEX attestation powered by Sysdig)
docker scout cves registry://demonstrationorg/juvenile:1.1.3  --platform linux/amd64 --org demonstrationorg --only-vex-affected

# Still some work to do so I make some more changes and deploy a v3 image, showing "AFFECTED" only (ie. nothing)
docker scout cves registry://demonstrationorg/juvenile:1.1.3  --platform linux/amd64 --org demonstrationorg --only-vex-affected

# Finally, to prove those other unaffected cves false-positive are still in there 
docker scout cves registry://demonstrationorg/juvenile:1.1.3  --platform linux/amd64 --org demonstrationorg