APP=springboot3-function-graal-1.0.0-SNAPSHOT.jar
METADATA_DIR=./src/main/resources/META-INF/native-image
mvn clean package
${JAVA_HOME}/bin/java -agentlib:native-image-agent=config-output-dir=${METADATA_DIR} -jar ./target/${APP} &
sleep 30
curl http://localhost:8080
kill %1
sleep 10
mvn clean -Pnative package -DskipTests
