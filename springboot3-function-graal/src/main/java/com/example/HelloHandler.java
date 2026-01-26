package com.example;

import java.util.function.Supplier;
import java.util.List;
import java.util.ArrayList;
import org.springframework.stereotype.Component;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.io.IOException;

// test reflection and native image difficulties
import java.lang.reflect.Method;
    
// I added this code to prove that by default native-image
// does not include StringCapitalizer in the native image
// and Class.forName() does not work
//
// the tool does a good job with Spring injection
// it even detects dependencies if you use String constants
// it fails if the String is loaded at runtime from a file or other source
//

class StringCapitalizer {
    static String capitalize(String input) {
        return input.toUpperCase();
    }
}

class ReflectionExample {
    private static String readNameFromFile() throws IOException {
        try (InputStream inputStream = ReflectionExample.class.getClassLoader().getResourceAsStream("name.txt")) {
            if (inputStream == null) {
                throw new IOException("File not found in resources: name.txt");
            }
            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8).trim();
        }
    }

    public static void test() throws Exception {
        String name = readNameFromFile();
        
        String className = name;
        String methodName = "capitalize";
        String input = "foo";

        Class<?> clazz = Class.forName(className);
        Method method = clazz.getDeclaredMethod(methodName, String.class);
        Object result = method.invoke(null, input);
        
        System.out.println(result);
    }
 }

@Component
public class HelloHandler implements Supplier<List<String>> {  
    private static final Logger logger = LoggerFactory.getLogger(HelloHandler.class);

  	@Override
	public List<String> get() {
        logger.info("testGet invoked!");

        try {
            ReflectionExample.test();
        } catch (Exception e) {
            logger.error("Exception in testGet", e);
        }

        List<String> response = new ArrayList<String>();
        response.add("one");
        response.add("two");
        response.add("three");  
        return response;
    }
}