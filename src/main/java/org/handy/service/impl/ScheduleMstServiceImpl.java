package org.handy.service.impl;

import org.handy.dto.ScheduleMstDto;
import org.handy.entity.ScheduleMst;
import org.handy.mapper.ScheduleMstMapper;
import org.handy.repository.ScheduleMstRepository;
import org.handy.service.ScheduleMstService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
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

        // 1. DTO 데이터를 Entity 객체로 옮겨담습니다.
        ScheduleMst entity = new ScheduleMst();
        entity.setVScheduleId(dto.getVScheduleId());
        entity.setVTitle(dto.getVTitle());
        entity.setVCont(dto.getVCont());
        entity.setDTargetDtm(dto.getDTargetDtm());

        // 2. 레포지토리의 save() 메서드 호출 끝! (SQL을 직접 안 써도 됩니다)
        scheduleMstRepository.save(entity);
    }
}
