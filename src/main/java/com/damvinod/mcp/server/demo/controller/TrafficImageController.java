package com.damvinod.mcp.server.demo.controller;

import com.damvinod.mcp.server.demo.model.TrafficImageResponse;
import com.damvinod.mcp.server.demo.service.TrafficImageService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TrafficImageController {

    private TrafficImageService trafficImageService;

    TrafficImageController(TrafficImageService trafficImageService) {
        this.trafficImageService = trafficImageService;
    }

    @GetMapping(path = "/get-traffic-image", produces = "application/json")
    public TrafficImageResponse trafficImage() {
        return this.trafficImageService.trafficImage();
    }
}

