package org.handy.dto;

import lombok.Data;

@Data
public class ScheduleMstDto {
    private String vScheduleId;
    private String vCategoryId;
    private String dTargetDtm;

    private String dTargetSdtm;
    private String dTargetEdtm;

    private String dTargetEdt;
    private String dTargetSdt;

    private String vTargetGroup;
    private String vCont;
    private String vPrivateYn;
    private String vFlagDel;
    private String vTitle;
}
