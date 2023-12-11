# juvenile

Repository to demo Docker Scout. 

This service is vulnerable to a couple of application level CVEs as well as some CVEs from the base image. The repository can be used to talk through discovering and remediating CVEs via direct package update and by using base image update recommendation.

## Resources:

* [Demo walkthrough](https://docs.google.com/document/d/1iOD9GxuowNdts_6GoYQZAn0tZ1U2NlL80R0dD9p8Pek/edit#heading=h.cwbhwl5pgrqf)
* [Demo training recording](https://docker.zoom.us/rec/share/jLyBiTCBxxaVF4w5BB4AvrMsS7ZXBfwJsJir8DY2hWHzEK1qAHfUrnsV97HEC6A.Dx72GwfNdMFadOB0) - password: yHi@8BA!



# Nick's steps


docker build . -f Dockerfile -t nicholasorefice126/scout-demo-service:nickorefice

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