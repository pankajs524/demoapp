<h1>Deployment on EKS Cluster</h1>

Description: Demo code/scripts to deploy a Javascript page to display current weather. The steps include -
- Create an EKS cluster in AWS Ohio (us-east-2) using terraform scripts
- Create EKS storage
- Deploy Jenkins on an EKS pod
- Build sample app to show weather
- Build Docker image
- Jenkins pipeline for CICD

<h3>Toolset</h3>
<ul>
<li>Editor - Visual Studio Code</li>
<li>AWS CLI</li>
<li>Kubectl CLI</li>
<li>Terraform CLI</li>
<li>AWS account</li>
<li>Git account</li>
<li>DockerHUB account</li>
</ul>

<h1>Create a Cluster</h1>
Create a AWS account with secrete key and access key. The main.tf in the "terraform" folder is the terraform script
<ul>
<li>AWS Configure providing access key, secret access key and region to connect your terminal to aws account</li>
<li>Run terraform init #to initilize terraform and download required modules</li>
<li>Run terraform plan #to plan out all the infra requirement</li>
<li>Run terraform apply #build out the cluster, respond "yes" to continue</li>
</ul>

<h1>Provision Storage for PODS</h1>
Need to provision EFS storage for PODS to share data. The Jenkins folder contain JenkinsScript.txt to execute the steps -
<ul>
<li>Update the default kubeconfig file to use the new cluster as the current context. Replace CLUSTER_NAME with EKS cluster name used in the terraform script</li>
<li>Deploy EFS CSI storage driver</li>
<li>Retreive VPC ID, you can also retrieve the same from the AWS Console</li>
<li>Retreive CIDR range, you can also retrieve the same from the AWS Console</li>
<li>Create security group</li>
<li>Authorize security group</li>
<li>Create EFS Storage</li>
<li>Create mount point</li>
<li>Retrive filesystem id to be used in the jenkins.pv.yaml file</li>
</ul>

 <h1>Deploy Jenkins on an EKS pod</h1>
 <ul>
 <li>Setup Namespace for jenkins</li>
 <li>Create volume on the storage</li>
 <li>Claim volume for jenkins</li>
 <li>Deploy Jenkins </li>
 <li>Deploy the Jenkins pod</li>
 <li>Expose the Jenkins service and port forward to localhost</li>
 </ul>

 <h1>Build sample app to show weather</h1>
 - Create a branch of "website" folder from the repo.

 <h1>Build Docker image</h1>
 <ul><li>Login into DockerHub account ( sample docker login -u <<DOCKERHUB_USER>>)</li>
 <li>Using DockerFile to build (sample docker build -t demoweather:tagname . )</li>
 </ul>

 <h1>Jenkins pipeline for CICD</h1>
 Build the jenkins pipeline using the sciprt "pipeline.txt" file for CICD process.
