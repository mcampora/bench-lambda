package com.example;

 import org.springframework.web.bind.annotation.GetMapping;
 import org.springframework.web.bind.annotation.RestController;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.List;
import java.util.ArrayList;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Springboot3!";
    }

    private static Logger log = LoggerFactory.getLogger(HelloController.class);

    @GetMapping("/")
    public List<String> testGet() {
        log.info("testGet invoked!");
        List<String> response = new ArrayList<String>();
        response.add("one");
        response.add("two");
        response.add("three");  
        return response;
    }
}
