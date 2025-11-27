# Lambda snapstart naive evaluation
## Intro
This repo contains a test scenario designed to evaluate cold starts with AWS Lambda.  
Some subprojects have been created, they capture a different implementation (./java-basic, ./nodejs-basic, ./springboot2).  

A script is runnning the following sequence:
- create a bucket to store the artefacts
- for each subproject, build and deploy the lambda, invoke the lambda 10 times, collect traces
- Java subprojects are tested with and without the snapstart option to measure the benefit of this option
- collected traces are available in the ./results folder
```
./scenario.sh
```

The script assumes you defined credentials beforehand, for instance:  
```
export AWS_ACCESS_KEY_ID="...""  
export AWS_SECRET_ACCESS_KEY="..."  
export AWS_SESSION_TOKEN="..."  
```

## Observations
At the time of writing I collected the following observations:
- basic Java and basic JavaScript are comparable, ie. it takes 500-600ms to warmup the lambda in both cases
- snapstart option brings marginal improvements to the basic Java example (100-200ms)
- SpringBoot takes 6s to warmup, class loading and dependency injection takes its toll
- this time snapstart brings significant improvements (1s to warmup)
- the improvement is even more significant if you give more memory to the lambda (500ms), the amount of CPU allocated to the lambda is proportional to the allocated memory (so is the price)
- it is quite transparent to wrap a springboot controller in a lambda handler (the build strips the tomcat distribution and adds instead an AWS library)

## Todo
- consolidate traces, generate a report with max and 90ile
- beef up the examples with more complex dependencies, for instance write a simple CRUD service connecting to a simple database
- add a new target using a custom image, GraalVM and SpringBoot
