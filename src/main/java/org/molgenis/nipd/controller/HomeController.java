package org.molgenis.nipd.controller;

import static org.molgenis.nipd.controller.HomeController.URI;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.molgenis.framework.ui.MolgenisPluginController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Controller that handles home page requests
 */
@Controller
@RequestMapping(URI)
public class HomeController extends MolgenisPluginController
{
	public static final String ID = "home";
	public static final String URI = MolgenisPluginController.PLUGIN_URI_PREFIX + ID;
	private boolean onMac, onUnix;
	
	public HomeController()
	{
		super(URI);
		
//		OSValidator osValidator = new OSValidator();
		this.onMac = OSValidator.isMac();
		this.onUnix = OSValidator.isUnix();
	}

	@RequestMapping
	public String init()
	{
		return "view-home";
	}

	@RequestMapping(value = "getRisk/{zscore}/{llim}/{ulim}/{apriori}/{varcof:.+}", method = GET, produces = APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getRisk(@PathVariable("zscore") String zscore, @PathVariable("llim") String llim,
			@PathVariable("ulim") String ulim, @PathVariable("apriori") String apriori,
			@PathVariable("varcof") String varcof) throws IOException
	{
		try
		{
			String binary = "No executable";
			if (onMac) binary = "trisomy_risk_mac";
			if (onUnix) binary = "trisomy_risk_unix";
			String pathToBinary = this.getClass().getResource("/tools/" + binary).getPath();
			File workDir = new File(pathToBinary.substring(0, pathToBinary.length() - binary.length()));

			String command = pathToBinary + " " + zscore + " " + llim + " " + ulim + " " + apriori + " " + varcof;

			return "" + Math.round(Double.valueOf(executeCommand(command, workDir)));
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return "Something went wrong!";
		}
	}

	@RequestMapping(value = "getAPrioriRisk/{gestationalAgeWeeks}/{maternalAgeYears}/{trisomyType}", method = GET, produces = APPLICATION_JSON_VALUE)
	@ResponseBody
	public String getAPrioriRisk(@PathVariable("gestationalAgeWeeks") String gestationalAgeWeeks,
			@PathVariable("maternalAgeYears") String maternalAgeYears, @PathVariable("trisomyType") String trisomyType)
			throws IOException
	{
		try
		{
			String binary = "No executable";
			if (onMac) binary = "trisomy_a_priori_risk_mac";
			if (onUnix) binary = "trisomy_a_priori_risk_unix";
			String pathToBinary = this.getClass().getResource("/tools/" + binary).getPath();
			File workDir = new File(pathToBinary.substring(0, pathToBinary.length() - binary.length()));

			String command = pathToBinary + " " + gestationalAgeWeeks + " " + maternalAgeYears + " " + trisomyType;

			// return value x means a chance of 1 in x; but we want to return 1/x
			String value = executeCommand(command, workDir);
			Double chance = 1 / Double.valueOf(value);

			return "" + chance;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return "Improper values!";
		}
	}

	private String executeCommand(String command, File workDir)
	{
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		CommandLine commandline = CommandLine.parse(command);
		DefaultExecutor exec = new DefaultExecutor();
		PumpStreamHandler streamHandler = new PumpStreamHandler(outputStream);
		exec.setStreamHandler(streamHandler);
		exec.setWorkingDirectory(workDir);
		try
		{
			exec.execute(commandline);
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}

		return outputStream.toString().trim();
	}
}
