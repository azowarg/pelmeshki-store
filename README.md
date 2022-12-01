#  Ian Bodrievskii Pelmeshski-store

<p align="center">
<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">
<br>
<br>
<strong>The application consists of two microservices. A backend written in Golang and a frontend written in Node JS.</strong>
</p>

## Frontend

To get frontend artifacts, use this commands:

```console
npm install
npm run build
```
And if you want to launch webserver with service:

```console
VUE_APP_API_URL=http://localhost:8081
npm run serve
```

## Backend
To compile backend binaries:

```console
go test -v ./... # Unit-tests
go build ./cmd/api
```
 Run service:

```console
chmod +x api
./api
```
Each service is assembled into a docker image. Which are stored in the Gitlab Container Registry. Dockerfiles are stored in the appropriate directories.

# **Working app**
https://pelmeshki.ian-bodrievskii.ru/

# Repository structure
At the moment, the repository contains 3 branches.
Main - the main code for the release on production.
Development - to develop and implement new functionality and deploy to test server.
Infrastructure - to change our IaC code and infrastructure settings.

# Infrastructure deployment

The infrastructure is stored in terraform and deployed in Yandex cloud. At the moment it consists of two s3 buckets. To store the terraform state and to store the files required for the application. Kubernetes cluster for production and deployment of applications from the main branch. As well as a virtual machine for test operation.

# Rules for making changes to the infrastructure
All changes should be carried out in a separate branch and, after the review, merged into the main branch for the infrastructure.

# Release cycle of the application and the rules of versioning
Application versioning corresponds to Semantic Versioning.

Given a version number MAJOR.MINOR.PATCH, increment the:

- MAJOR version when you make incompatible API changes.
- MINOR version when you add functionality in a backwards compatible manner.
- PATCH version when you make backwards compatible bug fixes.

After the development of a new feature and review and confirmation of the merge request, the CI/CD pipeline is turned on.

> Build stage
>> - Run unit-tests and compile ordinary artifacts and binary files.
>> - Build docker images

> Test stage
>> - Run SAST Gitlab tests.
>> - Run SonarQube tests

> Release stage. If all tests are succesful:
>> - Mark artifacts with correct version and send them to Nexus repository
>> - Download last docker image and mark it as latest.
>> - Release new helm chart for k8s cluster

> Deploy
>> - Manual for main branch. Just upgrade fo last helm chart.
>> - Automatic for developmet env. Install new version with ansible. Deploy in docker via docker-compose

# Monitoring
Cluster and application monitoring via Grafana
https://grafana.ian-bodrievskii.ru/

# P.S.
There is a potential to implement even more functionality. But it takes a huge amount of time to study it. I plan to improve and develop this repository as well as add new interesting features in the future.
