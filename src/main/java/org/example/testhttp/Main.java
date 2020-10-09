package org.example.testhttp;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse.BodyHandlers;
import java.time.Duration;

import static java.net.http.HttpClient.Redirect.NORMAL;
import static java.net.http.HttpClient.Version.HTTP_2;

public class Main {

    public static void main(String[] args) throws URISyntaxException, IOException, InterruptedException {
        var client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(5))
                .followRedirects(NORMAL)
                .version(HTTP_2)
                .build();

        var req = HttpRequest.newBuilder()
                .uri(new URI("https://google.com"))
                .GET()
                .build();

        var resp = client.send(req, BodyHandlers.ofByteArray());
        assert 200 <= resp.statusCode() && resp.statusCode() < 300;
        System.out.println(resp.body().length);
    }

}
