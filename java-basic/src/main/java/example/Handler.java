package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;

// Handler value: example.Handler
public class Handler implements RequestHandler<Map<String,String>, List<String>>{
  Gson gson = new GsonBuilder().setPrettyPrinting().create();
  @Override
  public List<String> handleRequest(Map<String,String> event, Context context)
  {
    LambdaLogger logger = context.getLogger();
    // log execution details
    logger.log("ENVIRONMENT VARIABLES: " + gson.toJson(System.getenv()));
    logger.log("CONTEXT: " + gson.toJson(context));
    // process event
    logger.log("EVENT: " + gson.toJson(event));
    logger.log("EVENT TYPE: " + event.getClass());
    List<String> response = new ArrayList<String>();
    response.add("one");
    response.add("two");
    response.add("three");  
    // sleep 1 second
    try {
      Thread.sleep(1000);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    return response;
  }
}