package vn.edu.hcmuaf.fit.doanweb.utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.Map;

public class CloudinaryUpload {
    private static final Cloudinary cloudinary = CloudinaryUtils.getInstance();

    public static String uploadImage(byte[] fileBytes, String folder) throws IOException {
        Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                "folder", folder,
                "resource_type", "image"
        ));
        return (String) uploadResult.get("secure_url");
    }
    public static String handleUpload(HttpServletRequest request, String fileFieldName, String folderName, String oldUrlParamName) {
        try {
            Part filePart = request.getPart(fileFieldName);
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    throw new IllegalArgumentException("Chỉ cho phép upload file hình ảnh!");
                }
                byte[] fileBytes = filePart.getInputStream().readAllBytes();
                return uploadImage(fileBytes, folderName);
            }
            String oldUrl = request.getParameter(oldUrlParamName);
            return (oldUrl != null && !oldUrl.isEmpty()) ? oldUrl : "";

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

}

