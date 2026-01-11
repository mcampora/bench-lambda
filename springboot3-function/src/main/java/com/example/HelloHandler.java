package com.example;

import java.util.function.Supplier;
import java.util.List;
import java.util.ArrayList;
import org.springframework.stereotype.Component;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class HelloHandler implements Supplier<List<String>> {  

    private static final Logger logger = LoggerFactory.getLogger(HelloHandler.class);

  	@Override
	public List<String> get() {
        logger.info("testGet invoked!");
        List<String> response = new ArrayList<String>();
        response.add("one");
        response.add("two");
        response.add("three");  
        return response;
    }
}