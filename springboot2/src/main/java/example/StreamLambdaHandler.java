package example;

import com.amazonaws.serverless.exceptions.ContainerInitializationException;
import com.amazonaws.serverless.proxy.model.AwsProxyRequest;
import com.amazonaws.serverless.proxy.model.AwsProxyResponse;
import com.amazonaws.serverless.proxy.model.AwsProxyRequestContext;
import com.amazonaws.serverless.proxy.model.ApiGatewayRequestIdentity;
import com.amazonaws.serverless.proxy.spring.SpringBootLambdaContainerHandler;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.CognitoIdentity;
import com.amazonaws.services.lambda.runtime.ClientContext;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StreamLambdaHandler implements RequestStreamHandler {
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private static Logger log = LoggerFactory.getLogger(StreamLambdaHandler.class);
    private static SpringBootLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> handler;

    public static class TestLogger implements LambdaLogger {
        @Override
        public void log(String message) {
            log.info(message);
        }
        @Override
        public void log(byte[] message) {
            log.info(new String(message));
        }
    }
    
    public static class TestContext implements Context {
        public TestContext() {}
        @Override
        public String getAwsRequestId(){
            return new String("495b12a8-xmpl-4eca-8168-160484189f99");
        }
        @Override
        public String getLogGroupName(){
            return new String("/aws/lambda/my-function");
        }
        @Override
        public LambdaLogger getLogger(){
            return new TestLogger();
        }
        @Override
        public String getLogStreamName() {
            return null;
        }
        @Override
        public String getFunctionName() {
            return null;
        }
        @Override
        public String getFunctionVersion() {
            return null;
        }
        @Override
        public String getInvokedFunctionArn() {
            return null;
        }
        @Override
        public CognitoIdentity getIdentity() {
            return null;
        }
        @Override
        public ClientContext getClientContext() {
            return null;
        }
        @Override
        public int getRemainingTimeInMillis() {
            return 0;
        }
        @Override
        public int getMemoryLimitInMB() {
            return 0;
        }
    }

    static {
        try {
            handler = SpringBootLambdaContainerHandler.getAwsProxyHandler(Application.class);

            // Send a fake Amazon API Gateway request to the handler to load classes ahead of time
            ApiGatewayRequestIdentity identity = new ApiGatewayRequestIdentity();
            identity.setApiKey("foo");
            identity.setAccountId("foo");
            identity.setAccessKey("foo");

            AwsProxyRequestContext reqCtx = new AwsProxyRequestContext();
            reqCtx.setPath("/");
            reqCtx.setStage("default");
            reqCtx.setAuthorizer(null);
            reqCtx.setIdentity(identity);

            AwsProxyRequest req = new AwsProxyRequest();
            req.setHttpMethod("GET");
            req.setPath("/");
            req.setBody("");
            req.setRequestContext(reqCtx);

            Context ctx = new TestContext();
            handler.proxy(req, ctx);
            
        } catch (ContainerInitializationException e) {
            // if we fail here. We re-throw the exception to force another cold start
            e.printStackTrace();
            throw new RuntimeException("Could not initialize Spring Boot application", e);
        }
    }

    public StreamLambdaHandler() {
    }

    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context)
            throws IOException {        
        // log execution details (no access to the lambda context at this level)
        log.info("ENVIRONMENT VARIABLES: " + gson.toJson(System.getenv()));
        log.info("CONTEXT: " + gson.toJson(context));
        // process event
        log.info("EVENT: " + gson.toJson("")); //event));
        log.info("EVENT TYPE: " + ""); //event.getClass());

        handler.proxyStream(inputStream, outputStream, context);
    }
}
