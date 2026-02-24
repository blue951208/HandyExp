package org.handy.service.impl;

import org.handy.dto.ScheduleMstDto;
import org.handy.entity.ScheduleMst;
import org.handy.mapper.ScheduleMstMapper;
import org.handy.repository.ScheduleMstRepository;
import org.handy.service.ScheduleMstService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDate;
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

    @Override
    public List<ScheduleMstDto> selectScheduleMstList(Map<String, Object> param) {
        // selType 이 month 인 경우 selectedDate 에 해당하는 월에 첫번째 마지막 일을 가져와서 세팅
        if ("month".equals(param.getOrDefault("selType", ""))
            && param.get("selectedDate") != null) {
            String selectedDate = (String) param.get("selectedDate");
            String[] parts = selectedDate.split("-");

            if (parts.length == 2) {
                LocalDate date = LocalDate.of(Integer.parseInt(parts[0]), Integer.parseInt(parts[1]), Integer.parseInt("01"));
                LocalDate firstDayOfMonth = date.withDayOfMonth(1);
                LocalDate lastDayOfMonth = date.withDayOfMonth(date.lengthOfMonth());
                param.put("firstDayOfMonth", firstDayOfMonth.toString());
                param.put("lastDayOfMonth" , lastDayOfMonth.toString());
            }
        }
        return scheduleMstMapper.selectScheduleMstList(param);
    }

    @Override
    @Transactional // JPA의 저장은 반드시 트랜잭션 안에서 일어나야 합니다.
    public void insertScheduleMst(ScheduleMstDto dto) {
        System.out.println("dto : "+dto);

        // 1. DTO 데이터를 Entity 객체로 옮겨담습니다.
        ScheduleMst entity = new ScheduleMst();
        entity.setVScheduleId(dto.getVScheduleId());
        entity.setVTitle(dto.getVTitle());
        entity.setVCont(dto.getVCont());

//        entity.setDTargetDtm(formatDateTime(dto.getDTargetDtm()));
        entity.setDTargetSdtm(formatDateTime(dto.getDTargetSdtm()));
        entity.setDTargetEdtm(formatDateTime(dto.getDTargetEdtm()));
        entity.setVFlagDel("N");

        // 2. 레포지토리의 save() 메서드 호출 끝! (SQL을 직접 안 써도 됩니다)
        scheduleMstRepository.save(entity);
    }

    @Override
    @Transactional
    public void updateScheduleMst(ScheduleMstDto dto) {
        // 1. 기존 데이터 조회 (ID로 찾기)
        ScheduleMst entity = scheduleMstRepository.findById(dto.getVScheduleId())
                .orElseThrow(() -> new RuntimeException("해당 일정을 찾을 수 없습니다."));

        // 2. 객체의 값 변경 (Setter 사용)
        entity.setVTitle(dto.getVTitle());
        entity.setVCont(dto.getVCont());
//        entity.setDTargetDtm(formatDateTime(dto.getDTargetDtm()));
        entity.setDTargetSdtm(formatDateTime(dto.getDTargetSdtm()));
        entity.setDTargetEdtm(formatDateTime(dto.getDTargetEdtm()));

        scheduleMstRepository.save(entity);
    }

    private LocalDateTime formatDateTime(String dateTimeStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, formatter);
        return dateTime;
    }

    @Override
    @Transactional
    public void deleteScheduleMst(String vScheduleId) {
        // ID로 바로 삭제
        scheduleMstRepository.deleteById(vScheduleId);
    }
}
