package org.handy.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.handy.dto.ScheduleMstDto;

import java.util.List;
import java.util.Map;

@Mapper
public interface ScheduleMstMapper {
    // 일정 목록 조회
    List<ScheduleMstDto> selectScheduleMstList(Map<String, Object> params);
}
