package org.handy.controller;

import org.handy.dto.ScheduleMstDto;
import org.handy.service.impl.ScheduleMstServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/calendar")
public class CalendarController {

    @Autowired
    private ScheduleMstServiceImpl scheduleMstService;

    @RequestMapping("")
    public ModelAndView calendar() {
        ModelAndView mav = new ModelAndView();

        mav.setViewName("calendar");

        System.out.println("CalendarController.calendar()");
        Map<String, Object> param = new HashMap<>();
        // 오늘 날짜
        LocalDate now = LocalDate.now();

        // 이달의 일정
        param.put("selType", "month");
        param.put("selectedDate", now.format(DateTimeFormatter.ofPattern("yyyy-MM")));
        List<ScheduleMstDto> monthList = scheduleMstService.selectScheduleMstList(param);
        mav.addObject("monthList", monthList);

        param.put("selType", "day");
        param.put("selectedDate", now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        List<ScheduleMstDto> dayList = scheduleMstService.selectScheduleMstList(param);
        mav.addObject("dayList", dayList);
        return mav;
    }

    @GetMapping("/selectScheduleMstAjax")
    @ResponseBody
    public Map<String, Object> selectScheduleMstAjax(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();

        try {

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    @PostMapping("/insertScheduleMst")
    @ResponseBody
    public Map<String, Object> insertScheduleMst(ScheduleMstDto dto) {
        Map<String, Object> result = new HashMap<>();

        try {
            scheduleMstService.insertScheduleMst(dto);
            result.put("status", "success");
            result.put("message", "등록되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "오류가 발생했습니다.");
        }

        return result;
    }

    @PostMapping("/updateScheduleMst")
    @ResponseBody
    public Map<String, Object> updateScheduleMst(ScheduleMstDto dto) {
        Map<String, Object> result = new HashMap<>();
        try {
            scheduleMstService.updateScheduleMst(dto);
            result.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
        }
        return result;
    }

    @PostMapping("/deleteScheduleMst")
    @ResponseBody
    public Map<String, Object> deleteScheduleMst(@RequestParam("scheduleId") String scheduleId) {
        Map<String, Object> result = new HashMap<>();
        try {
            scheduleMstService.deleteScheduleMst(scheduleId);
            result.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
        }
        return result;
    }

}
