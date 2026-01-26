package org.handy.service;

import org.handy.dto.ScheduleMstDto;
import org.handy.mapper.ScheduleMstMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ScheduleMstServiceImpl {

    @Autowired
    private ScheduleMstMapper scheduleMstMapper;

    public List<ScheduleMstDto> selectScheduleMstList(Map<String, Object> param) {
        return scheduleMstMapper.selectScheduleMstList(param);
    }
}
