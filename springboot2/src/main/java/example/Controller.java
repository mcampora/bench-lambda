package example;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import java.security.Principal;
import java.util.Optional;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@EnableWebMvc
public class Controller {
    private static Logger log = LoggerFactory.getLogger(Controller.class);

    @RequestMapping(path = "/", method = RequestMethod.GET)
    public List<String> testGet() {
        log.info("testGet invoked!");
        List<String> response = new ArrayList<String>();
        response.add("one");
        response.add("two");
        response.add("three");  
        return response;
    }
}
