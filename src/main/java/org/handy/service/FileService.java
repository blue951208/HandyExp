package org.handy.service;

import org.handy.dto.FileMstDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {
    String uploadFile(MultipartFile file, String image);
}
