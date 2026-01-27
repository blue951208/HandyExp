package org.handy.service.impl;

import org.handy.dto.ScheduleMstDto;
import org.handy.entity.ScheduleMst;
import org.handy.mapper.ScheduleMstMapper;
import org.handy.repository.ScheduleMstRepository;
import org.handy.service.ScheduleMstService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Service
public class ScheduleMstServiceImpl implements ScheduleMstService {

    @Autowired
    private ScheduleMstMapper scheduleMstMapper;

    @Autowired
    private ScheduleMstRepository scheduleMstRepository;

    public List<ScheduleMstDto> selectScheduleMstList(Map<String, Object> param) {
        return scheduleMstMapper.selectScheduleMstList(param);
    }

    @Override
    @Transactional // JPA의 저장은 반드시 트랜잭션 안에서 일어나야 합니다.
    public void insertSchedule(ScheduleMstDto dto) {
        System.out.println("dto : "+dto);

        // 1. DTO 데이터를 Entity 객체로 옮겨담습니다.
        ScheduleMst entity = new ScheduleMst();
        entity.setVScheduleId(dto.getVScheduleId());
        entity.setVTitle(dto.getVTitle());
        entity.setVCont(dto.getVCont());

        // 1. 문자열과 일치하는 패턴 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        // 2. 정의한 formatter를 사용하여 파싱
        String dateStr = dto.getDTargetDtm();
        LocalDateTime dateTime = LocalDateTime.parse(dateStr, formatter);

        entity.setDTargetDtm(dateTime);
        entity.setVFlagDel("N");

        // 2. 레포지토리의 save() 메서드 호출 끝! (SQL을 직접 안 써도 됩니다)
        scheduleMstRepository.save(entity);
    }
}
