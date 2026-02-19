package org.handy.dto;

import lombok.Data;

@Data
public class ScheduleMstDto {
    private String vScheduleId;
    private String vCategoryId;
    private String dTargetDtm;
    private String vTargetGroup;
    private String vCont;
    private String vPrivateYn;
    private String vFlagDel;
    private String vTitle;
}
