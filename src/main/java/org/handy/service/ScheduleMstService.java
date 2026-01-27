package org.handy.service;

import org.handy.dto.ScheduleMstDto;

import java.util.List;
import java.util.Map;

public interface ScheduleMstService {
    List<ScheduleMstDto> selectScheduleMstList(Map<String, Object> param);

    void insertSchedule(ScheduleMstDto dto); // JPA를 이용한 추가 메서드
}
