package vn.edu.hcmuaf.fit.doanweb.utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryUtils {
    private static Cloudinary cloudinary;

    public static Cloudinary getInstance() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dhkvbxxus",
                    "api_key", "664686581317923",
                    "api_secret", "OIN8tK4G7P84OgeOhWbYd1PoFqI"
            ));

        }
        return cloudinary;
    }
}
