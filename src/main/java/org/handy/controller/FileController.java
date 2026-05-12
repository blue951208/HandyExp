package org.handy.controller;

import org.handy.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @PostMapping("/upload")
    @ResponseBody
    public String upload(@RequestParam("file") MultipartFile file) {
        System.out.println("file : "+file);
        String result = "";

        String contentType = file.getContentType(); // 예: image/png, image/jpeg

        // image 파일 체크
        if (contentType == null || !contentType.startsWith("image/")) {
            return "잘못된 파일 형식입니다. 이미지 파일만 업로드하세요.";
        }

        try {
            result = fileService.uploadFile(file, "image");
        } catch (Exception e) {
            System.out.println("파일 업로드 중 에러 발생: " + e.getMessage());
        }

        if (!file.isEmpty() && result != null && !"".equals(result)) {
//            fileService.insertFileMst();
        }

        return result;
    }
}
