package org.handy.controller;

import org.handy.dto.ScheduleMstDto;
import org.handy.service.ScheduleMstServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CalendarController {

    @Autowired
    private ScheduleMstServiceImpl scheduleMstService;

    @RequestMapping("/calendar")
    public String calendar() {
        System.out.println("CalendarController.calendar()");
        Map<String, Object> param = new HashMap<>();
        List<ScheduleMstDto> list = scheduleMstService.selectScheduleMstList(param);
        System.out.println("list : " + list);
        return "calendar";
    }

}
