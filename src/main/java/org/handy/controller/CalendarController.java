package org.handy.controller;

import org.handy.dto.ScheduleMstDto;
import org.handy.service.impl.ScheduleMstServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
        List<ScheduleMstDto> list = scheduleMstService.selectScheduleMstList(param);
        System.out.println("list : " + list);
        return mav;
    }

    @PostMapping("/insertScheduleMst")
    @ResponseBody
    public Map<String, Object> insertScheduleMst(ScheduleMstDto dto) {
        Map<String, Object> result = new HashMap<>();

        try {
            scheduleMstService.insertSchedule(dto);
            result.put("status", "success");
            result.put("message", "등록되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "오류가 발생했습니다.");
        }

        return result;
    }

}
