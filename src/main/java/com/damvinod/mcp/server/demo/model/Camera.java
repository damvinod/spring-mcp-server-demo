package com.damvinod.mcp.server.demo.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Camera(String description, String timestamp, @JsonProperty("camera_id") String cameraId, @JsonProperty("image_id")String imageId, String image) {
}