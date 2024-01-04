# Introduction

Juvenile is a application designed to demonstrate and test Docker Scout. This service is vulnerable application level and base image CVE's. 

## Resources:
* [Docker Scout Overview](https://docs.docker.com/scout/)

## Demonstrating Steps

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
  - Remediation can be performed by navigating to  `package.json` and changing line 20 `"express":"4.17.1"` to `"express": "4.17.3"` as suggested by Scout in the terminal output. 
  - Perform docker build `docker build -t <ORG_NAME>/juvenile:1.0 .`
  - Executing the Scout command again should no longer result in application layer vulnerabilities.
5. Invoke Scout index, display CVE's remediation context for base images:
`docker scout recommendations`
  - Remediation can be performed by navigating to  `Dockerfile` and changing `FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae` to `FROM alpine:3.16` as suggested by Scout in the terminal output. 
  - Perform docker build `docker build -t <ORG_NAME>/juvenile:1.0 .`
  - Executing the Scout command again should no longer result in base layer vulnerabilities.

### GUI Demonstration steps
1. In Docker Desktop navigate to `<ORG_NAME>/juvenile:1.0`
2. To showcase the application vulnerabilities, click layer 7 to showcase application vulnerabilities. Expand `express 4.17.1` then `CVE-2022-24999`. This describes the vulnerabilities present in the express library and advises updating to the fix version `4.17.3`
3. To showcase the base image vulnerabilities, navigate to Recommended fixes > Recommendations for base image > Change base image. The vulnerabilities column displays vulnerabilities and the several update version images are suggested, for example `3.16`. 
4. Navigate to the project in VS Code or your preferred code editor.
5. Inside `package.json` modify line 20 `"express":"4.17.1"` to `"express": "4.17.3"` as suggested by Scout.
6. Remediation of base image vulnerabilities can be performed by navigating to  `Dockerfile` and changing `FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae` to `FROM alpine:3.16` as suggested by Scout.
7. Open terminal. In VS Code this can be performed with CMD+J. Perform docker build `docker build -t <ORG_NAME>/juvenile:1.0 .`
8. Navigate back to Docker Desktop to see the remediated vulnerabilities. 

### Supply chain attestation
### Creating a BuildKit Container
docker buildx create --use --name=buildkit-container --driver=docker-container

### Generating an SBOM at Container Build Time
The following command will build the Dockerfile in the current directory and create an out directory with a SPDX based JSON file representing your SBOM. It will also generate an attestation that proves the provenance of the image.

`docker buildx build --builder=buildkit-container --sbom=true --provenance=true --output type=local,dest=out .`

Once you've verified your SBOM output locally, you can build, attest, generate an SBOM, and push it to your registry with the following command.

`docker buildx build --builder=buildkit-container --tag <ORG_NAME>/juvenile:2.1.0 --attest=type=sbom --attest=type=provenance --push .`

### Generating an SBOM from an Image
If you need to generate an SBOM from an image that has already been built, you can do so with the following command.

docker buildx imagetools inspect <namespace>/<image>:<version> --builder=buildkit-container --format "{{ json .SBOM.SPDX }}"

