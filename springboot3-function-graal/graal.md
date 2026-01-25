# setup
prereq, install sdk man.  

Install a graal VM distribution.  
```
sdk install java 21-graalce
sdk default java 21-graalce
```
# launch an app
works like a regular JVM  
```
mvn clean package
java -jar ./target/springboot3-function-graal-1.0.0-SNAPSHOT.jar
```

# create a native image
Comes with a new native-image tool:
```
native-image -classpath ./target/classes <main-class> <output-file>  
./<output-file>
```
Using Maven:  
```
mvn -Pnative package
./target/springboot3-function-graal
```

# profiling with an agent to capture the classes to compile
To collect metadata:
```
java -agentlib:native-image-agent=config-output-dir=./src/main/resources/META-INF/native-image -jar ./target/springboot3-function-graal-1.0.0-SNAPSHOT.jar &

curl http://localhost:8080

kill %1
```

If you rebuild your native image, it will use the collected metadata: 
```
mvn clean -Pnative package

./target/springboot3-function-graal
```

# refs
- maven https://www.graalvm.org/latest/reference-manual/native-image/#build-a-native-executable-using-maven-or-gradle
- tracing https://www.graalvm.org/latest/reference-manual/native-image/metadata/AutomaticMetadataCollection/
- springboot3 https://www.graalvm.org/latest/reference-manual/native-image/guides/build-spring-boot-app-into-native-executable/ 