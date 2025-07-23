package com.damvinod.mcp.server.demo.service;

import com.damvinod.mcp.server.demo.model.TrafficImageResponse;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Service
public class TrafficImageService {

    private static final String BASE_URL = "https://api.data.gov.sg/v1/transport/traffic-images";

    private final RestClient restClient;

    TrafficImageService() {
        this.restClient = RestClient.builder()
                .baseUrl(BASE_URL)
                .defaultHeader("Accept", "application/geo+json")
                .defaultHeader("User-Agent", "WeatherApiClient/1.0 (your@email.com)")
                .build();
    }

    @Tool(name = "get_traffic_image", description = "Get traffic image from the camera")
    public TrafficImageResponse trafficImage() {

        return restClient.get()
                .uri(BASE_URL)
                .retrieve()
                .body(TrafficImageResponse.class);
    }
}

