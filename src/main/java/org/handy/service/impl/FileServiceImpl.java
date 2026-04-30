package org.handy.service.impl;

import org.handy.service.FileService;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class FileServiceImpl implements FileService {

    private final String PROJECT_URL = "https://bvukavwhtdgxgwlglenv.supabase.co";
    private final String apiKey = "sb_publishable_IWeD_C_wgH1kir6DEzjVtw__Ukkva81";

    @Override
    public String uploadFile(MultipartFile file, String bucketNm) throws IOException {
        String fileName = file.getOriginalFilename();
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
        HttpEntity<byte[]> entity = new HttpEntity<>(file.getBytes(), headers);

        // 5. POST 요청 실행
        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                return "업로드 성공: " + response.getBody();
            } else {
                return "업로드 실패: " + response.getStatusCode();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "에러 발생: " + e.getMessage();
        }

    }

}
