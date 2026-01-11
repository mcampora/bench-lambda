package com.example;

import java.util.HashSet;

import org.joda.time.DateTime;
import org.springframework.aot.hint.RuntimeHints;
import org.springframework.aot.hint.RuntimeHintsRegistrar;
import org.springframework.aot.hint.annotation.RegisterReflectionForBinding;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportRuntimeHints;

import static org.springframework.aot.hint.MemberCategory.*;

@Configuration
@RegisterReflectionForBinding({DateTime.class, HashSet.class})

@ImportRuntimeHints(ApplicationConfiguration.ApplicationRuntimeHintsRegistrar.class)

public class ApplicationConfiguration {
	
	public static class ApplicationRuntimeHintsRegistrar implements RuntimeHintsRegistrar {

        @Override
        public void registerHints(RuntimeHints hints, ClassLoader classLoader) {
        }
    }

}
