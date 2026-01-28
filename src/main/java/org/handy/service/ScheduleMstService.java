package org.handy.service;

import org.handy.dto.ScheduleMstDto;

import java.util.List;
import java.util.Map;

public interface ScheduleMstService {
    // JPA를 이용한 메서드
    void insertScheduleMst(ScheduleMstDto dto);

    void updateScheduleMst(ScheduleMstDto dto);

    void deleteScheduleMst(String vScheduleId);
}
