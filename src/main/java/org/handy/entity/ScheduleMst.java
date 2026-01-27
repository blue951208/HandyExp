package org.handy.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "schedule_mst")
@Getter @Setter
public class ScheduleMst {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // DB가 알아서 ID를 만들게 하려면 아래 어노테이션 추가
    @Column(name = "v_schedule_id")
    private String vScheduleId;

    @Column(name = "v_category_id")
    private String vCategoryId;

    @Column(name = "d_target_dtm")
    private LocalDateTime dTargetDtm;

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
