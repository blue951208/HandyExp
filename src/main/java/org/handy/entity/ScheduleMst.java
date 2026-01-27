package org.handy.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "schedule_mst")
@Getter @Setter
public class ScheduleMst {
    @Id
    @Column(name = "v_schedule_id")
    private String vScheduleId;

    @Column(name = "v_category_id")
    private String vCategoryId;

    @Column(name = "d_target_dtm")
    private String dTargetDtm;

    @Column(name = "v_target_group")
    private String vTargetGroup;

    @Column(name = "v_cont")
    private String vCont;

    @Column(name = "v_private_yn")
    private String vPrivateYn;

    @Column(name = "v_title")
    private String vTitle;

    @Column(name = "v_flag_del")
    private String vFlagDel;

}
