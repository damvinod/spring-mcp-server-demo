package com.damvinod.mcp.server.demo;

import com.damvinod.mcp.server.demo.service.TrafficImageService;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class SpringMcpServerDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringMcpServerDemoApplication.class, args);
    }

    @Bean
    public ToolCallbackProvider weatherTools(TrafficImageService trafficImageService) {
        return MethodToolCallbackProvider.builder().toolObjects(trafficImageService).build();
    }
}
