package com.mukminov.config;

import com.mukminov.properties.GitHubClientProperties;
import okhttp3.OkHttpClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public OkHttpClient okHttpClient(GitHubClientProperties properties) {
        return new OkHttpClient.Builder()
                .connectTimeout(properties.getConnectTimeout())
                .readTimeout(properties.getReadTimeout())
                .build();
    }
}