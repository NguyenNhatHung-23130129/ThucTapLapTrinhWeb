package vn.edu.hcmuaf.fit.doanweb.services;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public class ShippingService {
    private static final String ACCESS_TOKEN = System.getenv("GOSHIP_ACCESS_TOKEN");
    private static final String BASE_URL = "https://sandbox.goship.io/api/v2";

    private static final Map<String, String> CITY_MAP = new HashMap<>();

    static {
        CITY_MAP.put("Thành phố Hà Nội", "100000");
        CITY_MAP.put("Thành phố Hồ Chí Minh", "700000");
        CITY_MAP.put("Thành phố Hải Phòng", "300000");
        CITY_MAP.put("Thành phố Đà Nẵng", "500000");
        CITY_MAP.put("Thành phố Cần Thơ", "900000");
        CITY_MAP.put("Tỉnh Bình Dương", "740000");
        CITY_MAP.put("Tỉnh Đồng Nai", "730000");
    }

    public static double calculateFee(String cityFrom, String cityTo, int weight, String method) {
        try {
            String finalCityTo = CITY_MAP.getOrDefault(cityTo, "700000");

            String jsonPayload = String.format(
                    "{\"shipment\":{\"address_from\":{\"city\":\"%s\"},\"address_to\":{\"city\":\"%s\"},\"parcel\":{\"weight\":%d}}}",
                    cityFrom, finalCityTo, weight
            );

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + "/rates"))
                    .header("Authorization", "Bearer " + ACCESS_TOKEN)
                    .header("Content-Type", "application/json")
                    .header("Accept", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            JSONObject obj = new JSONObject(response.body());

            if (obj.getInt("status") == 200) {
                org.json.JSONArray data = obj.getJSONArray("data");

                for (int i = 0; i < data.length(); i++) {
                    JSONObject carrier = data.getJSONObject(i);
                    String serviceName = carrier.getString("service_name").toLowerCase();

                    if ("cold".equals(method) && (serviceName.contains("lạnh") || serviceName.contains("hỏa tốc"))) {
                        return carrier.getDouble("total_fee");
                    }
                    if ("express".equals(method) && serviceName.contains("nhanh")) {
                        return carrier.getDouble("total_fee");
                    }
                }

                if ("cold".equals(method)) return 50000;
                if ("express".equals(method)) return 30000;

                return data.getJSONObject(0).getDouble("total_fee");

            } else {
                System.out.println("Goship API Error: " + obj.toString());
                if (method.equals("cold")) return 50000;
                if (method.equals("express")) return 30000;
                return 15000;
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (method.equals("cold")) return 50000;
            if (method.equals("express")) return 30000;
            return 15000;
        }
    }
}