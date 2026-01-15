package org.handy.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CalendarController {

    @RequestMapping("/calendar")
    public String calendar() {
        System.out.println("IndexController.calendar()");
        return "calendar";
    }

}
