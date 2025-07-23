package com.damvinod.mcp.server.demo.model;

import java.util.List;

public record TrafficImageResponse(ApiInfo apiInfo, List<TrafficImages> items, ErrorDetails error) {

    public record ApiInfo(String description, String status) {
    }

    public record ErrorDetails(Integer code, String message) {
    }
}

