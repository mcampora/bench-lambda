# setup
sdk install java 25-graal
sdk default java 25-graal

# launch an app
works like a regular JVM  
java -classpath $( pwd )/target/classes com.example.App app  

# create a native image
native-image -classpath $( pwd )/target/classes com.example.App app  
./app

# using Maven
check the page in the references for pom edits.  

mvn -Pnative package
./target/java-container-basic

# profiling with an agent to capture the classes to compile
java -agentlib:native-image-agent=config-output-dir=./ com.example.App  
to be tested with springboot  

# springboot3
used the scaffolfing.  
modified the pom.xml as instructed.   

to build and run the app  
./mvnw spring-boot:run
curl http://localhost:8080/hello

to build a docker image
./mvnw -Pnative spring-boot:build-image
docker run --rm -p 8080:8080 docker.io/library/demo:0.0.1-SNAPSHOT

or a simple graalvm native image
./mvnw -Pnative native:compile
./target/demo

to collect metadata
java -agentlib:native-image-agent=config-output-dir=./ -jar ./target/graal-container-springboot3-0.0.1-SNAPSHOT.jar
they endup in reachability-metadata.json

# refs
- maven https://www.graalvm.org/latest/reference-manual/native-image/#build-a-native-executable-using-maven-or-gradle
- tracing https://www.graalvm.org/latest/reference-manual/native-image/metadata/AutomaticMetadataCollection/
- springboot3 https://www.graalvm.org/latest/reference-manual/native-image/guides/build-spring-boot-app-into-native-executable/ 