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
