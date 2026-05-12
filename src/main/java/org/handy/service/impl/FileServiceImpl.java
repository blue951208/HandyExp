package org.handy.service.impl;

import org.handy.dto.FileMstDto;
import org.handy.mapper.FileMstMapper;
import org.handy.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {

    private final String PROJECT_URL = "https://bvukavwhtdgxgwlglenv.supabase.co";
    private final String apiKey = "sb_publishable_IWeD_C_wgH1kir6DEzjVtw__Ukkva81";

    @Autowired
    private FileMstMapper fileMstMapper;

    @Override
    public String uploadFile(MultipartFile file, String bucketNm) {
        if (file == null || file.isEmpty()) {
            return "업로드할 파일이 없습니다.";
        }

        String originalFileName = file.getOriginalFilename();
        if (originalFileName == null) {
            return "파일 이름을 가져올 수 없습니다.";
        }

        String fileName = generateFileName(originalFileName);
        // 1. 요청 URL 생성 (버킷명/파일명)
        String url = PROJECT_URL + "/storage/v1/object/" + bucketNm + "/" + fileName;

        // 2. RestTemplate 생성
        RestTemplate restTemplate = new RestTemplate();

        // 3. 헤더 설정 (curl의 -H 옵션과 동일)
        HttpHeaders headers = new HttpHeaders();
        headers.set("apikey", apiKey);
        headers.set("Authorization", "Bearer " + apiKey); // JWT 토큰 자리
        headers.setContentType(MediaType.parseMediaType(file.getContentType())); // 파일의 MIME 타입 설정

        // 4. 바디 설정 (curl의 --data-binary와 동일하게 파일의 byte 데이터를 직접 전달)
        HttpEntity<byte[]> entity = null;
        try {
            entity = new HttpEntity<>(file.getBytes(), headers);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // 5. POST 요청 실행
        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                try {
                    FileMstDto fileMstDto = new FileMstDto();
                    fileMstDto.setVFileNm(fileName);
                    fileMstDto.setVOriginFileNm(originalFileName);
                    fileMstDto.setVPath("/storage/v1/object/public");
                    fileMstDto.setVBucketNm(bucketNm);
                    fileMstDto.setVContentType(file.getContentType());
                    fileMstMapper.insertFileMst(fileMstDto);
                } catch (Exception e) {
                    e.printStackTrace();
                    return "파일 정보 저장 중 에러 발생: " + e.getMessage();
                }

                return "업로드 성공: " + response.getBody();
            } else {
                return "업로드 실패: " + response.getStatusCode();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "에러 발생: " + e.getMessage();
            /*
            "{"statusCode":"409","error":"Duplicate","message":"The resource already exists"}"
            동일한 파일명으로 저장시
             */
        }

    }

    private String generateFileName(String originalFileName) {
        // 현재 시간
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

        // 2. 랜덤 텍스트
        String randomText = UUID.randomUUID().toString().substring(0, 8);

        // 3. 확장자
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));

        // 4. 최종 파일명 조합 (예: 20260512_143005_a1b2c3d4.jpg)
        return timestamp + "_" + randomText + extension;
    }
}
