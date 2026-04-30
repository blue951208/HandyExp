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

        try {
            String result = fileService.uploadFile(file, "image");
        } catch (Exception e) {
            System.out.println("파일 업로드 중 에러 발생: " + e.getMessage());
        }


        return "파일 업로드 기능은 아직 구현되지 않았습니다.";
    }
}
