package com.edu.exe;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	//@RequestMapping(value = "/", method = RequestMethod.GET)
	@RequestMapping("search")
	public String serch(Locale locale, Model model) {
		logger.info("Search Control", locale);

		
		return "search01";
	}
	@RequestMapping("save")
	public String save(Locale locale, Model model) {
		logger.info("Save Control", locale);

		
		return "save01";
	}
	
	
}
