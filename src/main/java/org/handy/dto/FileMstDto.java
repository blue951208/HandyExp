package org.handy.dto;

import lombok.Data;

@Data
public class FileMstDto {
    private String vFid;
    private String vFileNm;
    private String vPath;
    private String vBucketNm;
    private String vContentType;
    private String vFlagDel;
}
