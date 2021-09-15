# Versions

   ```
    Terraform Version - 0.12.31
    AKS - 1.20.9
   ```

# Type of Resources

  - Docker
  - Terraform 
  - Azure Container Registry
  - Azure Kubernetes Service
  - Storage Account - Blob Container
  - Create Deployment on Kubernetes to host various version of application

# Dockerizing the application and pushing it to ACR repository.

  - Make sure the application binary files are present in the same directory as that of Dockerfile
  - First Version of Application

   ```
   FROM alpine:3.14
   COPY /bin/ /app
   WORKDIR /app
   EXPOSE 8080
   ENTRYPOINT ["./eVision-product-ops.linux.1.0.0"]
   ```
  
  - Second Version of Application
   
   ```
   FROM alpine:3.14
   COPY /bin/ /app
   WORKDIR /app
   EXPOSE 8080
   ENTRYPOINT ["./eVision-product-ops.linux.1.0.1"]
   ```

   - Tagging this image with **`v1`** and **`v2`** versions.

# Terraform Code to create repeatable Infra

  - This repository contains the required terraform files to provision the infrastructure.
  - It will create an AKS cluster.
  - ACR Registry.
  - Storage Account.


# Azure Container Registry

   - Pushing both Docker image to private container repository Azure Container Registory in this case.
   - Use below command to tag and push the docker image
     
     ``` 
      docker tag <IMAGE TAG> enablon.azurecr.io/v1:v1
      docker tag <IMAGE TAG> enablon.azurecr.io/v2:v2
      az acr login enablon.azurecr.io
      docker push enablon.azurecr.io/v1:v1
      docker push enablon.azurecr.io/v2:v2
     ```
   - ACR **`enablon.azurecr.io`** this is configured as anonymus pull, so you can directly pull from the repo and run the deployment.

#  Deployment

   - Below is the deployment file that needs to be created with >1 replicas to serve traffic and applications availability
   - Deployment is making use of the image that we build and push to the ACR in the previous steps.

      ```
       apiVersion: apps/v1
       kind: Deployment
       metadata:
         creationTimestamp: null
         labels:
           app: wk
         name: wk
       spec:
         replicas: 3
         selector:
           matchLabels:
             app: wk
         strategy: {}
         template:
           metadata:
             creationTimestamp: null
             labels:
               app: wk
           spec:
             containers:
             - image: enablon.azurecr.io/v1:v1
               imagePullPolicy: Always
               name: v1
               resources: {}
       status: {} 
      ```
    
   - Second resource is to expose the deployment as a service with type Load Balancer IP which gets the External Public IP and the application will be accessible on this IP

      ``` 
       apiVersion: v1
       kind: Service
       metadata:
         creationTimestamp: null
         labels:
           app: wk
         name: wk
       spec:
         ports:
         - port: 8080
           protocol: TCP
           targetPort: 8080
         selector:
           app: wk
         type: LoadBalancer
       status:
         loadBalancer: {}
      ```

   - Once the service get the public ip try to access it over the **`http://<public_ip>:8080/success`** that will return as below

     ![svc](images/svc.PNG)


   - Once the deployment of first version is done successfully use below command to release the new feature/version of the image.

     ```
      kubectl set image deployment wk v1=enablon.azurecr.io/v2:v2
     ```

   - Verify the deployment **`http://<public_ip>:8080/success`** that will return as below

     ![v2](images/v2.PNG)

     OR

     ```
       for ((i=1;i<=100;i++)); do curl "http://20.81.72.239:8080/success"; sleep 2;done
     ```


# Storage Backend

  - As a best practice we are storing the **`tfstate`** file in the storage account named **`tfstateacme`** under blob container **`tfstate`**
